import 'dart:async';
import 'dart:io';

import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/doctor/home/data/models/End_Appointment_Request_Model.dart';
import 'package:aleef/features/doctor/home/data/models/confirmed_appointment_model.dart';
import 'package:aleef/features/doctor/home/presentation/manager/appointment_management_provider.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/appointment_management/medical_record_card.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/appointment_management/pet_appointment_card.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/appointment_management/upcoming_vaccination_card.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/appointment_management/vaccination_card.dart';
import 'package:aleef/features/pets/data/models/pet_model.dart';
import 'package:aleef/features/pets/presentation/pages/pet_profile_screen.dart';
import 'package:aleef/features/pets/services/pets_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../Performance/presentation/manager/doctor_performance_provider.dart';
import '../manager/doctor_appointment_provider.dart';
import '../manager/doctor_confirmed_appointments_provider.dart';

class AppointmentManagementScreen extends StatefulWidget {
  final ConfirmedAppointmentModel appointment;

  const AppointmentManagementScreen({
    super.key,
    required this.appointment,
  });

  @override
  State<AppointmentManagementScreen> createState() =>
      _AppointmentManagementScreenState();
}

class _AppointmentManagementScreenState
    extends State<AppointmentManagementScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _chatDaysController = TextEditingController();

  final TextEditingController _vaccineNameController =
  TextEditingController();
  final TextEditingController _vaccineDoseController =
  TextEditingController();
  final TextEditingController _vaccineNotesController =
  TextEditingController();

  final TextEditingController _upcomingVaccineNameController =
  TextEditingController();
  final TextEditingController _nextDueDateController =
  TextEditingController();

  final List<File> _selectedAttachments = [];

  bool _isOpeningPetProfile = false;
  bool _isCancellingAppointment = false;

  @override
  void dispose() {
    _titleController.dispose();
    _conditionController.dispose();
    _descController.dispose();
    _chatDaysController.dispose();

    _vaccineNameController.dispose();
    _vaccineDoseController.dispose();
    _vaccineNotesController.dispose();
    _upcomingVaccineNameController.dispose();
    _nextDueDateController.dispose();

    super.dispose();
  }

  Future<void> _pickAttachments() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result == null || result.files.isEmpty) return;

    final pickedFiles = result.files
        .where((file) => file.path != null)
        .map((file) => File(file.path!))
        .toList();

    setState(() {
      _selectedAttachments.addAll(pickedFiles);
    });
  }

  void _removeAttachment(int index) {
    setState(() {
      _selectedAttachments.removeAt(index);
    });
  }

  Future<void> _openPetProfile() async {
    if (_isOpeningPetProfile) return;

    final appointmentPet = widget.appointment.pet;
    final petId = appointmentPet.id.trim();

    if (petId.isEmpty) {
      _showSnackBar('Pet id is missing.');
      return;
    }

    setState(() {
      _isOpeningPetProfile = true;
    });

    try {
      final responseData = await PetsService().getPetByIdWithoutToken(petId);

      final fixedResponse = Map<String, dynamic>.from(responseData);

      if (fixedResponse['pet'] is Map) {
        fixedResponse['pet'] = {
          ...Map<String, dynamic>.from(fixedResponse['pet'] as Map),
          'id': petId,
        };
      } else {
        fixedResponse['id'] = petId;
      }

      final petModel = PetModel.fromJson(fixedResponse);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PetProfileScreen(
            pet: petModel,
            readOnly: true,
          ),
        ),
      );
    } catch (e) {
      debugPrint('OPEN PET PROFILE ERROR: $e');

      if (!mounted) return;

      _showSnackBar('Failed to load pet profile.');
    } finally {
      if (!mounted) return;

      setState(() {
        _isOpeningPetProfile = false;
      });
    }
  }

  Future<void> _completeAppointment() async {
    final title = _titleController.text.trim();
    final condition = _conditionController.text.trim();
    final description = _descController.text.trim();
    final chatDaysText = _chatDaysController.text.trim();

    final vaccineName = _vaccineNameController.text.trim();
    final vaccineDose = _vaccineDoseController.text.trim();
    final vaccineNotes = _vaccineNotesController.text.trim();

    final upcomingVaccineName = _upcomingVaccineNameController.text.trim();
    final nextDueDate = _nextDueDateController.text.trim();

    if (title.isEmpty ||
        condition.isEmpty ||
        description.isEmpty ||
        chatDaysText.isEmpty) {
      _showSnackBar('Please fill all required medical record fields.');
      return;
    }

    final chatExpiryDays = int.tryParse(chatDaysText);

    if (chatExpiryDays == null || chatExpiryDays <= 0) {
      _showSnackBar('Please enter a valid number of chat expiry days.');
      return;
    }

    final hasVaccination = vaccineName.isNotEmpty ||
        vaccineDose.isNotEmpty ||
        vaccineNotes.isNotEmpty;

    final hasUpcomingVaccination =
        upcomingVaccineName.isNotEmpty || nextDueDate.isNotEmpty;

    if (hasVaccination &&
        (vaccineName.isEmpty || vaccineDose.isEmpty || vaccineNotes.isEmpty)) {
      _showSnackBar(
        'Please complete all vaccination fields or leave them empty.',
      );
      return;
    }

    if (hasUpcomingVaccination &&
        (upcomingVaccineName.isEmpty || nextDueDate.isEmpty)) {
      _showSnackBar(
        'Please complete all upcoming vaccination fields or leave them empty.',
      );
      return;
    }

    final provider = context.read<AppointmentManagementProvider>();

    final success = await provider.endAppointment(
      appointmentId: widget.appointment.id,
      requestModel: EndAppointmentRequestModel(
        chatExpiryDays: chatExpiryDays,
        medicalRecord: MedicalRecordModel(
          title: title,
          condition: condition,
          description: description,
        ),
        vaccination: hasVaccination
            ? VaccinationModel(
          vaccineName: vaccineName,
          dose: vaccineDose,
          notes: vaccineNotes,
        )
            : null,
        upComingVaccination: hasUpcomingVaccination
            ? UpComingVaccinationModel(
          vaccineName: upcomingVaccineName,
          nextDueDate: nextDueDate,
        )
            : null,
        attachments: _selectedAttachments.isEmpty ? null : _selectedAttachments,
      ),
    );

    if (!mounted) return;

    if (success == true) {
      final confirmedProvider =
      context.read<DoctorConfirmedAppointmentsProvider>();

      final performanceProvider = context.read<DoctorPerformanceProvider>();

      confirmedProvider.removeAppointmentLocally(widget.appointment.id);

      unawaited(confirmedProvider.refreshCurrentAppointments());
      unawaited(performanceProvider.getDoctorPerformance());
      unawaited(performanceProvider.getWalletTransactions());

      _showSnackBar('Appointment completed successfully.');

      await Future.delayed(const Duration(milliseconds: 350));

      if (!mounted) return;

      Navigator.pop(context, true);
    } else {
      _showSnackBar(
        provider.errorMessage ?? 'Failed to complete appointment.',
      );
    }
  }

  Future<String?> _showCancelReasonDialog() async {
    final TextEditingController reasonController = TextEditingController();
    String? errorText;

    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 26,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 58.w,
                        height: 58.w,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.10),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.event_busy_rounded,
                          color: Colors.red.shade600,
                          size: 30.sp,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Text(
                        'Cancel Appointment',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF001533),
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Please write a clear reason for cancelling this appointment. This reason may be visible to the pet owner.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                          height: 1.45,
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Cancellation Reason',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextField(
                        controller: reasonController,
                        maxLines: 4,
                        minLines: 4,
                        textInputAction: TextInputAction.newline,
                        onChanged: (_) {
                          if (errorText != null) {
                            setDialogState(() {
                              errorText = null;
                            });
                          }
                        },
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF111827),
                          height: 1.35,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Example: Doctor is unavailable today',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          errorText: errorText,
                          errorMaxLines: 2,
                          filled: true,
                          fillColor: const Color(0xFFF7FAFA),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 13.h,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.r),
                            borderSide: BorderSide(
                              color: Colors.grey.shade200,
                              width: 1.w,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.r),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 1.4.w,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.r),
                            borderSide: BorderSide(
                              color: Colors.red.shade400,
                              width: 1.2.w,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.r),
                            borderSide: BorderSide(
                              color: Colors.red.shade400,
                              width: 1.2.w,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 46.h,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFFF3F6F6),
                                  foregroundColor: Colors.grey.shade800,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                ),
                                child: Text(
                                  'Back',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 46.h,
                              child: ElevatedButton(
                                onPressed: () {
                                  final reason = reasonController.text.trim();

                                  if (reason.isEmpty) {
                                    setDialogState(() {
                                      errorText =
                                      'Cancellation reason is required';
                                    });
                                    return;
                                  }

                                  if (reason.length < 5) {
                                    setDialogState(() {
                                      errorText =
                                      'Please write a more clear reason';
                                    });
                                    return;
                                  }

                                  Navigator.pop(dialogContext, reason);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade600,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                ),
                                child: Text(
                                  'Cancel Appointment',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    return result;
  }

  Future<void> _cancelAppointment() async {
    if (_isCancellingAppointment) return;

    final appointmentId = widget.appointment.id.trim();

    if (appointmentId.isEmpty) {
      _showSnackBar(
        'Appointment id is missing.',
        isError: true,
      );
      return;
    }

    final reason = await _showCancelReasonDialog();

    if (reason == null || reason.trim().isEmpty) return;

    if (!mounted) return;

    setState(() {
      _isCancellingAppointment = true;
    });

    try {
      final doctorAppointmentsProvider =
      context.read<DoctorAppointmentsProvider>();

      final errorMessage = await doctorAppointmentsProvider.rejectAppointment(
        appointmentId: appointmentId,
        rejectionReason: reason.trim(),
      );

      if (!mounted) return;

      if (errorMessage == null) {
        final confirmedProvider =
        context.read<DoctorConfirmedAppointmentsProvider>();

        final performanceProvider = context.read<DoctorPerformanceProvider>();

        confirmedProvider.removeAppointmentLocally(appointmentId);

        unawaited(confirmedProvider.refreshCurrentAppointments());
        unawaited(performanceProvider.getDoctorPerformance());
        unawaited(performanceProvider.getWalletTransactions());

        _showSnackBar(
          'Appointment cancelled successfully.',
          isError: false,
        );

        await Future.delayed(const Duration(milliseconds: 350));

        if (!mounted) return;

        Navigator.pop(context, true);
      } else {
        _showSnackBar(
          errorMessage,
          isError: true,
        );
      }
    } catch (e) {
      if (!mounted) return;

      _showSnackBar(
        'Failed to cancel appointment.',
        isError: true,
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isCancellingAppointment = false;
      });
    }
  }

  void _showSnackBar(
      String message, {
        bool isError = false,
      }) {
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
        margin: EdgeInsets.all(16.w),
        duration: const Duration(seconds: 2),
        content: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 12.h,
          ),
          decoration: BoxDecoration(
            color: isError ? Colors.red.shade600 : AppColors.primary,
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isError
                      ? Icons.error_outline_rounded
                      : Icons.check_rounded,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatAppointmentDate(String? date, String? time) {
    final formattedTime =
    time == null || time.trim().isEmpty ? '' : _formatTime(time);

    if (date == null || date.trim().isEmpty) {
      return formattedTime.isEmpty ? 'Not specified' : formattedTime;
    }

    final parsedDate = DateTime.tryParse(date);

    if (parsedDate == null) {
      if (formattedTime.isEmpty) return date;
      return '$date at $formattedTime';
    }

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    final dayName = days[parsedDate.weekday - 1];
    final monthName = months[parsedDate.month - 1];

    final formattedDate =
        '$dayName, $monthName ${parsedDate.day}, ${parsedDate.year}';

    if (formattedTime.isEmpty) return formattedDate;

    return '$formattedDate at $formattedTime';
  }

  String _formatTime(String time24) {
    try {
      if (time24.trim().isEmpty) return 'No time';

      final parts = time24.split(':');
      if (parts.length < 2) return time24;

      final hour = int.parse(parts[0]);
      final minute = parts[1];

      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

      return '$displayHour:$minute $period';
    } catch (_) {
      return time24;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointment = widget.appointment;

    return Consumer<AppointmentManagementProvider>(
      builder: (context, provider, child) {
        final bool isBusy =
            provider.isLoading || _isOpeningPetProfile || _isCancellingAppointment;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: AppBar(
            title: const Text(
              'Appointment Management',
              style: TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF001533),
            elevation: 0,
            surfaceTintColor: Colors.white,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PetAppointmentCard(
                    petName: appointment.pet.name,
                    petType: appointment.pet.type,
                    petBreed: appointment.pet.breed,
                    petImage: appointment.pet.profilePic,
                    age: appointment.pet.age,
                    weight: appointment.pet.weight,
                    gender: appointment.pet.gender,
                    ownerName: appointment.owner.name,
                    ownerPhone: appointment.owner.phone,
                    appointmentDate: _formatAppointmentDate(
                      appointment.date,
                      appointment.time,
                    ),
                    reason: appointment.reason,
                    onPetProfileTap: isBusy
                        ? null
                        : () {
                      unawaited(_openPetProfile());
                    },
                  ),

                  SizedBox(height: 18.h),

                  MedicalRecordCard(
                    titleController: _titleController,
                    conditionController: _conditionController,
                    descController: _descController,
                    chatDaysController: _chatDaysController,
                    selectedAttachments: _selectedAttachments,
                    onPickAttachments: _pickAttachments,
                    onRemoveAttachment: _removeAttachment,
                  ),

                  SizedBox(height: 16.h),

                  VaccinationCard(
                    vaccineNameController: _vaccineNameController,
                    doseController: _vaccineDoseController,
                    notesController: _vaccineNotesController,
                  ),

                  SizedBox(height: 16.h),

                  UpcomingVaccinationCard(
                    vaccineNameController: _upcomingVaccineNameController,
                    nextDueDateController: _nextDueDateController,
                  ),

                  SizedBox(height: 26.h),

                  SizedBox(
                    height: 56.h,
                    child: ElevatedButton.icon(
                      onPressed: isBusy ? null : _completeAppointment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor:
                        AppColors.primary.withOpacity(0.55),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      icon: provider.isLoading
                          ? SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : Icon(
                        Icons.check_circle_outline_rounded,
                        size: 24.sp,
                      ),
                      label: Text(
                        provider.isLoading
                            ? 'Completing...'
                            : 'Complete Appointment',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 14.h),

                  SizedBox(
                    height: 56.h,
                    child: OutlinedButton.icon(
                      onPressed: isBusy ? null : _cancelAppointment,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: BorderSide(
                          color: Colors.red,
                          width: 1.3.w,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      icon: _isCancellingAppointment
                          ? SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.red,
                        ),
                      )
                          : Icon(
                        Icons.cancel_outlined,
                        size: 22.sp,
                      ),
                      label: Text(
                        _isCancellingAppointment
                            ? 'Cancelling...'
                            : 'Cancel Appointment',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
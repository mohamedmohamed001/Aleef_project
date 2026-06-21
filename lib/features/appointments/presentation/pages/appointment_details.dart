import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:aleef/features/chat/presentation/pages/chat_details.dart';
import 'package:aleef/features/home/presentation/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../provider/appointment_provider.dart';
import '../widgets/appointment_details/appointment_details_action_buttons.dart';
import '../widgets/appointment_details/appointment_details_doctor_header.dart';
import '../widgets/appointment_details/appointment_details_error_state.dart';
import '../widgets/appointment_details/appointment_details_loading_view.dart';
import '../widgets/appointment_details/appointment_time_line.dart';
import '../widgets/appointment_details/cancel_appointment_sheet.dart';
import '../widgets/appointment_details/ِappointment_details_card.dart';

class AppointmentDetails extends StatefulWidget {
  final String appointmentId;

  const AppointmentDetails({
    super.key,
    required this.appointmentId,
  });

  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  late AppointmentProvider _appointmentProvider;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<AppointmentProvider>().getAppointmentDetails(
        widget.appointmentId,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appointmentProvider = context.read<AppointmentProvider>();
  }

  @override
  void dispose() {
    _appointmentProvider.clearAppointmentDetails();
    super.dispose();
  }

  Future<void> _refreshAppointmentDetails() async {
    await context.read<AppointmentProvider>().getAppointmentDetails(
      widget.appointmentId,
    );
  }

  Future<void> _cancelAppointment(String reason) async {
    final provider = context.read<AppointmentProvider>();
    final appointment = provider.appointmentDetails;

    if (appointment.id == null) return;

    final success = await provider.cancelAppointment(
      appointmentId: appointment.id!,
      reason: reason,
    );

    if (!mounted) return;

    if (success) {
      await _refreshHomeAppointment();

      if (!mounted) return;

      _showSuccessSnackBar("Appointment cancelled successfully");

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      Navigator.pop(context, true);
      return;
    }

    _showErrorSnackBar(
      provider.cancelAppointmentError ?? "Something went wrong",
    );
  }

  Future<void> _refreshHomeAppointment() async {
    try {
      await context.read<HomeProvider>().fetchCurrentAppointment(
        onUnauthorized: () async {},
      );
    } catch (error) {
      debugPrint('Refresh home appointment after cancel error: $error');
    }
  }

  void _openChat(String? chatId) {
    if (chatId == null || chatId.isEmpty) {
      _showErrorSnackBar("Chat is not available for this appointment");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatDetails(
          chatId: chatId,
        ),
      ),
    );
  }

  void _showCancelSheet() {
    showCancelAppointmentSheet(
      context: context,
      onConfirm: _cancelAppointment,
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Appointment Details',
          style: AppTextStyles.black16Bold.copyWith(fontSize: 18.sp),
        ),
      ),
      body: Consumer<AppointmentProvider>(
        builder: (context, provider, _) {
          if (provider.isAppointmentDetailsLoading) {
            return const AppointmentDetailsLoadingView();
          }

          final appointment = provider.appointmentDetails;

          if (appointment.id == null) {
            return AppointmentDetailsErrorState(
              message:
              provider.appointmentDetailsError ?? "Something went wrong",
              onRetry: _refreshAppointmentDetails,
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshAppointmentDetails,
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                children: [
                  AppointmentDetailsDoctorHeader(appointment: appointment),
                  SizedBox(height: 16.h),
                  AppointmentDetailsCard(appointment: appointment),
                  SizedBox(height: 16.h),
                  AppointmentTimeLine(appointment: appointment),
                  SizedBox(height: 24.h),
                  AppointmentDetailsActionButtons(
                    appointment: appointment,
                    onChatTap: () => _openChat(appointment.chatId),
                    onCancelTap: _showCancelSheet,
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
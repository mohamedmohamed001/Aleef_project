import 'dart:io';

import 'package:aleef/core/widgets/app_snack_bar.dart';
import 'package:aleef/features/doctor/home/presentation/manager/doctor_profile_provider.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/doctor_edit_text_field.dart';
import 'package:aleef/features/doctor/profile/presentation/widgets/edit_profile/doctor_edit_profile_header.dart';
import 'package:aleef/features/doctor/profile/presentation/widgets/edit_profile/doctor_edit_profile_loading_overlay.dart';
import 'package:aleef/features/doctor/profile/presentation/widgets/edit_profile/doctor_edit_profile_save_button.dart';
import 'package:aleef/features/doctor/profile/presentation/widgets/edit_profile/doctor_edit_profile_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class DoctorEditProfileScreen extends StatefulWidget {
  const DoctorEditProfileScreen({super.key});

  @override
  State<DoctorEditProfileScreen> createState() =>
      _DoctorEditProfileScreenState();
}

class _DoctorEditProfileScreenState extends State<DoctorEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  late final TextEditingController _nameController;
  late final TextEditingController _specializationController;
  late final TextEditingController _cityController;
  late final TextEditingController _clinicAddressController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _aboutController;
  late final TextEditingController _appointmentFeeController;

  File? _selectedImage;
  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();

    final doctor = context.read<DoctorProfileProvider>().doctorProfile;

    _nameController = TextEditingController(text: doctor?.name ?? '');
    _specializationController = TextEditingController(
      text: doctor?.specialization ?? '',
    );
    _cityController = TextEditingController(text: doctor?.city ?? '');
    _phoneController = TextEditingController(text: doctor?.phone ?? '');
    _emailController = TextEditingController(text: doctor?.email ?? '');
    _aboutController = TextEditingController(text: doctor?.about ?? '');
    _clinicAddressController = TextEditingController(
      text: doctor?.address ?? '',
    );
    _appointmentFeeController = TextEditingController(
      text: (doctor?.appointmentFee ?? 0) > 0
          ? doctor!.appointmentFee.toString()
          : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specializationController.dispose();
    _cityController.dispose();
    _clinicAddressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _aboutController.dispose();
    _appointmentFeeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_isPickingImage) return;

    FocusScope.of(context).unfocus();

    setState(() => _isPickingImage = true);

    await Future.delayed(const Duration(milliseconds: 120));

    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (!mounted) return;

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (_) {
      if (!mounted) return;

      AppSnackBar.show(
        context,
        message: 'Could not open gallery. Please try again.',
        type: AppSnackBarType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isPickingImage = false);
      }
    }
  }

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _feeValidator(String? value) {
    final feeText = value?.trim() ?? '';

    if (feeText.isEmpty) {
      return 'Appointment fee is required';
    }

    final fee = int.tryParse(feeText);

    if (fee == null) {
      return 'Enter a valid number';
    }

    if (fee <= 0) {
      return 'Fee must be greater than 0';
    }

    if (fee > 100000) {
      return 'Fee is too high';
    }

    return null;
  }

  Future<void> _saveProfileChanges() async {
    if (!_formKey.currentState!.validate()) {
      AppSnackBar.show(
        context,
        message: 'Please complete the required fields.',
        type: AppSnackBarType.warning,
      );
      return;
    }

    FocusScope.of(context).unfocus();

    final bodyData = {
      'name': _nameController.text.trim(),
      'specialization': _specializationController.text.trim(),
      'city': _cityController.text.trim(),
      'phone': _phoneController.text.trim(),
      'about': _aboutController.text.trim(),
      'address': _clinicAddressController.text.trim(),
      'appointmentFee': _appointmentFeeController.text.trim(),
    };

    final provider = context.read<DoctorProfileProvider>();

    final success = await provider.updateProfile(
      bodyData: bodyData,
      imageFile: _selectedImage,
    );

    if (!mounted) return;

    if (success) {
      AppSnackBar.show(
        context,
        message: 'Profile updated successfully.',
        type: AppSnackBarType.success,
      );

      await Future.delayed(const Duration(milliseconds: 450));

      if (!mounted) return;
      Navigator.pop(context, true);
      return;
    }

    AppSnackBar.show(
      context,
      message: provider.errorMessage ?? 'Update failed.',
      type: AppSnackBarType.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DoctorProfileProvider>();
    final doctor = provider.doctorProfile;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      body: Stack(
        children: [
          CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverToBoxAdapter(
                child: DoctorEditProfileHeader(
                  currentImageUrl: doctor?.profilePic ?? '',
                  selectedImage: _selectedImage,
                  isPickingImage: _isPickingImage,
                  onBackTap: () => Navigator.pop(context, false),
                  onImageTap: _pickImage,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 24.h),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DoctorEditProfileSection(
                          title: 'Personal Information',
                          icon: Icons.person_outline_rounded,
                          child: Column(
                            children: [
                              DoctorEditTextField(
                                label: 'Full Name',
                                controller: _nameController,
                                keyboardType: TextInputType.name,
                                validator: (value) =>
                                    _requiredValidator(value, 'Full name'),
                              ),
                              SizedBox(height: 12.h),
                              DoctorEditTextField(
                                label: 'Specialization',
                                controller: _specializationController,
                                validator: (value) => _requiredValidator(
                                  value,
                                  'Specialization',
                                ),
                              ),
                              SizedBox(height: 12.h),
                              DoctorEditTextField(
                                label: 'City',
                                controller: _cityController,
                                validator: (value) =>
                                    _requiredValidator(value, 'City'),
                              ),
                            ],
                          ),
                        ),
                        DoctorEditProfileSection(
                          title: 'Contact Information',
                          icon: Icons.call_outlined,
                          child: Column(
                            children: [
                              DoctorEditTextField(
                                label: 'Phone Number',
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                validator: (value) =>
                                    _requiredValidator(value, 'Phone number'),
                              ),
                              SizedBox(height: 12.h),
                              DoctorEditTextField(
                                label: 'Email Address',
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                enabled: false,
                              ),
                            ],
                          ),
                        ),
                        DoctorEditProfileSection(
                          title: 'Clinic Details',
                          icon: Icons.local_hospital_outlined,
                          child: Column(
                            children: [
                              DoctorEditTextField(
                                label: 'Clinic Address',
                                controller: _clinicAddressController,
                                maxLines: 2,
                                validator: (value) => _requiredValidator(
                                  value,
                                  'Clinic address',
                                ),
                              ),
                              SizedBox(height: 12.h),
                              DoctorEditTextField(
                                label: 'Appointment Fee',
                                controller: _appointmentFeeController,
                                keyboardType: TextInputType.number,
                                validator: _feeValidator,
                              ),
                            ],
                          ),
                        ),
                        DoctorEditProfileSection(
                          title: 'About',
                          icon: Icons.info_outline_rounded,
                          child: DoctorEditTextField(
                            label: 'Professional Bio',
                            controller: _aboutController,
                            maxLines: 4,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        DoctorEditProfileSaveButton(
                          isLoading: provider.isUpdating,
                          onTap: _saveProfileChanges,
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_isPickingImage || provider.isUpdating)
            DoctorEditProfileLoadingOverlay(
              message:
              _isPickingImage ? 'Opening gallery...' : 'Saving changes...',
            ),
        ],
      ),
    );
  }
}
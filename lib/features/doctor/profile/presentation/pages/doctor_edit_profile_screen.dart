import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/doctor/home/presentation/manager/doctor_profile_provider.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/doctor_edit_section_card.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/doctor_edit_text_field.dart';

class DoctorEditProfileScreen extends StatefulWidget {
  const DoctorEditProfileScreen({super.key});

  @override
  State<DoctorEditProfileScreen> createState() =>
      _DoctorEditProfileScreenState();
}

class _DoctorEditProfileScreenState extends State<DoctorEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _specializationController;
  late TextEditingController _cityController;
  late TextEditingController _clinicAddressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _aboutController;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final doctor = Provider.of<DoctorProfileProvider>(
      context,
      listen: false,
    ).doctorProfile;

    _nameController = TextEditingController(text: doctor?.name ?? '');
    _specializationController = TextEditingController(
      text: doctor?.specialization ?? '',
    );
    _cityController = TextEditingController(text: doctor?.city ?? '');

    _phoneController = TextEditingController(text: doctor?.phone ?? '');
    _emailController = TextEditingController(text: doctor?.email ?? '');
    _aboutController = TextEditingController(text: doctor?.about ?? '');
    _clinicAddressController = TextEditingController(
      text: doctor?.clinicAddress ?? '',
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
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfileChanges() async {
    if (!_formKey.currentState!.validate()) return;

    // 1. تجميع البيانات (استبعاد الإيميل وتصحيح اسم الـ controller)
    final Map<String, String> bodyData = {
      'name': _nameController.text.trim(),
      'specialization': _specializationController.text.trim(),
      'city': _cityController.text.trim(), // تم التصحيح هنا
      'phone': _phoneController.text.trim(),
      'about': _aboutController.text.trim(),
      'address': _clinicAddressController.text.trim(),
    }; // إضافة العنوان فقط إذا كان موجوداً

    print("Data to send: $bodyData");

    final provider = Provider.of<DoctorProfileProvider>(context, listen: false);

    // 2. إرسال البيانات
    final success = await provider.updateProfile(
      bodyData: bodyData,
      imageFile: _selectedImage,
    );

    if (success && mounted) {
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Update failed.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctor = Provider.of<DoctorProfileProvider>(context).doctorProfile;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          // التعديل هنا: يفضل لو رجع باك عادي من غير ما يحفظ نرجع بـ false أو null
          onPressed: () => Navigator.pop(context, false),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<DoctorProfileProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildImagePickerHeader(doctor?.profilePic ?? ''),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    child: Column(
                      children: [
                        DoctorEditSectionCard(
                          title: 'PERSONAL INFORMATION',
                          children: [
                            DoctorEditTextField(
                              label: 'Full Name',
                              controller: _nameController,
                              keyboardType: TextInputType.name,
                            ),
                            SizedBox(height: 12.h),
                            DoctorEditTextField(
                              label: 'Specialization',
                              controller: _specializationController,
                            ),
                            SizedBox(height: 12.h),
                            DoctorEditTextField(
                              label: 'City',
                              controller: _cityController,
                            ),
                          ],
                        ),
                        DoctorEditSectionCard(
                          title: 'CONTACT INFORMATION',
                          children: [
                            DoctorEditTextField(
                              label: 'Phone Number',
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                            ),
                            SizedBox(height: 12.h),
                            DoctorEditTextField(
                              label: 'Email Address',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        DoctorEditTextField(
                          label: 'Clinic Address (Optional)',
                          controller: _clinicAddressController,
                        ),
                        DoctorEditSectionCard(
                          title: 'ABOUT',
                          children: [
                            DoctorEditTextField(
                              label: 'Professional Bio',
                              controller: _aboutController,
                              maxLines: 4,
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: provider.isUpdating
                                ? null
                                : _saveProfileChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                            ),
                            child: provider.isUpdating
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    'Save Changes',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImagePickerHeader(String currentImageUrl) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              height: 180.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32.r),
                  bottomRight: Radius.circular(32.r),
                ),
              ),
            ),
            SizedBox(height: 70.h),
          ],
        ),
        Positioned(
          top: 100.h,
          child: Container(
            padding: EdgeInsets.all(16.w),
            width: 325.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 46.r,
                      backgroundColor: Colors.grey[100],
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : (currentImageUrl.isNotEmpty
                                    ? NetworkImage(
                                        currentImageUrl +
                                            "?t=${DateTime.now().microsecondsSinceEpoch}",
                                      )
                                    : const AssetImage(
                                        'assets/images/default_doctor.png',
                                      ))
                                as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 15.r,
                          backgroundColor: AppColors.primary,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  'Tap to change profile photo',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/image_picker_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/session_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../services/profile_api.dart';
import '../widgets/edit_profile/edit_profile_avatar_section.dart';
import '../widgets/edit_profile/edit_profile_form_section.dart';
import '../widgets/edit_profile/edit_profile_save_button.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _editName = TextEditingController();
  final TextEditingController _editPhone = TextEditingController();

  final SessionService session = getIt<SessionService>();

  bool _isLoading = false;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _init();
    _fillFromSession();
  }

  void _fillFromSession() {
    final user = session.currentUser;
    if (user != null) {
      _editName.text = user.name;
      _editPhone.text = user.phone;
    }
  }

  Future<void> _init() async {
    final storage = getIt<SecureStorageService>();

    final user = await storage.getUser();
    final token = await storage.getToken();

    if (user != null && token != null && token.isNotEmpty) {
      session.setSession(user: user, tokenValue: token);
      debugPrint("User موجود ✅");
    } else {
      debugPrint("User مش موجود ❌");
    }

    if (!mounted) return;

    setState(() {
      final currentUser = session.currentUser;
      if (currentUser != null) {
        _editName.text = currentUser.name;
        _editPhone.text = currentUser.phone;
      }
    });
  }

  Future<void> _pickImage({required bool fromCamera}) async {
    try {
      final imagePickerService = ImagePickerService();

      final File? file = fromCamera
          ? await imagePickerService.pickFromCamera()
          : await imagePickerService.pickFromGallery();

      if (file == null) return;

      setState(() {
        _selectedImage = file;
      });
    } catch (e) {
      debugPrint("Pick image error: $e");

      if (!mounted) return;

      _showSnackBar(
        message: "Error picking image: $e",
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _showImageSourceSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text("Camera"),
                onTap: () async {
                  Navigator.of(bottomSheetContext).pop();
                  await Future.delayed(const Duration(milliseconds: 200));
                  await _pickImage(fromCamera: true);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text("Gallery"),
                onTap: () async {
                  Navigator.of(bottomSheetContext).pop();
                  await Future.delayed(const Duration(milliseconds: 200));
                  await _pickImage(fromCamera: false);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _removeProfilePhoto() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: const Text("Remove Photo"),
          content: const Text(
            "Are you sure you want to remove your profile picture?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text("Remove"),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    if (_selectedImage != null) {
      setState(() {
        _selectedImage = null;
      });

      _showSnackBar(
        message: "Selected image removed",
      );
      return;
    }

    final success = await ProfileApi().removeProfilePic();

    if (!mounted) return;

    if (success) {
      await _init();

      if (!mounted) return;

      _showSnackBar(
        message: "Profile picture removed",
        backgroundColor: Colors.green,
      );
    } else {
      _showSnackBar(
        message: "Failed to remove profile picture",
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    final success = await ProfileApi().editProfileWithImage(
      name: _editName.text.trim(),
      phone: _editPhone.text.trim(),
      imageFile: _selectedImage,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      await _init();

      if (!mounted) return;

      _showSnackBar(
        message: 'Profile updated successfully',
        backgroundColor: Colors.green,
      );

      Navigator.pop(context, true);
    } else {
      _showSnackBar(
        message: 'Failed to update profile',
        backgroundColor: Colors.red,
      );
    }
  }

  void _showSnackBar({
    required String message,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10.r),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _editName.dispose();
    _editPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = session.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F5F7),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF1F2937),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),

              EditProfileAvatarSection(
                selectedImage: _selectedImage,
                profileImageUrl: user?.profilePic,
                onPickImage: _showImageSourceSheet,
                onRemoveImage: _removeProfilePhoto,
              ),

              SizedBox(height: 28.h),

              EditProfileFormSection(
                nameController: _editName,
                phoneController: _editPhone,
              ),

              SizedBox(height: 36.h),

              EditProfileSaveButton(
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _saveChanges,
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
import 'dart:io';

import 'package:aleef/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/image_picker_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/session_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../services/profile_api.dart';

class EditProfileProvider extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final SessionService session = getIt<SessionService>();

  bool isLoading = false;
  File? selectedImage;

  Future<void> init(BuildContext context) async {
    selectedImage = null;

    final storage = getIt<SecureStorageService>();

    final user = await storage.getUser();
    final token = await storage.getToken();

    if (user != null && token != null && token.isNotEmpty) {
      session.setSession(user: user, tokenValue: token);

      if (context.mounted) {
        context.read<UserProvider>().setUser(user);
      }
    } else {
      if (context.mounted) {
        context.read<UserProvider>().clearUser();
      }
    }

    final currentUser = session.currentUser;

    if (currentUser != null) {
      nameController.text = currentUser.name;
      phoneController.text = currentUser.phone;
    }

    notifyListeners();
  }

  Future<void> pickImage({
    required BuildContext context,
    required bool fromCamera,
  }) async {
    try {
      final imagePickerService = ImagePickerService();

      final File? file = fromCamera
          ? await imagePickerService.pickFromCamera()
          : await imagePickerService.pickFromGallery();

      if (file == null) return;

      selectedImage = file;
      notifyListeners();
    } catch (e) {
      if (!context.mounted) return;

      showSnackBar(
        context: context,
        message: "Error picking image: $e",
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> showImageSourceSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          margin: EdgeInsets.all(14.r),
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 18.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 24.r,
                offset: Offset(0, 10.h),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  "Change Profile Photo",
                  style: TextStyle(
                    color: const Color(0xFF1F2937),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 16.h),
                _ImageSourceTile(
                  icon: Icons.camera_alt_outlined,
                  title: "Camera",
                  subtitle: "Take a new photo",
                  onTap: () async {
                    Navigator.of(bottomSheetContext).pop();
                    await Future.delayed(const Duration(milliseconds: 200));

                    if (!context.mounted) return;

                    await pickImage(
                      context: context,
                      fromCamera: true,
                    );
                  },
                ),
                SizedBox(height: 10.h),
                _ImageSourceTile(
                  icon: Icons.photo_library_outlined,
                  title: "Gallery",
                  subtitle: "Choose from your photos",
                  onTap: () async {
                    Navigator.of(bottomSheetContext).pop();
                    await Future.delayed(const Duration(milliseconds: 200));

                    if (!context.mounted) return;

                    await pickImage(
                      context: context,
                      fromCamera: false,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> removeProfilePhoto(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.r),
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
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                "Remove",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    if (selectedImage != null) {
      selectedImage = null;
      notifyListeners();

      if (!context.mounted) return;

      showSnackBar(
        context: context,
        message: "Selected image removed",
      );
      return;
    }

    final success = await ProfileApi().removeProfilePic();

    if (!context.mounted) return;

    if (success) {
      await init(context);

      if (!context.mounted) return;

      showSnackBar(
        context: context,
        message: "Profile picture removed",
        backgroundColor: Colors.green,
      );
    } else {
      showSnackBar(
        context: context,
        message: "Failed to remove profile picture",
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> saveChanges(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final success = await ProfileApi().editProfileWithImage(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      imageFile: selectedImage,
    );

    if (!context.mounted) return;

    isLoading = false;
    notifyListeners();

    if (success) {
      await init(context);

      if (!context.mounted) return;

      final updatedUser = session.currentUser;

      if (updatedUser != null) {
        context.read<UserProvider>().setUser(updatedUser);
      }

      showSnackBar(
        context: context,
        message: 'Profile updated successfully',
        backgroundColor: Colors.green,
      );

      Navigator.pop(context, true);
    } else {
      showSnackBar(
        context: context,
        message: 'Failed to update profile',
        backgroundColor: Colors.red,
      );
    }
  }

  void showSnackBar({
    required BuildContext context,
    required String message,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(12.r),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}

class _ImageSourceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ImageSourceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7F7),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.08),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 21.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: const Color(0xFF1F2937),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey.shade400,
              size: 15.sp,
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:io';

import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileAvatarSection extends StatelessWidget {
  final File? selectedImage;
  final String? profileImageUrl;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;

  const EditProfileAvatarSection({
    super.key,
    required this.selectedImage,
    required this.profileImageUrl,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    final ImageProvider? imageProvider = selectedImage != null
        ? FileImage(selectedImage!)
        : (profileImageUrl != null && profileImageUrl!.isNotEmpty
        ? NetworkImage(profileImageUrl!)
        : null);

    return Center(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 122.r,
                height: 122.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 56.r,
                  backgroundImage: imageProvider,
                  child: imageProvider == null
                      ? Icon(
                    Icons.person,
                    size: 40.r,
                  )
                      : null,
                ),
              ),
              Positioned(
                right: -2.w,
                bottom: 6.h,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50.r),
                    onTap: onPickImage,
                    child: Container(
                      width: 38.r,
                      height: 38.r,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.file_upload_outlined,
                        color: Colors.white,
                        size: 20.r,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          TextButton.icon(
            onPressed: onRemoveImage,
            icon: Icon(
              Icons.delete_outline,
              color: const Color(0xFFFF5A5F),
              size: 20.r,
            ),
            label: const Text(
              'Remove',
              style: TextStyle(
                color: Color(0xFFFF5A5F),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
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
        : (profileImageUrl != null && profileImageUrl!.trim().isNotEmpty
        ? NetworkImage(profileImageUrl!.trim())
        : null);

    return Center(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: 132.r,
                height: 132.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.18),
                      AppColors.primary.withOpacity(0.04),
                    ],
                  ),
                ),
              ),

              Container(
                width: 118.r,
                height: 118.r,
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.14),
                      blurRadius: 22.r,
                      offset: Offset(0, 10.h),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 55.r,
                  backgroundColor: const Color(0xFFF2F5F5),
                  backgroundImage: imageProvider,
                  child: imageProvider == null
                      ? Icon(
                    Icons.person_rounded,
                    size: 44.r,
                    color: AppColors.primary.withOpacity(0.65),
                  )
                      : null,
                ),
              ),

              Positioned(
                right: 2.w,
                bottom: 8.h,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50.r),
                    onTap: onPickImage,
                    child: Container(
                      width: 42.r,
                      height: 42.r,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3.w,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.32),
                            blurRadius: 14.r,
                            offset: Offset(0, 6.h),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
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

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _AvatarActionButton(
                title: "Change Photo",
                icon: Icons.edit_rounded,
                color: AppColors.primary,
                backgroundColor: AppColors.primary.withOpacity(0.09),
                onTap: onPickImage,
              ),

              SizedBox(width: 10.w),

              _AvatarActionButton(
                title: "Remove",
                icon: Icons.delete_outline_rounded,
                color: const Color(0xFFE5484D),
                backgroundColor: const Color(0xFFE5484D).withOpacity(0.08),
                onTap: onRemoveImage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvatarActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _AvatarActionButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 9.h,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: color.withOpacity(0.10),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: 16.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
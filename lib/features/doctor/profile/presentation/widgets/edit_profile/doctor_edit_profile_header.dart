import 'dart:io';

import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorEditProfileHeader extends StatelessWidget {
  final String currentImageUrl;
  final File? selectedImage;
  final bool isPickingImage;
  final VoidCallback onBackTap;
  final VoidCallback onImageTap;

  const DoctorEditProfileHeader({
    super.key,
    required this.currentImageUrl,
    required this.selectedImage,
    required this.isPickingImage,
    required this.onBackTap,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageProvider = selectedImage != null
        ? FileImage(selectedImage!)
        : currentImageUrl.trim().isNotEmpty
        ? NetworkImage(
      '${currentImageUrl.trim()}?t=${DateTime.now().millisecondsSinceEpoch}',
    )
        : const AssetImage('assets/images/default_doctor.png')
    as ImageProvider;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(34.r),
          bottomRight: Radius.circular(34.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(
              right: -48.w,
              top: -48.h,
              child: _HeaderCircle(
                size: 145.r,
                opacity: 0.10,
              ),
            ),
            Positioned(
              left: -58.w,
              bottom: -65.h,
              child: _HeaderCircle(
                size: 140.r,
                opacity: 0.07,
              ),
            ),

            Column(
              children: [
                Row(
                  children: [
                    _HeaderIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: onBackTap,
                    ),

                    Expanded(
                      child: Text(
                        'Edit Profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),

                    SizedBox(width: 42.r),
                  ],
                ),

                SizedBox(height: 20.h),

                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120.r,
                      height: 120.r,
                      padding: EdgeInsets.all(5.r),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.20),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          backgroundColor: const Color(0xFFEAF4F3),
                          backgroundImage: imageProvider,
                        ),
                      ),
                    ),

                    Positioned(
                      right: 2.w,
                      bottom: 6.h,
                      child: GestureDetector(
                        onTap: isPickingImage ? null : onImageTap,
                        child: Container(
                          width: 38.r,
                          height: 38.r,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 10.r,
                                offset: Offset(0, 4.h),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 31.r,
                              height: 31.r,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 13.h),

                Text(
                  'Change your professional photo',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.92),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 5.h),

                Text(
                  'Tap the camera icon to upload a new image',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.68),
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.14),
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: SizedBox(
          width: 42.r,
          height: 42.r,
          child: Icon(
            icon,
            color: Colors.white,
            size: 18.sp,
          ),
        ),
      ),
    );
  }
}

class _HeaderCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _HeaderCircle({
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}
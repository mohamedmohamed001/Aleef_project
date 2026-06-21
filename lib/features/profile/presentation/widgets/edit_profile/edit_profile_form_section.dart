import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'edit_profile_text_field.dart';

class EditProfileFormSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;

  const EditProfileFormSection({
    super.key,
    required this.nameController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                Icons.badge_outlined,
                color: AppColors.primary,
                size: 20.sp,
              ),
            ),

            SizedBox(width: 10.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Basic Information',
                    style: TextStyle(
                      color: const Color(0xFF111827),
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Edit your personal details',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 22.h),

        _FieldLabel(
          title: 'Full Name',
          icon: Icons.person_outline_rounded,
        ),

        SizedBox(height: 9.h),

        EditProfileTextField(
          controller: nameController,
          hintText: 'Enter your full name',
        ),

        SizedBox(height: 18.h),

        _FieldLabel(
          title: 'Phone Number',
          icon: Icons.phone_outlined,
        ),

        SizedBox(height: 9.h),

        EditProfileTextField(
          controller: phoneController,
          hintText: 'Enter your phone number',
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String title;
  final IconData icon;

  const _FieldLabel({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 17.sp,
        ),
        SizedBox(width: 7.w),
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF111827),
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
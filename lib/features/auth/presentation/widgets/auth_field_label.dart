import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AuthFieldLabel extends StatelessWidget {
  final String title;
  final IconData icon;

  const AuthFieldLabel({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: AppColors.primary,
        ),
        SizedBox(width: 6.w),
        Text(
          title,
          style: AppTextStyles.label14Medium.copyWith(
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

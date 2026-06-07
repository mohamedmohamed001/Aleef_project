import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AuthTrustNote extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isNeutral;

  const AuthTrustNote({
    super.key,
    this.text = "Your pet care is safe.",
    this.icon = Icons.verified_user_rounded,
    this.isNeutral = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isNeutral
        ? Colors.grey.shade50
        : AppColors.primary.withOpacity(0.06);

    final borderColor = isNeutral
        ? AppColors.border
        : AppColors.primary.withOpacity(0.08);

    final iconBackgroundColor = isNeutral
        ? AppColors.primary.withOpacity(0.08)
        : Colors.white;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            height: 30.h,
            width: 30.w,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              shape: BoxShape.circle,
              boxShadow: isNeutral
                  ? null
                  : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 17.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body14Regular.copyWith(
                fontSize: 12.5.sp,
                height: 1.25,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

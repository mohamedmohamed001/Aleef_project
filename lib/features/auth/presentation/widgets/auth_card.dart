import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AuthCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const AuthCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 22.h, 18.w, 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.07),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 30.r,
            offset: Offset(0, 16.h),
          ),
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 34.r,
            offset: Offset(0, 20.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.heading24Bold.copyWith(
              fontSize: 25.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4.w,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            subtitle,
            style: AppTextStyles.body14Regular.copyWith(
              fontSize: 13.5.sp,
              height: 1.4,
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

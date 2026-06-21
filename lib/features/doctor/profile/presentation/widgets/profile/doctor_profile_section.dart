import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorProfileSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const DoctorProfileSection({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: const Color(0xFFE9EEEE),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 12.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: title,
            icon: icon,
          ),

          SizedBox(height: 14.h),

          child,
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34.r,
          height: 34.r,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.09),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 18.sp,
          ),
        ),

        SizedBox(width: 10.w),

        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }
}
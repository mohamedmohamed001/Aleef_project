import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoLine extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const InfoLine({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 24.sp,
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.5.sp,
                  color: const Color(0xFF667085),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15.5.sp,
                  color: const Color(0xFF001533),
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
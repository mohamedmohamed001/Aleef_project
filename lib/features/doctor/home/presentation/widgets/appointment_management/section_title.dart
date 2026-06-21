import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionTitle({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38.r,
          height: 38.r,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 21.sp,
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            color: const Color(0xFF001533),
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
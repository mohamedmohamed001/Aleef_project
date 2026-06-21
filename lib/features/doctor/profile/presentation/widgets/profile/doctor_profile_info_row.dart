import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final int maxLines;

  const DoctorProfileInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F6F6),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20.sp,
          ),
        ),

        SizedBox(width: 12.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5.sp,
                  color: const Color(0xFF8A9494),
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 4.h),

              Text(
                value,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.2.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2D3636),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
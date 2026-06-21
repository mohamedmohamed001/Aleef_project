import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PerformanceStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;

  const PerformanceStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? AppColors.primary;

    return Container(
      constraints: BoxConstraints(
        minHeight: 96.h,
      ),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 44.w,
            width: 44.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.11),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              icon,
              color: color,
              size: 21.sp,
            ),
          ),
          SizedBox(width: 11.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff1F2937),
                    height: 1,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade500,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
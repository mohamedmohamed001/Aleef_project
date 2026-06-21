import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorEditScheduleSummaryCard extends StatelessWidget {
  final int availableDaysCount;
  final int totalDaysCount;

  const DoctorEditScheduleSummaryCard({
    super.key,
    required this.availableDaysCount,
    required this.totalDaysCount,
  });

  @override
  Widget build(BuildContext context) {
    final unavailableDays = totalDaysCount - availableDaysCount;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: const Color(0xFFE8EEEE),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 14.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(
              icon: Icons.event_available_outlined,
              title: 'Available',
              value: availableDaysCount.toString(),
              color: AppColors.primary,
            ),
          ),

          Container(
            width: 1,
            height: 42.h,
            color: const Color(0xFFE8EEEE),
          ),

          Expanded(
            child: _SummaryItem(
              icon: Icons.event_busy_outlined,
              title: 'Unavailable',
              value: unavailableDays.toString(),
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _SummaryItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 38.r,
          height: 38.r,
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20.sp,
          ),
        ),

        SizedBox(width: 9.w),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: const Color(0xFF1F2937),
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF8A9494),
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
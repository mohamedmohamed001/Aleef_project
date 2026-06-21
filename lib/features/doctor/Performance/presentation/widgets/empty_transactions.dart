import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyTransactions extends StatelessWidget {
  const EmptyTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: 42.sp,
            color: AppColors.primary,
          ),
          SizedBox(height: 10.h),
          Text(
            'No transactions yet',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Your financial transactions will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
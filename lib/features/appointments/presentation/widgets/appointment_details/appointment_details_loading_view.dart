import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentDetailsLoadingView extends StatelessWidget {
  const AppointmentDetailsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3.w,
          ),
          SizedBox(height: 16.h),
          Text(
            "Fetching details...",
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

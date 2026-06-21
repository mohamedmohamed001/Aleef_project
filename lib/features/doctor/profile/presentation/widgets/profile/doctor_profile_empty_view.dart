import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorProfileEmptyView extends StatelessWidget {
  final Future<void> Function() onRetry;

  const DoctorProfileEmptyView({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(22.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 18.r,
                offset: Offset(0, 8.h),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 74.r,
                height: 74.r,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_off_outlined,
                  size: 38.sp,
                  color: AppColors.primary,
                ),
              ),

              SizedBox(height: 14.h),

              Text(
                'No profile data found',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1F2937),
                ),
              ),

              SizedBox(height: 6.h),

              Text(
                'Please try refreshing your doctor profile.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5.sp,
                  color: const Color(0xFF8A9494),
                  height: 1.4,
                ),
              ),

              SizedBox(height: 16.h),

              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
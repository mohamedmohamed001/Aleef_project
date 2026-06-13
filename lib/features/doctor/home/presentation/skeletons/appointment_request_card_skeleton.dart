
import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class AppointmentRequestCardSkeleton extends StatelessWidget {
  const AppointmentRequestCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: Colors.black.withOpacity(0.07)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _box(width: 62.w, height: 62.w, radius: 14.r),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _box(height: 17.h, width: 150.w),
                      SizedBox(height: 8.h),
                      _box(height: 13.h, width: 210.w),
                      SizedBox(height: 8.h),
                      _box(height: 13.h, width: 130.w),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            _box(height: 12.h, width: 95.w),
            SizedBox(height: 6.h),
            _box(height: 14.h, width: double.infinity),
            SizedBox(height: 6.h),
            _box(height: 14.h, width: 220.w),
            SizedBox(height: 18.h),
            Row(
              children: [
                Expanded(
                  child: _box(height: 48.h, radius: 14.r),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _box(height: 48.h, radius: 14.r),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _box({
    required double height,
    double? width,
    double radius = 8,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
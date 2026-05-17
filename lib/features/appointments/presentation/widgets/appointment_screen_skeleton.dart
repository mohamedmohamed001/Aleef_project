import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class AppointmentTabSkeleton extends StatelessWidget {
  const AppointmentTabSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerSkeleton(),
            SizedBox(height: 16.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _box(height: 230.h, radius: 24.r),
            ),

            SizedBox(height: 24.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _box(width: 190.w, height: 24.h, radius: 8.r),
            ),

            SizedBox(height: 12.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _box(height: 52.h, radius: 16.r),
            ),

            SizedBox(height: 16.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: List.generate(
                  4,
                      (index) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: _doctorCardSkeleton(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerSkeleton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _box(width: 160.w, height: 26.h, radius: 8.r),
          SizedBox(height: 10.h),
          _box(width: 240.w, height: 14.h, radius: 8.r),
          SizedBox(height: 18.h),
          _box(height: 44.h, radius: 16.r),
        ],
      ),
    );
  }

  Widget _doctorCardSkeleton() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Row(
        children: [
          _box(width: 64.w, height: 64.w, radius: 18.r),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(width: 150.w, height: 16.h, radius: 8.r),
                SizedBox(height: 8.h),
                _box(width: 100.w, height: 13.h, radius: 8.r),
                SizedBox(height: 10.h),
                _box(width: 180.w, height: 12.h, radius: 8.r),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _box({
    double? width,
    required double height,
    required double radius,
  }) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
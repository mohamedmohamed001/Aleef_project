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
              child: _appointmentCardSkeleton(),
            ),

            SizedBox(height: 24.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _box(width: 190.w, height: 24.h, radius: 8.r),
                  SizedBox(height: 8.h),
                  _box(width: 140.w, height: 12.h, radius: 8.r),
                ],
              ),
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
                  3,
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
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 42.h, 16.w, 28.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(width: 130.w, height: 22.h, radius: 8.r),
                SizedBox(height: 12.h),
                _box(width: 145.w, height: 14.h, radius: 8.r),
              ],
            ),
          ),

          _box(width: 44.w, height: 44.w, radius: 22.r),

          SizedBox(width: 10.w),

          _box(width: 82.w, height: 44.h, radius: 22.r),
        ],
      ),
    );
  }

  Widget _appointmentCardSkeleton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _box(width: 58.w, height: 58.w, radius: 16.r),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _box(width: 150.w, height: 16.h, radius: 8.r),
                    SizedBox(height: 8.h),
                    _box(width: 110.w, height: 13.h, radius: 8.r),
                  ],
                ),
              ),
              _box(width: 78.w, height: 28.h, radius: 30.r),
            ],
          ),

          SizedBox(height: 18.h),

          _box(height: 13.h, width: 230.w, radius: 8.r),
          SizedBox(height: 10.h),
          _box(height: 13.h, width: 180.w, radius: 8.r),

          SizedBox(height: 18.h),

          Row(
            children: [
              Expanded(child: _box(height: 42.h, radius: 14.r)),
              SizedBox(width: 12.w),
              Expanded(child: _box(height: 42.h, radius: 14.r)),
            ],
          ),
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
          _box(width: 70.w, height: 70.w, radius: 20.r),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(width: 130.w, height: 16.h, radius: 8.r),
                SizedBox(height: 8.h),
                _box(width: 95.w, height: 13.h, radius: 8.r),
                SizedBox(height: 10.h),
                _box(width: 165.w, height: 12.h, radius: 8.r),
                SizedBox(height: 12.h),
                _box(width: 92.w, height: 32.h, radius: 12.r),
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
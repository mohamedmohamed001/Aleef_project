import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class AppointmentDetailsSkeleton extends StatelessWidget {
  const AppointmentDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _headerSkeleton(context),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
            child: Column(
              children: [
                _petCardSkeleton(),
                SizedBox(height: 16.h),
                _infoCardSkeleton(rows: 3),
                SizedBox(height: 16.h),
                _appointmentCardSkeleton(),
                SizedBox(height: 22.h),
                Row(
                  children: [
                    Expanded(child: _box(height: 58.h, radius: 16.r)),
                    SizedBox(width: 14.w),
                    Expanded(child: _box(height: 58.h, radius: 16.r)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _headerSkeleton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 48.h, 24.w, 34.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
      ),
      child: Row(
        children: [
          _circle(44.w),
          SizedBox(width: 18.w),
          _box(width: 210.w, height: 24.h, radius: 8.r),
        ],
      ),
    );
  }

  Widget _petCardSkeleton() {
    return _shimmer(
      child: _card(
        child: Row(
          children: [
            _box(width: 82.w, height: 82.w, radius: 22.r),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _box(height: 24.h, width: 150.w),
                  SizedBox(height: 10.h),
                  _box(height: 15.h, width: 220.w),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCardSkeleton({required int rows}) {
    return _shimmer(
      child: _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _box(height: 15.h, width: 160.w),
            SizedBox(height: 18.h),
            ...List.generate(rows, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: index == rows - 1 ? 0 : 16.h),
                child: Row(
                  children: [
                    _circle(46.w),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _box(height: 14.h, width: 70.w),
                          SizedBox(height: 6.h),
                          _box(height: 15.h, width: double.infinity),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _appointmentCardSkeleton() {
    return _shimmer(
      child: _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _box(height: 15.h, width: 180.w),
            SizedBox(height: 18.h),
            ...List.generate(4, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 18.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _box(height: 14.h, width: 110.w),
                    SizedBox(height: 8.h),
                    _box(height: 16.h, width: double.infinity),
                  ],
                ),
              );
            }),
            _box(height: 34.h, width: 100.w, radius: 30.r),
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: child,
    );
  }

  Widget _shimmer({required Widget child}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: child,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Widget _circle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}
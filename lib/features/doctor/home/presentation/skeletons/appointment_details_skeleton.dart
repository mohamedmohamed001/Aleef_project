import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class AppointmentDetailsSkeleton extends StatelessWidget {
  final bool showActions;

  const AppointmentDetailsSkeleton({
    super.key,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
      child: Column(
        children: [
          _petCardSkeleton(),
          SizedBox(height: 16.h),
          _ownerCardSkeleton(),
          SizedBox(height: 16.h),
          _appointmentCardSkeleton(),
          if (showActions) ...[
            SizedBox(height: 22.h),
            _actionsSkeleton(),
          ],
        ],
      ),
    );
  }

  Widget _petCardSkeleton() {
    return _shimmer(
      child: _card(
        child: Row(
          children: [
            _box(
              width: 82.w,
              height: 82.w,
              radius: 22.r,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _box(
                    height: 24.h,
                    width: 145.w,
                    radius: 8.r,
                  ),
                  SizedBox(height: 10.h),
                  _box(
                    height: 15.h,
                    width: 215.w,
                    radius: 8.r,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ownerCardSkeleton() {
    return _shimmer(
      child: _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _box(
              height: 14.h,
              width: 155.w,
              radius: 8.r,
            ),
            SizedBox(height: 18.h),
            ...List.generate(3, (index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == 2 ? 0 : 16.h,
                ),
                child: Row(
                  children: [
                    _circle(46.w),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _box(
                            height: 12.h,
                            width: 70.w,
                            radius: 8.r,
                          ),
                          SizedBox(height: 7.h),
                          _box(
                            height: 15.h,
                            width: double.infinity,
                            radius: 8.r,
                          ),
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
            _box(
              height: 14.h,
              width: 175.w,
              radius: 8.r,
            ),
            SizedBox(height: 18.h),
            ...List.generate(4, (index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: 16.h,
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Row(
                    children: [
                      _box(
                        width: 38.w,
                        height: 38.w,
                        radius: 14.r,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _box(
                              height: 12.h,
                              width: 110.w,
                              radius: 8.r,
                            ),
                            SizedBox(height: 8.h),
                            _box(
                              height: 15.h,
                              width: double.infinity,
                              radius: 8.r,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            _box(
              height: 34.h,
              width: 105.w,
              radius: 30.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionsSkeleton() {
    return _shimmer(
      child: Row(
        children: [
          Expanded(
            child: _box(
              height: 58.h,
              radius: 16.r,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: _box(
              height: 58.h,
              radius: 16.r,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.black.withOpacity(0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 16.r,
            offset: Offset(0, 7.h),
          ),
        ],
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
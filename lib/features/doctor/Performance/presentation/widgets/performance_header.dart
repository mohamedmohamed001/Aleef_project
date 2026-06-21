import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PerformanceHeader extends StatelessWidget {
  final double rating;
  final int ratingCount;

  const PerformanceHeader({
    super.key,
    required this.rating,
    required this.ratingCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 56.h, 20.w, 42.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -40.w,
            top: -44.h,
            child: Container(
              height: 150.w,
              width: 150.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            right: 44.w,
            bottom: -20.h,
            child: Container(
              height: 64.w,
              width: 64.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Performance',
                      style: TextStyle(
                        fontSize: 29.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.05,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Overview of your earnings and appointments',
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.82),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 9.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.18),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: const Color(0xffF2A900),
                      size: 20.sp,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
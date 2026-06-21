import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorEditScheduleHeader extends StatelessWidget {
  final int availableDaysCount;
  final int totalDaysCount;
  final VoidCallback onBackTap;

  const DoctorEditScheduleHeader({
    super.key,
    required this.availableDaysCount,
    required this.totalDaysCount,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(34.r),
          bottomRight: Radius.circular(34.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(
              right: -48.w,
              top: -45.h,
              child: _HeaderCircle(size: 145.r, opacity: 0.10),
            ),
            Positioned(
              left: -55.w,
              bottom: -65.h,
              child: _HeaderCircle(size: 135.r, opacity: 0.07),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _HeaderBackButton(onTap: onBackTap),

                    Expanded(
                      child: Text(
                        'Edit Schedule',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),

                    SizedBox(width: 42.r),
                  ],
                ),

                SizedBox(height: 22.h),

                Row(
                  children: [
                    Container(
                      width: 54.r,
                      height: 54.r,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(19.r),
                      ),
                      child: Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.white,
                        size: 27.sp,
                      ),
                    ),

                    SizedBox(width: 14.w),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Weekly Availability',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),

                          SizedBox(height: 5.h),

                          Text(
                            'Set your working days and available hours.',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.76),
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 18.h),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(13.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.13),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.white,
                        size: 18.sp,
                      ),

                      SizedBox(width: 8.w),

                      Expanded(
                        child: Text(
                          '$availableDaysCount of $totalDaysCount days available this week',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.92),
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _HeaderBackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.14),
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: SizedBox(
          width: 42.r,
          height: 42.r,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 18.sp,
          ),
        ),
      ),
    );
  }
}

class _HeaderCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _HeaderCircle({
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}
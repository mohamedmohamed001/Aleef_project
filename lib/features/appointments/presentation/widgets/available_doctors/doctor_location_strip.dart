import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorLocationStrip extends StatelessWidget {
  final String? distanceKm;
  final int? minutes;

  const DoctorLocationStrip({
    super.key,
    required this.distanceKm,
    required this.minutes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFA),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: const Color(0xFFEAF0F0),
          width: 1.w,
        ),
      ),
      child: Row(
        children: [
          if (distanceKm != null)
            Expanded(
              child: _LocationMetric(
                icon: Icons.route_rounded,
                title: 'Distance',
                value: '$distanceKm km',
                iconColor: const Color(0xFF2F80ED),
                iconBackground: const Color(0xFFEAF3FF),
              ),
            ),
          if (distanceKm != null && minutes != null)
            Container(
              width: 1.w,
              height: 28.h,
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              color: const Color(0xFFE3EAEA),
            ),
          if (minutes != null)
            Expanded(
              child: _LocationMetric(
                icon: Icons.schedule_rounded,
                title: 'Arrival',
                value: '$minutes min',
                iconColor: const Color(0xFFE1A514),
                iconBackground: const Color(0xFFFFF4DD),
              ),
            ),
        ],
      ),
    );
  }
}

class _LocationMetric extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;
  final Color iconBackground;

  const _LocationMetric({
    required this.icon,
    required this.title,
    required this.value,
    required this.iconColor,
    required this.iconBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34.r,
          height: 34.r,
          decoration: BoxDecoration(
            color: iconBackground,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 17.r,
            color: iconColor,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF8A97A3),
                  height: 1,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1F2933),
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
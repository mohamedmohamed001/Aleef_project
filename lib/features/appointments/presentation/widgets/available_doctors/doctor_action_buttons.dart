import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

class DoctorActionButtons extends StatelessWidget {
  final VoidCallback? onDetailsTap;
  final VoidCallback? onBookTap;

  const DoctorActionButtons({
    super.key,
    required this.onDetailsTap,
    required this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SecondaryButton(
            title: 'Details',
            icon: Icons.info_outline_rounded,
            onTap: onDetailsTap,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          flex: 2,
          child: _PrimaryButton(
            title: 'Book Appointment',
            icon: Icons.calendar_month_rounded,
            onTap: onBookTap,
          ),
        ),
      ],
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const _SecondaryButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF6F8F8),
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          height: 42.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: const Color(0xFFE8EEEE),
              width: 1.w,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15.r,
                color: const Color(0xFF59656F),
              ),
              SizedBox(width: 5.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF59656F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const _PrimaryButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          height: 42.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.20),
                blurRadius: 12.r,
                offset: Offset(0, 5.h),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15.r,
                color: Colors.white,
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
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
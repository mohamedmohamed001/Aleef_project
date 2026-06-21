import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorHomeEmptyState extends StatelessWidget {
  const DoctorHomeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
      child: Center(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 32.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 74.w,
                height: 74.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.event_available_outlined,
                  size: 36.sp,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'No pending requests',
                style: TextStyle(
                  color: const Color(0xff172121),
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'You are all caught up. New appointment requests will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 13.sp,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorHomeErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const DoctorHomeErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
      child: Center(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 30.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(
              color: Colors.red.withOpacity(0.10),
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
                width: 70.w,
                height: 70.w,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.wifi_off_rounded,
                  size: 34.sp,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Something went wrong',
                style: TextStyle(
                  color: const Color(0xff172121),
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 13.sp,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 18.h),
              SizedBox(
                height: 46.h,
                child: ElevatedButton.icon(
                  onPressed: () => onRetry(),
                  icon: Icon(
                    Icons.refresh_rounded,
                    size: 19.sp,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Try again',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
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
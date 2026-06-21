import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

void showLocationPermissionDialog({
  required BuildContext context,
  required String message,
}) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 26.r,
                offset: Offset(0, 12.h),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64.r,
                height: 64.r,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4DD),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_disabled_rounded,
                  color: const Color(0xFFE1A514),
                  size: 32.r,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Location permission needed',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1F2933),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                  height: 1.35,
                ),
              ),
              SizedBox(height: 22.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    minimumSize: Size(double.infinity, 46.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    'Got it',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
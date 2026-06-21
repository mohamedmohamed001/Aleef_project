import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../core/theme/app_colors.dart';

void showLocationServiceDialog(BuildContext context) {
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
                  color: AppColors.primary.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_off_rounded,
                  color: AppColors.primary,
                  size: 32.r,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Turn on location',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1F2933),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Location permission is already allowed, but your device location is turned off. Turn it on to find the closest vets near you.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                  height: 1.35,
                ),
              ),
              SizedBox(height: 22.h),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size(double.infinity, 46.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        'Not now',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(dialogContext);
                        await Geolocator.openLocationSettings();
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
                        'Open',
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
            ],
          ),
        ),
      );
    },
  );
}
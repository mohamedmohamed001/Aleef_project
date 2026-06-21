import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorEditProfileLoadingOverlay extends StatelessWidget {
  final String message;

  const DoctorEditProfileLoadingOverlay({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AbsorbPointer(
        child: Container(
          color: Colors.black.withOpacity(0.18),
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 22.w,
                vertical: 18.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 22.r,
                    offset: Offset(0, 10.h),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 30.r,
                    height: 30.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.8,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
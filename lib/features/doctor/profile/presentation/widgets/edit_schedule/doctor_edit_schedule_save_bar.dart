import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorEditScheduleSaveBar extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const DoctorEditScheduleSaveBar({
    super.key,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18.r,
              offset: Offset(0, -6.h),
            ),
          ],
        ),
        child: SizedBox(
          height: 54.h,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.primary.withOpacity(0.65),
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.r),
              ),
            ),
            child: isLoading
                ? SizedBox(
              width: 24.r,
              height: 24.r,
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.4,
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.save_outlined,
                  color: Colors.white,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Save Schedule',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorEditProfileSaveButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const DoctorEditProfileSaveButton({
    super.key,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
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
              Icons.check_rounded,
              color: Colors.white,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Save Changes',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
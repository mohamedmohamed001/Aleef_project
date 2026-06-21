import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileSaveButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const EditProfileSaveButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.55),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: isLoading
              ? SizedBox(
            key: const ValueKey("loading"),
            width: 24.r,
            height: 24.r,
            child: const CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          )
              : Row(
            key: const ValueKey("text"),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Save Changes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
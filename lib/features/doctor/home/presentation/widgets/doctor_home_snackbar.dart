import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showDoctorHomeSnackBar(
    BuildContext context, {
      required String message,
      required bool isError,
    }) {
  ScaffoldMessenger.of(context).clearSnackBars();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      margin: EdgeInsets.fromLTRB(18.w, 0, 18.w, 18.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      backgroundColor: isError ? Colors.red : AppColors.primary,
    ),
  );
}
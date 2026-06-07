import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

enum AuthSnackBarType {
  success,
  error,
}

void showAuthSnackBar(
    BuildContext context, {
      required String message,
      AuthSnackBarType type = AuthSnackBarType.error,
    }) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontSize: 14.sp),
        ),
        backgroundColor:
        type == AuthSnackBarType.success ? AppColors.primary : AppColors.error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(14.r),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
    );
}

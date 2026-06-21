import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum AppSnackBarType {
  success,
  error,
  warning,
  info,
}

class AppSnackBar {
  static void show(
      BuildContext context, {
        required String message,
        AppSnackBarType type = AppSnackBarType.info,
      }) {
    final config = _SnackBarConfig.fromType(type);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
          padding: EdgeInsets.zero,
          duration: const Duration(seconds: 3),
          content: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 13.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: config.color.withOpacity(0.16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 18.r,
                  offset: Offset(0, 8.h),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: config.color.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    config.icon,
                    color: config.color,
                    size: 21.sp,
                  ),
                ),
                SizedBox(width: 11.w),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: const Color(0xFF1F2A2E),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  static void success(
      BuildContext context, {
        required String message,
      }) {
    show(
      context,
      message: message,
      type: AppSnackBarType.success,
    );
  }

  static void error(
      BuildContext context, {
        required String message,
      }) {
    show(
      context,
      message: message,
      type: AppSnackBarType.error,
    );
  }

  static void warning(
      BuildContext context, {
        required String message,
      }) {
    show(
      context,
      message: message,
      type: AppSnackBarType.warning,
    );
  }

  static void info(
      BuildContext context, {
        required String message,
      }) {
    show(
      context,
      message: message,
      type: AppSnackBarType.info,
    );
  }
}

class _SnackBarConfig {
  final Color color;
  final IconData icon;

  const _SnackBarConfig({
    required this.color,
    required this.icon,
  });

  factory _SnackBarConfig.fromType(AppSnackBarType type) {
    switch (type) {
      case AppSnackBarType.success:
        return const _SnackBarConfig(
          color: Color(0xFF18B97A),
          icon: Icons.check_circle_rounded,
        );

      case AppSnackBarType.error:
        return const _SnackBarConfig(
          color: Color(0xFFE5484D),
          icon: Icons.error_rounded,
        );

      case AppSnackBarType.warning:
        return const _SnackBarConfig(
          color: Color(0xFFE1A514),
          icon: Icons.warning_amber_rounded,
        );

      case AppSnackBarType.info:
        return const _SnackBarConfig(
          color: AppColors.primary,
          icon: Icons.info_rounded,
        );
    }
  }
}
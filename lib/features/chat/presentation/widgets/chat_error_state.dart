import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const ChatErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 82.r,
            height: 82.r,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.wifi_off_rounded,
              color: Colors.redAccent,
              size: 36.sp,
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            'Something went wrong',
            style: TextStyle(
              color: const Color(0xFF1F2A2E),
              fontSize: 19.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF8A8F93),
              fontSize: 13.sp,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 18.h),
          Material(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(18.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(18.r),
              onTap: onRetry,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 22.w,
                  vertical: 12.h,
                ),
                child: Text(
                  'Try again',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
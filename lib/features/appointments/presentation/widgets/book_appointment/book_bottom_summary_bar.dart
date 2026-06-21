import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookBottomSummaryBar extends StatelessWidget {
  final String fee;
  final bool isLoading;
  final VoidCallback onPressed;

  const BookBottomSummaryBar({
    super.key,
    required this.fee,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 18.h),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 54.h,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6F5),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Fee",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      fee,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            SizedBox(
              width: 165.w,
              height: 54.h,
              child: ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.45),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 22.w,
                        height: 22.w,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.3,
                        ),
                      )
                    : Text(
                        "Book",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

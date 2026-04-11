import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentsHeader extends StatelessWidget {
  final int notificationCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onPreviousTap;

  const AppointmentsHeader({
    super.key,
    this.notificationCount = 3,
    this.onNotificationTap,
    this.onPreviousTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 18.h),
      color: const Color(0xFFF7F8FA),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Appointments",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.title16SemiBold.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Manage your vet visits",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body14Regular.copyWith(
                      fontSize: 14.sp,
                      color: const Color(0xFF667085),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 12.w),

          InkWell(
            onTap: onNotificationTap,
            borderRadius: BorderRadius.circular(18.r),
            child: Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF4F4),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.primary,
                      size: 24.sp,
                    ),
                  ),
                  if (notificationCount > 0)
                    Positioned(
                      top: -8.h,
                      right: -6.w,
                      child: Container(
                        constraints: BoxConstraints(
                          minWidth: 20.r,
                          minHeight: 20.r,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF3B30),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFF7F8FA),
                            width: 2.w,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$notificationCount',
                          style: AppTextStyles.title16SemiBold.copyWith(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          SizedBox(width: 10.w),

          InkWell(
            onTap: onPreviousTap,
            borderRadius: BorderRadius.circular(18.r),
            child: Container(
              height: 41.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF4F4),
                borderRadius: BorderRadius.circular(18.r),
              ),
              alignment: Alignment.center,
              child: Text(
                "Previous",
                style: AppTextStyles.title16SemiBold.copyWith(
                  color: AppColors.primary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
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
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 16.h),
      color: const Color(0xFFF7F8FA),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Appointments",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.title16SemiBold.copyWith(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF101828),
                    height: 1,
                  ),
                ),
                SizedBox(height: 7.h),
                Row(
                  children: [
                    Container(
                      width: 6.r,
                      height: 6.r,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 7.w),
                    Expanded(
                      child: Text(
                        "Manage your vet visits easily",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body14Regular.copyWith(
                          fontSize: 12.5.sp,
                          color: const Color(0xFF667085),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          _CircleActionButton(
            onTap: onNotificationTap,
            icon: Icons.notifications_none_rounded,
            notificationCount: notificationCount,
          ),

          SizedBox(width: 9.w),

          InkWell(
            onTap: onPreviousTap,
            borderRadius: BorderRadius.circular(15.r),
            child: Container(
              height: 38.h,
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.10),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history_rounded,
                    color: AppColors.primary,
                    size: 17.sp,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    "Previous",
                    style: AppTextStyles.title16SemiBold.copyWith(
                      color: AppColors.primary,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final int notificationCount;

  const _CircleActionButton({
    required this.onTap,
    required this.icon,
    required this.notificationCount,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        width: 38.r,
        height: 38.r,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 22.sp,
              ),
            ),
            if (notificationCount > 0)
              Positioned(
                top: -5.h,
                right: -5.w,
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: 18.r,
                    minHeight: 18.r,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4D4F),
                    borderRadius: BorderRadius.circular(99.r),
                    border: Border.all(
                      color: const Color(0xFFF7F8FA),
                      width: 2.w,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    notificationCount > 9 ? '9+' : '$notificationCount',
                    style: AppTextStyles.title16SemiBold.copyWith(
                      color: Colors.white,
                      fontSize: 9.5.sp,
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
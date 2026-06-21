import 'package:aleef/core/routing/app_routes.dart';
import 'package:aleef/features/notifications/presentation/provider/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    final unreadCount = context.watch<NotificationProvider>().unreadCount;

    return IconButton(
      onPressed: () async {
        final provider = context.read<NotificationProvider>();

        if (provider.unreadCount > 0) {
          await provider.markAllAsRead();
        }

        if (!context.mounted) return;

        Navigator.pushNamed(context, AppRoutes.notifications);
      },
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.notifications_none_rounded,
                color: AppColors.primary,
                size: 22.sp,
              ),
            ),
          ),

          if (unreadCount > 0)
            Positioned(
              right: -3.w,
              top: -3.h,
              child: Container(
                constraints: BoxConstraints(
                  minWidth: 18.r,
                  minHeight: 18.r,
                ),
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: Colors.white,
                    width: 2.w,
                  ),
                ),
                child: Center(
                  child: Text(
                    unreadCount > 9 ? '9+' : unreadCount.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w900,
                      height: 1,
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
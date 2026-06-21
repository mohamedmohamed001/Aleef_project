import 'package:aleef/core/routing/app_routes.dart';
import 'package:aleef/features/notifications/presentation/provider/notification_provider.dart';
import 'package:aleef/features/store/services/store_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import 'icon_with_badge.dart';

class StoreHeader extends StatelessWidget implements PreferredSizeWidget {
  const StoreHeader({super.key});

  @override
  Size get preferredSize => Size.fromHeight(92.h);

  @override
  Widget build(BuildContext context) {
    final unreadCount = context.watch<NotificationProvider>().unreadCount;
    final cartCount = context.watch<StoreProvider>().cartItems.length;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.white,
      elevation: 0,
      toolbarHeight: 92.h,
      titleSpacing: 18.w,
      title: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Row(
          children: [
            Container(
              width: 4.w,
              height: 42.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pet Shop',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 24.sp,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 7.h),
                  Text(
                    'Everything your pet needs',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF9A9A9A),
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        SizedBox(width: 8.w),

        IconWithBadge(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.order);
          },
          icon: Icons.receipt_long_rounded,
          count: '',
          badgeColor: Colors.transparent,
        ),

        SizedBox(width: 8.w),

        IconWithBadge(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.cart);
          },
          icon: Icons.shopping_bag_outlined,
          count: cartCount == 0 ? '' : cartCount.toString(),
          badgeColor: AppColors.primary,
        ),

        SizedBox(width: 14.w),
      ],
    );
  }
}
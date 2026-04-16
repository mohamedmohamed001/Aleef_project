import 'package:aleef/core/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:aleef/features/store/services/store_provider.dart';
import '../../../../core/theme/app_colors.dart';
import 'icon_with_badge.dart';

class StoreHeader extends StatelessWidget implements PreferredSizeWidget {
  const StoreHeader({super.key});

  @override
  Size get preferredSize => Size.fromHeight(100.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      toolbarHeight: 100.h,
      centerTitle: false,
      titleSpacing: 16.w,

      /// 👇 نخلي العنوان ينزل تحت شوية
      title: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pet Shop',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),

            SizedBox(height: 6.h),

            Text(
              'Premium products for your pets',
              style: TextStyle(color: const Color(0xFF949494), fontSize: 13),
            ),
          ],
        ),
      ),

      /// 👇 نزبط المسافة بين الأيقونات
      actions: [
        SizedBox(width: 4.w),

        const IconWithBadge(
          icon: Icons.notifications_none_outlined,
          count: '3',
          badgeColor: Color(0xFFE57373),
        ),

        SizedBox(width: 8.w),

        IconWithBadge(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.order);
          },
          icon: Icons.inventory_2_outlined,
          count: '',
          badgeColor: Colors.transparent,
        ),

        SizedBox(width: 8.w),

        IconWithBadge(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.cart);
          },
          icon: Icons.shopping_cart_outlined,
          count: context.watch<StoreProvider>().cartItems.length.toString(),
          badgeColor: const Color(0xFF5DB1A3),
        ),

        SizedBox(width: 12.w),
      ],
    );
  }
}

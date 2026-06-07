import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/home/presentation/widgets/quick_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../providers/bottom_nav_provider.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: Colors.black.withOpacity(0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.055),
            blurRadius: 24.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Row(
        children: [
          QuickCareDockItem(
            title: "Book",
            icon: Icons.calendar_month_outlined,
            accentColor: AppColors.primary,
            onTap: () {
              context.read<BottomNavProvider>().changeTab(1);
            },
          ),
          _DockDivider(),
          QuickCareDockItem(
            title: "AI Ask",
            icon: Icons.smart_toy_outlined,
            accentColor: const Color(0xFFFF7A1A),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.chatBotScreen);
            },
          ),
          _DockDivider(),
          QuickCareDockItem(
            title: "Shop",
            icon: Icons.shopping_bag_outlined,
            accentColor: const Color(0xFF8B5CF6),
            onTap: () {
              context.read<BottomNavProvider>().changeTab(3);
            },
          ),
          _DockDivider(),
          // QuickCareDockItem(
          //   title: "Add",
          //   icon: Icons.add_circle_outline_rounded,
          //   accentColor: const Color(0xFF2F80ED),
          //   onTap: () {
          //     Navigator.pushNamed(context, AppRoutes.addPet);
          //   },
          // ),
        ],
      ),
    );
  }
}

class _DockDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.w,
      height: 44.h,
      color: Colors.black.withOpacity(0.045),
    );
  }
}
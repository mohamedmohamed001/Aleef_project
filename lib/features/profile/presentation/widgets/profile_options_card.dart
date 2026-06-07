import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/profile_option_item.dart';

class ProfileOptionsCard extends StatelessWidget {
  const ProfileOptionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _ProfileSectionCard(
      title: "Quick Actions",
      child: Column(
        children: [
          ProfileOptionItem(
            title: "My Appointments",
            icon: Icons.calendar_month_rounded,
            iconColor: AppColors.info,
            bgColor: AppColors.info.withOpacity(0.09),
          ),

          const _OptionDivider(),

          ProfileOptionItem(
            title: "My Orders",
            icon: Icons.inventory_2_rounded,
            iconColor: AppColors.warning,
            bgColor: AppColors.warning.withOpacity(0.09),
          ),

          const _OptionDivider(),

          ProfileOptionItem(
            title: "Settings",
            icon: Icons.settings_rounded,
            iconColor: AppColors.shopCard,
            bgColor: AppColors.shopCard.withOpacity(0.09),
          ),
        ],
      ),
    );
  }
}

class _ProfileSectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _ProfileSectionCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 2.w, bottom: 10.h),
            child: Text(
              title,
              style: AppTextStyles.black16Bold.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _OptionDivider extends StatelessWidget {
  const _OptionDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 62.w),
      child: Divider(
        height: 18.h,
        thickness: 1,
        color: AppColors.border.withOpacity(0.8),
      ),
    );
  }
}
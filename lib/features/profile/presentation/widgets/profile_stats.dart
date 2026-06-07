import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_text_styles.dart';

class ProfileStats extends StatelessWidget {
  final int petsCount;
  final int ordersCount;
  final int visitsCount;

  const ProfileStats({
    super.key,
    required this.petsCount,
    required this.ordersCount,
    required this.visitsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.07),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.055),
            blurRadius: 22.r,
            offset: Offset(0, 10.h),
          ),
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 24.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              value: petsCount.toString(),
              label: "Pets",
              icon: Icons.pets_rounded,
              iconColor: AppColors.primary,
              bgColor: AppColors.primary.withOpacity(0.10),
            ),
          ),
          _buildDivider(),
          Expanded(
            child: _StatItem(
              value: ordersCount.toString(),
              label: "Orders",
              icon: Icons.shopping_bag_rounded,
              iconColor: AppColors.warning,
              bgColor: AppColors.warning.withOpacity(0.10),
            ),
          ),
          _buildDivider(),
          Expanded(
            child: _StatItem(
              value: visitsCount.toString(),
              label: "Visits",
              icon: Icons.favorite_rounded,
              iconColor: AppColors.error,
              bgColor: AppColors.error.withOpacity(0.09),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1.w,
      height: 46.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      color: AppColors.border,
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 34.r,
          width: 34.r,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 17.sp,
            color: iconColor,
          ),
        ),
        SizedBox(height: 7.h),
        Text(
          value,
          style: AppTextStyles.primary12Regular.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 22.sp,
            color: AppColors.textPrimary,
            height: 1,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.hint14Regular.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
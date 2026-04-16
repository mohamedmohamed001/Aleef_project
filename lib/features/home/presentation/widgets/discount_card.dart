import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../providers/bottom_nav_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_assets.dart';

class DiscountCard extends StatelessWidget {
  const DiscountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 160.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 150.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(24.r),
            ),
          ),
          Positioned(
            right: -20.w,
            left: 30.w,
            child: Image.asset(
              AppAssets.discountCard,
              width: 200.w,
              height: 250.h,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Discount",
                    style: AppTextStyles.title16SemiBold.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
                Text(
                  "20% off",
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.white,
                  ),
                ),
                Text(
                  "on all products",
                  style: AppTextStyles.hint14Regular.copyWith(
                    color: AppColors.white,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    minimumSize: Size(100.w, 38.h),
                    backgroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                  ),
                  onPressed: () {
                    context.read<BottomNavProvider>().changeTab(3);
                  },
                  child: Text(
                    "Shop Now",
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

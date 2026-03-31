import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_assets.dart';

class DiscountCard extends StatelessWidget {
  const DiscountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          Positioned(right:-20,
              left: 30,
              child: Image.asset(AppAssets.discountCard,width: 200,height: 250,)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                  "20% off ",
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
                    minimumSize: Size(100, 38),
                    backgroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  )
                ,onPressed: () {
                }, child: Text("Shop Now")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

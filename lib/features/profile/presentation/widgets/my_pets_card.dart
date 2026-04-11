import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_assets.dart';

class MyPetsCard extends StatelessWidget {
  const MyPetsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// 🐶 Image
          ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: Image.asset(
              AppAssets.profilePhoto,
              height: 60.r,
              width: 60.r,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(height: 10.h),

          /// 🐾 Name
          Text(
            "Max",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.black16Bold.copyWith(
              fontSize: 14,
            ),
          ),

          SizedBox(height: 4.h),

          /// 🐾 Info
          Text(
            "Dog · 3 years",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.hint14Regular.copyWith(
              color: Colors.grey.shade600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

class EnableLocationCard extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const EnableLocationCard({
    super.key,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.10),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.07),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.my_location_rounded,
              color: AppColors.primary,
              size: 24.r,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Find nearby clinics",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1F2933),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Turn on location to show the closest vets to you.",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          InkWell(
            onTap: isLoading ? null : onTap,
            borderRadius: BorderRadius.circular(14.r),
            child: Container(
              height: 38.h,
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.18),
                    blurRadius: 10.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: isLoading
                  ? SizedBox(
                width: 16.r,
                height: 16.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : Text(
                "Enable",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
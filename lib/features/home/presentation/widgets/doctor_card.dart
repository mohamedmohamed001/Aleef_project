import 'package:aleef/features/home/presentation/widgets/Interactive_rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_assets.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28.r,
            backgroundImage: AssetImage(AppAssets.profilePhoto),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dr. Amira Hassan",
                  style: AppTextStyles.black16Bold.copyWith(
                    fontSize: 14.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 4.h),

                Text(
                  "General Veterinarian",
                  style: AppTextStyles.hint14Regular.copyWith(
                    fontSize: 12.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 6.h),

                const DoctorRatingWidget(),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 4.h,
                  horizontal: 8.w,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(240, 253, 244, 1),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Text(
                  "Available",
                  style: AppTextStyles.primary12Regular.copyWith(
                    fontSize: 12.sp,
                    color: const Color.fromRGBO(22, 163, 74, 1),
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              SizedBox(
                height: 30.h,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor:
                    const Color.fromRGBO(38, 125, 119, 0.08),
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Book",
                    style: AppTextStyles.primary12Regular.copyWith(
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_text_styles.dart';

class DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String imagePath;
  final String statusText;
  final String buttonText;
  final bool isAvailable;
  final double rating;
  final VoidCallback? onBookPressed;

  const DoctorCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.imagePath,
    this.statusText = "Available",
    this.buttonText = "Book",
    this.isAvailable = true,
    this.rating = 0.0,
    this.onBookPressed,
  });

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
            backgroundImage: AssetImage(imagePath),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.black16Bold.copyWith(
                    fontSize: 14.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 4.h),

                Text(
                  specialty,
                  style: AppTextStyles.hint14Regular.copyWith(
                    fontSize: 12.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 6.h),

                /// ⭐ rating
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      rating.toStringAsFixed(1),
                      style: AppTextStyles.black16Bold.copyWith(
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
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
                  color: isAvailable
                      ? const Color.fromRGBO(240, 253, 244, 1)
                      : const Color.fromRGBO(254, 242, 242, 1),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Text(
                  statusText,
                  style: AppTextStyles.primary12Regular.copyWith(
                    fontSize: 12.sp,
                    color: isAvailable
                        ? const Color.fromRGBO(22, 163, 74, 1)
                        : const Color.fromRGBO(220, 38, 38, 1),
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
                  onPressed: onBookPressed,
                  child: Text(
                    buttonText,
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
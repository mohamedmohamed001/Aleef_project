import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'book_small_info.dart';

class BookDoctorHeroCard extends StatelessWidget {
  final String image;
  final String name;
  final String specialization;
  final String city;
  final String rating;

  const BookDoctorHeroCard({
    super.key,
    required this.image,
    required this.name,
    required this.specialization,
    required this.city,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(21.r),
              child: Image.network(
                image,
                width: 76.w,
                height: 76.w,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return Container(
                    width: 76.w,
                    height: 76.w,
                    color: AppColors.primary.withValues(alpha: 0.08),
                    child: Icon(
                      Icons.person_rounded,
                      color: AppColors.primary,
                      size: 38.sp,
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Appointment with",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  specialization,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    BookSmallInfo(icon: Icons.star_rounded, text: rating),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: BookSmallInfo(
                        icon: Icons.location_on_rounded,
                        text: city,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

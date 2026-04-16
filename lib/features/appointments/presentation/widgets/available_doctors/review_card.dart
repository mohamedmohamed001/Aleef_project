import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:aleef/features/appointments/data/models/review_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'doctor_info_container.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return DoctorInfoContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26.r,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26.r),
                  child: Image.network(
                    review.user.profilePic,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.user.name,
                      style: AppTextStyles.titleLarge.copyWith(fontSize: 16.sp),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          review.rate.toString(),
                          style: TextStyle(fontSize: 1),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                "2 weeks ago",
                style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade500),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade700,
              height: 1.8,
            ),
          ),
          SizedBox(height: 18.h),
        ],
      ),
    );
  }
}

import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/appointments/data/models/review_model.dart';
import 'package:aleef/features/appointments/presentation/widgets/doctor_details/doctor_details_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorDetailsReviewsCard extends StatelessWidget {
  final List<ReviewModel> reviews;

  const DoctorDetailsReviewsCard({
    super.key,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return DoctorDetailsSectionCard(
      icon: Icons.forum_rounded,
      title: "Patient Reviews",
      child: reviews.isEmpty
          ? Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFA),
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Text(
          "No reviews yet.",
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      )
          : Column(
        children: reviews.map((review) {
          final String userName = review.user_name.trim().isEmpty
              ? "User"
              : review.user_name.trim();

          final String comment = review.comment.trim();
          final String rate = review.rate.toString();

          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFA),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: const Color(0xFFE8EEEE)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _UserAvatar(
                      imageUrl: review.user_pic,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: const Color(0xFF122C2A),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.star_rounded,
                      color: const Color(0xFFFFB800),
                      size: 18.sp,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      rate,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF122C2A),
                      ),
                    ),
                  ],
                ),
                if (comment.isNotEmpty) ...[
                  SizedBox(height: 10.h),
                  Text(
                    comment,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13.sp,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String? imageUrl;

  const _UserAvatar({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return Container(
      width: 38.r,
      height: 38.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: .1),
        border: Border.all(
          color: Colors.white,
          width: 2.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: ClipOval(
        child: hasImage
            ? Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const _FallbackAvatarIcon();
          },
        )
            : const _FallbackAvatarIcon(),
      ),
    );
  }
}

class _FallbackAvatarIcon extends StatelessWidget {
  const _FallbackAvatarIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary.withValues(alpha: .1),
      child: Icon(
        Icons.person_rounded,
        color: AppColors.primary,
        size: 19.sp,
      ),
    );
  }
}
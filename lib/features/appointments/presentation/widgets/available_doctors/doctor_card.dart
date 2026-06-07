import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/doctor_model.dart';

class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final VoidCallback? onTap;
  final VoidCallback? onTapDetails;

  const DoctorCard({
    super.key,
    required this.doctor,
    this.onTap,
    this.onTapDetails,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = doctor.profilePic.toString();
    final name = doctor.name.toString();
    final specialization = doctor.specialization.toString();
    final city = doctor.city.toString();
    final rating = doctor.rating.toString();
    final ratingsCount = doctor.ratingsCount.toString();

    return GestureDetector(
      onTap: onTapDetails,
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: const Color(0xFFEAF0F0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.045),
              blurRadius: 18.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DoctorImageWithRate(
              imageUrl: imageUrl,
              rating: rating,
            ),

            SizedBox(width: 13.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF1F2933),
                          ),
                        ),
                      ),

                      SizedBox(width: 6.w),

                      Container(
                        width: 28.w,
                        height: 28.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F8F8),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 11.r,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 7.h),

                  Container(
                    constraints: BoxConstraints(maxWidth: 170.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 9.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.medical_services_rounded,
                          size: 12.r,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            specialization,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 9.h),

                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 14.r,
                        color: Colors.grey.shade500,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          city,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 5.h),

                  Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 13.r,
                        color: Colors.grey.shade500,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          '$ratingsCount reviews',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.8.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  Row(
                    children: [
                      InkWell(
                        onTap: onTapDetails,
                        borderRadius: BorderRadius.circular(14.r),
                        child: Container(
                          height: 38.h,
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F8F8),
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: const Color(0xFFE8EEEE),
                            ),
                          ),
                          child: Text(
                            'Details',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF59656F),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 10.w),

                      Expanded(
                        child: InkWell(
                          onTap: onTap,
                          borderRadius: BorderRadius.circular(14.r),
                          child: Container(
                            height: 38.h,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  size: 15.r,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  'Book',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorImageWithRate extends StatelessWidget {
  final String imageUrl;
  final String rating;

  const _DoctorImageWithRate({
    required this.imageUrl,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76.w,
      child: Column(
        children: [
          Container(
            width: 70.w,
            height: 82.h,
            padding: EdgeInsets.all(3.r),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F7F7),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: const Color(0xFFE6EEEE),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17.r),
              child: imageUrl.isEmpty || imageUrl == 'null'
                  ? Container(
                color: AppColors.primary.withOpacity(0.08),
                child: Icon(
                  Icons.person_rounded,
                  size: 36.r,
                  color: AppColors.primary,
                ),
              )
                  : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.primary.withOpacity(0.08),
                  child: Icon(
                    Icons.person_rounded,
                    size: 36.r,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),

          Transform.translate(
            offset: Offset(0, -8.h),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 4.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(
                  color: const Color(0xFFFFDFA3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8.r,
                    offset: Offset(0, 3.h),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: 13.r,
                    color: const Color(0xFFFFB020),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    rating,
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF7A5200),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
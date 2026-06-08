import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:aleef/features/appointments/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorInfoCard extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorInfoCard({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    final doctorName = doctor.name ?? 'Unknown Doctor';
    final specialization = doctor.specialization ?? 'Veterinarian';
    final rating = doctor.rating?? '0.0';
    final city = doctor.city ?? doctor.location ?? 'Unknown location';

    return Positioned(
      left: 20.w,
      right: 20.w,
      bottom: -75.h,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 18.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.22),
              spreadRadius: 1,
              blurRadius: 20.r,
              offset: Offset(0, 6.h),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              doctorName,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleLarge.copyWith(
                fontSize: 20.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              specialization,
              textAlign: TextAlign.center,
              style: AppTextStyles.hint14Regular.copyWith(
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  rating,
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
                SizedBox(width: 6.w),
                Flexible(
                  child: Text(
                    city,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
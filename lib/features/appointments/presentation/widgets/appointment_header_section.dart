import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'appointment_status_chip.dart';

class AppointmentHeaderSection extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String status;
  final String imagePath;

  const AppointmentHeaderSection({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.status,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56.r,
            height: 56.r,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 2.w,
              ),
              borderRadius: BorderRadius.circular(16.r),
              image: DecorationImage(
                image: NetworkImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctorName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.title16SemiBold.copyWith(
                    color: Colors.white,
                    fontSize: 18.sp,
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  specialty,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body14Regular.copyWith(
                    fontSize: 12.5.sp,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          AppointmentStatusChip(status: status),
        ],
      ),
    );
  }
}
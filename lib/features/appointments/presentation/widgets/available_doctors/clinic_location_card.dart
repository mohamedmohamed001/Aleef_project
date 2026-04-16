import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:aleef/features/appointments/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'doctor_info_container.dart';

class ClinicLocationCard extends StatelessWidget {
  final DoctorModel doctor;

  const ClinicLocationCard({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    final clinicName = doctor.address?.trim().isNotEmpty == true
        ? doctor.address!
        : (doctor.location?.trim().isNotEmpty == true
        ? doctor.location!
        : 'Clinic address unavailable');

    final cityName = doctor.city?.trim().isNotEmpty == true
        ? doctor.city!
        : 'City unavailable';

    return DoctorInfoContainer(
      child: Row(
        children: [
          Container(
            width: 62.w,
            height: 62.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F6F5),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Icon(
              Icons.location_on_outlined,
              color: AppColors.primary,
              size: 30.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clinicName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  cityName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
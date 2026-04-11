import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:aleef/core/utils/app_assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'appointment_header_section.dart';
import 'appointment_info_item.dart';

class AppointmentCard extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String date;
  final String time;
  final String petName;
  final String petType;
  final String status;
  final String imagePath;
  final VoidCallback? onViewDetails;

  const AppointmentCard({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    required this.petName,
    required this.petType,
    this.status = "Confirmed",
    this.imagePath = AppAssets.profilePhoto,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        children: [
          AppointmentHeaderSection(
            doctorName: doctorName,
            specialty: specialty,
            status: status,
            imagePath: imagePath,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 16.h),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppointmentInfoItem(
                        icon: Icons.access_time_outlined,
                        title: "Date & Time",
                        mainText: date,
                        subText: time,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: AppointmentInfoItem(
                        icon: CupertinoIcons.paw,
                        title: "Pet",
                        mainText: petName,
                        subText: petType,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                SizedBox(
                  width: double.infinity,
                  height: 54.h,
                  child: ElevatedButton(
                    onPressed: onViewDetails,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "View Details",
                          style: AppTextStyles.title16SemiBold.copyWith(
                            color: Colors.white,
                            fontSize: 15.sp,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 20.sp,
                        ),
                      ],
                    ),
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
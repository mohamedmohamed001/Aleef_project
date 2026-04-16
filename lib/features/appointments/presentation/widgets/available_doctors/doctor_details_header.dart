import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/utils/app_assets.dart';
import 'package:aleef/features/appointments/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorDetailsHeader extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorDetailsHeader({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage =
        doctor.profilePic != null && doctor.profilePic!.trim().isNotEmpty;

    return SizedBox(
      width: double.infinity,
      height: 255.h,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 255.h,
            color: AppColors.primary,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: Colors.white,
                  width: 2.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 16.r,
                    offset: Offset(0, 6.h),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: hasImage
                    ? Image.network(
                  doctor.profilePic!,
                  width: 128.w,
                  height: 128.w,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    AppAssets.profilePhoto,
                    width: 128.w,
                    height: 128.w,
                    fit: BoxFit.cover,
                  ),
                )
                    : Image.asset(
                  AppAssets.profilePhoto,
                  width: 128.w,
                  height: 128.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
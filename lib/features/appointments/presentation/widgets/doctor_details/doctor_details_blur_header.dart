import 'dart:ui';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/appointments/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorDetailsBlurHeader extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorDetailsBlurHeader({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    final String doctorImage = doctor.profilePic ?? "";
    final bool hasImage = doctorImage.trim().isNotEmpty;
    final String doctorName = doctor.name ?? "Doctor";
    final String specialization = doctor.specialization ?? "Veterinarian";

    return SizedBox(
      height: 240.h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (hasImage)
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Image.network(
                      doctorImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const _GradientHeader(),
                    ),
                  )
                else
                  const _GradientHeader(),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: .12),
                        AppColors.primary.withValues(alpha: .70),
                        const Color(0xFFF4F7F8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 88.h,
            left: 28.w,
            right: 28.w,
            child: Column(
              children: [
                Text(
                  "Doctor Profile",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .9),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  doctorName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  specialization,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .9),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
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

class _GradientHeader extends StatelessWidget {
  const _GradientHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            Color(0xFF51B9B0),
            Color(0xFFBCEDEA),
          ],
        ),
      ),
    );
  }
}

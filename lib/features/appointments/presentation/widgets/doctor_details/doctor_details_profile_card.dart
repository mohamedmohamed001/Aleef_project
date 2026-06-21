import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/appointments/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorDetailsProfileCard extends StatelessWidget {
  final DoctorModel doctor;
  final int reviewsCount;

  const DoctorDetailsProfileCard({
    super.key,
    required this.doctor,
    required this.reviewsCount,
  });

  @override
  Widget build(BuildContext context) {
    final String doctorName = doctor.name ?? "Doctor";
    final String specialization = doctor.specialization ?? "Veterinarian";
    final String rating = doctor.rating?.toString() ?? "0.0";
    final String doctorImage = doctor.profilePic ?? "";
    final bool hasImage = doctorImage.trim().isNotEmpty;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: .25),
                width: 1.5.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: .18),
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 60.r,
              backgroundColor: const Color(0xFFEAF5F4),
              backgroundImage: hasImage ? NetworkImage(doctorImage) : null,
              child: !hasImage
                  ? Icon(
                Icons.person_rounded,
                size: 58.sp,
                color: AppColors.primary,
              )
                  : null,
            ),
          ),
          SizedBox(height: 15.h),
          Text(
            doctorName,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF122C2A),
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 7.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Text(
              specialization,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              _StatBox(icon: Icons.star_rounded, value: rating, label: "Rating"),
              SizedBox(width: 10.w),
              _StatBox(icon: Icons.reviews_rounded, value: "$reviewsCount", label: "Reviews"),
              SizedBox(width: 10.w),
              _StatBox(icon: Icons.payments_rounded, value: "${doctor.appointmentFee ?? 0}", label: "Fee"),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatBox({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 13.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF6FAFA),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFFE4EEEE)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 22.sp),
            SizedBox(height: 7.h),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xFF122C2A),
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

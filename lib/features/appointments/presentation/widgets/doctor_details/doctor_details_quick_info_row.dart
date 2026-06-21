import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/appointments/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorDetailsQuickInfoRow extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorDetailsQuickInfoRow({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    final String specialization = doctor.specialization ?? "Veterinarian";
    final String location = doctor.location ??
        doctor.address ??
        doctor.city ??
        "Location not available";

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(
            child: _QuickCard(
              icon: Icons.location_on_rounded,
              title: "Location",
              value: location,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _QuickCard(
              icon: Icons.medical_services_rounded,
              title: "Speciality",
              value: specialization,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _QuickCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFE5EEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .03),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF122C2A),
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

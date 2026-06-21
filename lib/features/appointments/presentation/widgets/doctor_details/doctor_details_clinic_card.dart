import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/appointments/data/models/doctor_model.dart';
import 'package:aleef/features/appointments/presentation/widgets/doctor_details/doctor_details_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorDetailsClinicCard extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorDetailsClinicCard({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    final String location = doctor.location ??
        doctor.address ??
        doctor.city ??
        "Location not available";
    final String specialization = doctor.specialization ?? "Veterinarian";
    final String fee = "${doctor.appointmentFee ?? 0} EGP";

    return DoctorDetailsSectionCard(
      icon: Icons.local_hospital_rounded,
      title: "Clinic Details",
      child: Column(
        children: [
          _DetailRow(
            icon: Icons.location_on_rounded,
            title: "Address",
            value: location,
          ),
          SizedBox(height: 12.h),
          _DetailRow(
            icon: Icons.payments_rounded,
            title: "Appointment Fee",
            value: fee,
          ),
          SizedBox(height: 12.h),
          _DetailRow(
            icon: Icons.medical_services_rounded,
            title: "Specialization",
            value: specialization,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFA),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    color: const Color(0xFF122C2A),
                    fontSize: 13.sp,
                    height: 1.3,
                    fontWeight: FontWeight.w800,
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

import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/appointments/data/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentDetailsDoctorHeader extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentDetailsDoctorHeader({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.1),
                width: 2.w,
              ),
            ),
            child: ClipOval(
              child: Image.network(
                appointment.doctor?.profilePic ?? "",
                width: 72.w,
                height: 72.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 72.w,
                    height: 72.w,
                    color: AppColors.primary.withValues(alpha: 0.05),
                    child: Icon(
                      Icons.person_rounded,
                      color: AppColors.primary,
                      size: 36.sp,
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.doctor?.name ?? "N/A",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1D1E20),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  appointment.doctor?.specialization ?? "General Vet",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    _buildMiniChip(
                      Icons.star_rounded,
                      "4.8",
                      const Color(0xFFFFB800),
                    ),
                    SizedBox(width: 8.w),
                    _buildMiniChip(
                      Icons.location_on_rounded,
                      appointment.doctor?.city ?? "-",
                      AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniChip(IconData icon, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: color),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

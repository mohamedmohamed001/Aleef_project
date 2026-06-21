import 'dart:ui';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/appointments/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorDetailsBookBar extends StatelessWidget {
  final DoctorModel doctor;
  final VoidCallback onBookTap;

  const DoctorDetailsBookBar({
    super.key,
    required this.doctor,
    required this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 14.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .86),
                borderRadius: BorderRadius.circular(26.r),
                border: Border.all(color: Colors.white.withValues(alpha: .9)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: .18),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: SizedBox(
                height: 56.h,
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onBookTap,
                  icon: Icon(
                    Icons.calendar_month_rounded,
                    color: Colors.white,
                    size: 22.sp,
                  ),
                  label: Text(
                    "Book Appointment",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

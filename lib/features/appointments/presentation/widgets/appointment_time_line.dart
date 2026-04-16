import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:aleef/features/appointments/data/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

class AppointmentTimeLine extends StatelessWidget {
  final AppointmentModel appointment;
  const AppointmentTimeLine({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return appointment.status != "cancelled" && appointment.status != "completed" ?
      Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Appointment Timeline", style: AppTextStyles.black16Bold),
          SizedBox(height: 16.h),
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.calendar_today_rounded,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Appointment Requested",
                    style: AppTextStyles.black16Bold.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text("Completed"),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 40,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: VerticalDivider(
                width: 2.w,
                color:
                    appointment.status.toString() == "confirmed" ?
                AppColors.primary: Colors.grey,
                thickness: 4.h,
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: appointment.status.toString() == "confirmed" ?
                  AppColors.primary: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outlined,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Doctor Accepted",
                    style: AppTextStyles.black16Bold.copyWith(
                      color: appointment.status.toString() == "confirmed" ?
                      AppColors.primary: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text("Completed"),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 40,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: VerticalDivider(
                width: 2.w,
                color: appointment.status.toString() == "confirmed" ?
                AppColors.primary: Colors.grey,
                thickness: 4.h,
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: appointment.status.toString() == "confirmed" ?
                  AppColors.primary: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Chat Available",
                    style: AppTextStyles.black16Bold.copyWith(
                      color: appointment.status.toString() == "confirmed" ?
                      AppColors.primary: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text("Completed"),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 40,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: VerticalDivider(
                width: 2.w,
                color: appointment.status.toString() == "confirmed" ?
                AppColors.primary: Colors.grey,
                thickness: 4.h,
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: appointment.status.toString() == "confirmed" ?
                  AppColors.primary: Colors.grey,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(height: 4.h),
                  Text("Completed"),
                ],
              ),
            ],
          ),
        ],
      ),
    ):appointment.status == "cancelled"?
    Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F0), // خلفية خفيفة
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFFFFDAD6),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // 🔴 الايقونة
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.cancel_rounded,
                color: Colors.red,
                size: 20.sp,
              ),
            ),
          ),

          SizedBox(width: 10.w),

          // 🧠 النص
          Expanded(
            child: Text(
              "Appointment Cancelled",
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ):
    Container() ;
  }
}

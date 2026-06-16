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
    final status = appointment.status?.toLowerCase() ?? "";

    if (status == "cancelled") {
      return const _StatusNotice(
        icon: Icons.cancel_rounded,
        title: "Appointment Cancelled",
        message: "This appointment has been cancelled.",
        color: Colors.red,
        backgroundColor: Color(0xFFFFF1F0),
        borderColor: Color(0xFFFFDAD6),
      );
    }

    if (status == "completed") {
      return const _StatusNotice(
        icon: Icons.check_circle_rounded,
        title: "Appointment Completed",
        message: "This appointment has been completed successfully.",
        color: Color(0xFF2E8B57),
        backgroundColor: Color(0xFFEFFAF4),
        borderColor: Color(0xFFD6F2E0),
      );
    }

    final bool isAccepted = status == "accepted";

    final steps = [
      _TimelineStepData(
        icon: Icons.calendar_today_rounded,
        title: "Appointment Requested",
        subtitle: "Your request has been sent",
        isCompleted: true,
      ),
      _TimelineStepData(
        icon: Icons.check_circle_outline_rounded,
        title: "Doctor Accepted",
        subtitle: isAccepted ? "Doctor accepted your appointment" : "Waiting for doctor approval",
        isCompleted: isAccepted,
      ),
      _TimelineStepData(
        icon: Icons.chat_bubble_outline_rounded,
        title: "Chat Available",
        subtitle: isAccepted ? "You can now chat with the doctor" : "Chat will open after acceptance",
        isCompleted: isAccepted,
      ),
      _TimelineStepData(
        icon: Icons.event_available_rounded,
        title: "Visit Completed",
        subtitle: "Complete your appointment visit",
        isCompleted: false,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE8E8E8)),
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Appointment Timeline", style: AppTextStyles.black16Bold),
          SizedBox(height: 18.h),
          ...List.generate(steps.length, (index) {
            return _TimelineStep(
              data: steps[index],
              isLast: index == steps.length - 1,
            );
          }),
        ],
      ),
    );
  }
}

class _TimelineStepData {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isCompleted;

  const _TimelineStepData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
  });
}

class _TimelineStep extends StatelessWidget {
  final _TimelineStepData data;
  final bool isLast;

  const _TimelineStep({
    required this.data,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.primary;
    final inactiveColor = Colors.grey.shade400;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: data.isCompleted ? activeColor : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                data.icon,
                color: data.isCompleted ? Colors.white : inactiveColor,
                size: 19.sp,
              ),
            ),
            if (!isLast)
              Container(
                width: 3.w,
                height: 34.h,
                margin: EdgeInsets.symmetric(vertical: 5.h),
                decoration: BoxDecoration(
                  color: data.isCompleted ? activeColor : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
          ],
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: AppTextStyles.black16Bold.copyWith(
                    fontSize: 15.sp,
                    color: data.isCompleted ? AppColors.primary : Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  data.subtitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusNotice extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Color color;
  final Color backgroundColor;
  final Color borderColor;

  const _StatusNotice({
    required this.icon,
    required this.title,
    required this.message,
    required this.color,
    required this.backgroundColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  message,
                  style: TextStyle(
                    color: color.withOpacity(0.8),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
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
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/appointments/data/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentDetailsActionButtons extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback? onChatTap;
  final VoidCallback? onCancelTap;

  const AppointmentDetailsActionButtons({
    super.key,
    required this.appointment,
    this.onChatTap,
    this.onCancelTap,
  });

  String _doctorFirstName(String doctorName) {
    if (doctorName.trim().isEmpty) return "Doctor";
    return doctorName.trim().split(" ").first;
  }

  @override
  Widget build(BuildContext context) {
    final String status = appointment.status?.toLowerCase() ?? "";
    final bool isAccepted = status == "accepted";
    final bool canCancel = status != "cancelled" && status != "completed" && status != "rejected";
    final String doctorFirstName =
        _doctorFirstName(appointment.doctor?.name ?? "");

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 54.h,
          child: ElevatedButton(
            onPressed: isAccepted ? onChatTap : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade200,
              disabledForegroundColor: Colors.grey,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_rounded, size: 20.sp),
                SizedBox(width: 10.w),
                Text(
                  "Chat with $doctorFirstName",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          height: 54.h,
          child: OutlinedButton(
            onPressed: canCancel ? onCancelTap : null,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              disabledForegroundColor: Colors.grey.shade300,
              side: BorderSide(
                color: canCancel
                    ? AppColors.error.withValues(alpha: 0.5)
                    : Colors.grey.shade200,
                width: 1.5.w,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cancel_outlined, size: 20.sp),
                SizedBox(width: 10.w),
                Text(
                  "Cancel Appointment",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
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

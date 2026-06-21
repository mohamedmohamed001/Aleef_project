import 'package:aleef/features/appointments/data/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentDetailsCard extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentDetailsCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final hasNotes = appointment.notes != null &&
        appointment.notes.toString().trim().isNotEmpty;

    final hasDoctorRejectionReason =
        _isRejectedStatus(appointment.status?.toString() ?? '') &&
            appointment.rejectionReason != null &&
            appointment.rejectionReason.toString().trim().isNotEmpty;

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
        children: [
          _DetailItem(
            icon: Icons.calendar_today_outlined,
            iconColor: const Color(0xFF2E8B83),
            title: "Date",
            value: appointment.date?.toString().split(" ")[0] ?? "-",
          ),
          _DetailItem(
            icon: Icons.access_time_outlined,
            iconColor: const Color(0xFF2E8B83),
            title: "Time",
            value: appointment.time?.toString() ?? "-",
          ),
          _DetailItem(
            icon: Icons.pets_outlined,
            iconColor: const Color(0xFF555555),
            title: "Pet",
            value:
            "${appointment.pet?.name ?? "-"} · ${appointment.pet?.type ?? "-"}",
          ),
          _DetailItem(
            icon: Icons.payments_outlined,
            iconColor: const Color(0xFF2E8B83),
            title: "Appointment Fee",
            value: _formatAppointmentFee(appointment.appointmentFee),
          ),
          _DetailItem(
            icon: Icons.assignment_outlined,
            iconColor: const Color(0xFFC08A3E),
            title: "Reason",
            value: appointment.reason?.toString() ?? "-",
            isLast: !hasNotes && !hasDoctorRejectionReason,
          ),
          if (hasNotes)
            _DetailItem(
              icon: Icons.edit_note_outlined,
              iconColor: const Color(0xFF6E9F6E),
              title: "Notes",
              value: appointment.notes.toString(),
              isLast: !hasDoctorRejectionReason,
            ),
          if (hasDoctorRejectionReason)
            _DetailItem(
              icon: Icons.cancel_outlined,
              iconColor: const Color(0xFFE5484D),
              title: "Doctor Rejection Reason",
              value: appointment.rejectionReason.toString(),
              isLast: true,
            ),
        ],
      ),
    );
  }

  bool _isRejectedStatus(String status) {
    final value = status.trim().toLowerCase();

    return value == 'rejected' ||
        value == 'reject' ||
        value == 'declined' ||
        value == 'cancelled' ||
        value == 'canceled';
  }

  String _formatAppointmentFee(dynamic fee) {
    if (fee == null) return "-";

    final value = fee.toString().trim();

    if (value.isEmpty) return "-";

    return "$value EGP";
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final bool isLast;

  const _DetailItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon, color: iconColor, size: 21.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF8A93A3),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    value.trim().isEmpty ? "-" : value,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xFF1E2432),
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
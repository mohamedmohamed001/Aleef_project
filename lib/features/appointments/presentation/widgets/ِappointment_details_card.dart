import 'package:aleef/features/appointments/data/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentDetailsCard extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentDetailsCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
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
        children: [
          _DetailItem(
            icon: Icons.calendar_today_outlined,
            iconColor: const Color(0xFF2E8B83),
            title: "Date",
            value: appointment.date.toString().split(" ")[0],
          ),
          _DetailItem(
            icon: Icons.access_time_outlined,
            iconColor: Color(0xFF2E8B83),
            title: "Time",
            value: appointment.time.toString(),
          ),
          _DetailItem(
            icon: Icons.pets,
            iconColor: Color(0xFF555555),
            title: "Pet",
            value:
                "${appointment.pet!.name.toString()} · ${appointment.pet!.type.toString()}",
          ),
           _DetailItem(
            icon: Icons.assignment_outlined,
            iconColor: Color(0xFFC08A3E),
            title: "Reason",
            value:appointment.reason.toString() ,
          ),
          appointment.notes != null?
          _DetailItem(
            icon: Icons.edit_note_outlined,
            iconColor: Color(0xFF6E9F6E),
            title: "Notes",
            value: appointment.notes.toString()  ,
            isLast: true,
          ):Container(
            height: 0,
            width: 0,
          ),
        ],
      ),
    );
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
      padding: EdgeInsets.only(bottom: isLast ? 0 : 18.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: const Color(0xFFEDEDED),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon, color: iconColor, size: 22.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF7C8593),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16.sp,
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

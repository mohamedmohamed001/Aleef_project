import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:aleef/features/doctor/home/data/models/confirmed_appointment_model.dart';
import '../pages/appointment_management_screen.dart';

class ConfirmedAppointmentCard extends StatefulWidget {
  final ConfirmedAppointmentModel appointment;

  const ConfirmedAppointmentCard({super.key, required this.appointment});

  @override
  State<ConfirmedAppointmentCard> createState() => _ConfirmedAppointmentCardState();
}

class _ConfirmedAppointmentCardState extends State<ConfirmedAppointmentCard> {
  bool isPressed = false;

  String formatTime(String time24) {
    try {
      final parts = time24.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts[1];
      String period = hour >= 12 ? "PM" : "AM";
      int displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return "$displayHour:$minute $period";
    } catch (e) {
      return time24;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) {
        setState(() => isPressed = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentManagementScreen(appointment: widget.appointment),
          ),
        );
      },
      onTapCancel: () => setState(() => isPressed = false),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // الصورة والعمود يبدأون من الأعلى
          children: [
            CircleAvatar(
              radius: 26.r,
              backgroundImage: widget.appointment.pet.profilePic.isNotEmpty
                  ? NetworkImage(widget.appointment.pet.profilePic)
                  : const AssetImage('assets/images/buddy.png') as ImageProvider,
            ),
            SizedBox(width: 12.w),
            
            // هذا الـ Expanded هو المسؤول عن ترتيب كل النصوص في خط عمودي واحد
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // كل شيء يبدأ من نفس الخط جهة اليسار
                children: [
                  // الاسم والنوع والمالك
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.appointment.pet.name, style: AppTextStyles.title16SemiBold),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text('Confirmed', style: AppTextStyles.primary12Regular.copyWith(color: AppColors.success, fontSize: 10.sp)),
                      ),
                    ],
                  ),
                  Text('${widget.appointment.pet.type} • ${widget.appointment.owner.name}', style: AppTextStyles.body14Regular),
                  
                  SizedBox(height: 12.h), // مسافة موحدة

                  // التاريخ والوقت
                  Row(
                    children: [
                      Icon(Icons.calendar_month, size: 16.sp, color: AppColors.primary),
                      SizedBox(width: 6.w),
                      Text(widget.appointment.date, style: AppTextStyles.label14Medium.copyWith(color: AppColors.textSecondary)),
                      SizedBox(width: 16.w),
                      Icon(Icons.access_time_filled, size: 16.sp, color: AppColors.primary),
                      SizedBox(width: 6.w),
                      Text(formatTime(widget.appointment.time), style: AppTextStyles.label14Medium.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                  
                  SizedBox(height: 8.h),
                  
                  // السبب
                  Text(widget.appointment.reason, style: AppTextStyles.body14Regular.copyWith(color: AppColors.textPrimary)),
                  
                  SizedBox(height: 10.h),
                  
                  // زر التفاصيل
                  Text(
                    'View Details →',
                    style: AppTextStyles.title16SemiBold.copyWith(
                      color: AppColors.primary,
                      fontSize: 13.sp,
                      decoration: isPressed ? TextDecoration.underline : TextDecoration.none,
                      decorationColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
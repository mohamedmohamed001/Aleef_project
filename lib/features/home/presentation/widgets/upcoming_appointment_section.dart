import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/appointments/data/models/appointment_model.dart';
import 'package:aleef/features/appointments/presentation/widgets/appointment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_section_title.dart';

class UpcomingAppointmentSection extends StatelessWidget {
  final bool isLoading;
  final AppointmentModel appointment;
  final VoidCallback onBookTap;
  final VoidCallback onViewDetails;

  const UpcomingAppointmentSection({
    super.key,
    required this.isLoading,
    required this.appointment,
    required this.onBookTap,
    required this.onViewDetails,
  });

  bool get hasAppointment => appointment.doctor?.id != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeSectionTitle(title: "Upcoming Appointment"),
        SizedBox(height: 12.h),
        if (isLoading)
          const _AppointmentLoadingCard()
        else if (hasAppointment)
          AppointmentCard(
            doctorName: appointment.doctor?.name ?? "",
            specialty: appointment.doctor?.specialization ?? "",
            date: appointment.date != null
                ? "${appointment.date!.day}/${appointment.date!.month}/${appointment.date!.year}"
                : "",
            time: appointment.time ?? "",
            petName: appointment.pet?.name ?? "Pet",
            petType: appointment.pet?.type ?? "",
            status: appointment.status ?? "Confirmed",
            imagePath: appointment.doctor?.profilePic ?? "",
            onViewDetails: onViewDetails,
          )
        else
          _EmptyAppointmentCard(
            onBookTap: onBookTap,
          ),
      ],
    );
  }
}

class _EmptyAppointmentCard extends StatelessWidget {
  final VoidCallback onBookTap;

  const _EmptyAppointmentCard({
    required this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(
          color: const Color(0xFFE8EEEE),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 22.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Icon(
              Icons.calendar_month_rounded,
              color: AppColors.primary,
              size: 25.sp,
            ),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "No appointment yet",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFF101828),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "Book a vet visit for your pet.",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFF98A2B3),
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 10.w),

          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onBookTap,
              borderRadius: BorderRadius.circular(18.r),
              child: Ink(
                padding: EdgeInsets.symmetric(
                  horizontal: 17.w,
                  vertical: 11.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.18),
                      blurRadius: 12.r,
                      offset: Offset(0, 6.h),
                    ),
                  ],
                ),
                child: Text(
                  "Book",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentLoadingCard extends StatelessWidget {
  const _AppointmentLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 82.h,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(
          color: const Color(0xFFE8EEEE),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(18.r),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 140.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                ),
                SizedBox(height: 9.h),
                Container(
                  width: 190.w,
                  height: 10.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(100.r),
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
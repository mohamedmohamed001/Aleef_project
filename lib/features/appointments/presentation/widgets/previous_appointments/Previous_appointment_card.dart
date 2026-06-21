import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:aleef/features/appointments/data/models/previous_appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreviousAppointmentCard extends StatelessWidget {
  final PreviousAppointmentModel appointment;

  const PreviousAppointmentCard({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(appointment.status);
    final statusText = _formatStatus(appointment.status);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: const Color(0xFFEFF3F3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(14.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DoctorImage(
                    imageUrl: appointment.doctorProfilePic,
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                appointment.doctorName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.black16Bold.copyWith(
                                  fontSize: 16.sp,
                                  height: 1.2,
                                ),
                              ),
                            ),

                            SizedBox(width: 8.w),

                            _StatusBadge(
                              text: statusText,
                              color: statusColor,
                              icon: _getStatusIcon(appointment.status),
                            ),
                          ],
                        ),

                        SizedBox(height: 5.h),

                        Text(
                          appointment.doctorSpecialization,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF6B7280),
                          ),
                        ),

                        SizedBox(height: 10.h),

                        Row(
                          children: [
                            Expanded(
                              child: _MiniInfoChip(
                                icon: Icons.calendar_today_rounded,
                                text: _formatDate(appointment.date),
                              ),
                            ),

                            SizedBox(width: 8.w),

                            Expanded(
                              child: _MiniInfoChip(
                                icon: Icons.pets_rounded,
                                text: appointment.petName,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7FAFA),
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(
                    color: const Color(0xFFEAF0F0),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 38.w,
                      height: 38.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFF267D77).withOpacity(0.10),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.description_outlined,
                        size: 20.sp,
                        color: const Color(0xFF267D77),
                      ),
                    ),

                    SizedBox(width: 10.w),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Reason",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xFF7A8A89),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          SizedBox(height: 4.h),

                          Text(
                            appointment.reason.trim().isEmpty
                                ? "No reason provided"
                                : appointment.reason,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xFF111827),
                              fontWeight: FontWeight.w600,
                              fontSize: 13.5.sp,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "completed":
        return const Color(0xFF19D58B);
      case "cancelled":
      case "canceled":
        return const Color(0xFFE5484D);
      case "pending":
        return const Color(0xFFE1A514);
      case "accepted":
      case "confirmed":
        return const Color(0xFF267D77);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case "completed":
        return Icons.check_circle_rounded;
      case "cancelled":
      case "canceled":
        return Icons.cancel_rounded;
      case "pending":
        return Icons.schedule_rounded;
      case "accepted":
      case "confirmed":
        return Icons.verified_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  String _formatStatus(String status) {
    final value = status.trim();

    if (value.isEmpty) return "Unknown";

    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "No date";

    final months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    return "${date.day} ${months[date.month - 1]}";
  }
}

class _DoctorImage extends StatelessWidget {
  final String imageUrl;

  const _DoctorImage({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl.trim().isNotEmpty;

    return Container(
      width: 66.w,
      height: 66.w,
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        color: const Color(0xFF267D77).withOpacity(0.10),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child: !hasImage
            ? const _ImageFallback()
            : Image.network(
          imageUrl,
          width: 60.w,
          height: 60.w,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const _ImageFallback(),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;

            return Container(
              color: const Color(0xFFF1F5F5),
              child: Center(
                child: SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.w,
                    color: const Color(0xFF267D77),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEAF3F2),
      child: Icon(
        Icons.person_rounded,
        color: const Color(0xFF267D77),
        size: 32.sp,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;

  const _StatusBadge({
    required this.text,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 105.w,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
          vertical: 5.h,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13.sp,
              color: color,
            ),

            SizedBox(width: 4.w),

            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniInfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MiniInfoChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34.h,
      padding: EdgeInsets.symmetric(
        horizontal: 9.w,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F7),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14.sp,
            color: const Color(0xFF267D77),
          ),

          SizedBox(width: 5.w),

          Expanded(
            child: Text(
              text.trim().isEmpty ? "-" : text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xFF374151),
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
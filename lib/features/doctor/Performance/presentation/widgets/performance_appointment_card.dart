import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/models/doctor_performance_model.dart';
import '../helpers/performance_ui_helpers.dart';

class PerformanceAppointmentCard extends StatelessWidget {
  final DoctorPerformanceAppointmentModel appointment;
  final VoidCallback onTap;

  const PerformanceAppointmentCard({
    super.key,
    required this.appointment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = appointmentStatusColor(appointment.status);
    final profilePic = appointment.pet.profilePic;

    final petName = appointment.pet.name.trim().isEmpty
        ? 'Pet'
        : capitalize(appointment.pet.name);

    final petType = appointment.pet.type.trim().isEmpty
        ? 'Pet'
        : capitalize(appointment.pet.type);

    final petGender = appointment.pet.gender.trim().isEmpty
        ? 'Unknown'
        : capitalize(appointment.pet.gender);

    final ownerName = appointment.owner.name.trim().isEmpty
        ? 'Owner'
        : capitalize(appointment.owner.name);

    final reason = appointment.reason.trim().isEmpty
        ? 'No reason provided'
        : appointment.reason.trim();

    final time = appointment.time.trim().isEmpty ? '--:--' : appointment.time;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(24.r),
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: const Color(0xFFEAF0F0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 18.r,
                offset: Offset(0, 8.h),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PetImage(imageUrl: profilePic),
                  SizedBox(width: 13.w),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  petName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF1F2937),
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              _StatusBadge(
                                text: capitalize(appointment.status),
                                color: statusColor,
                              ),
                            ],
                          ),
                          SizedBox(height: 7.h),
                          Row(
                            children: [
                              Icon(
                                Icons.pets_rounded,
                                size: 14.sp,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 5.w),
                              Expanded(
                                child: Text(
                                  '$petType • $petGender',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF718181),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline_rounded,
                                size: 14.sp,
                                color: const Color(0xFF8A9696),
                              ),
                              SizedBox(width: 5.w),
                              Expanded(
                                child: Text(
                                  ownerName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.5.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF6B7A80),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14.h),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(13.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFA),
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(
                    color: const Color(0xFFEFF4F4),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SmallIconBox(
                          icon: Icons.medical_services_outlined,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 9.w),
                        Expanded(
                          child: Text(
                            reason,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF344054),
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12.h),

                    Row(
                      children: [
                        _MiniInfoChip(
                          icon: Icons.access_time_rounded,
                          text: time,
                        ),

                        if (appointment.cancelledCount > 0) ...[
                          SizedBox(width: 8.w),
                          _CancelledBadge(
                            count: appointment.cancelledCount,
                          ),
                        ],

                        const Spacer(),

                        Container(
                          width: 32.r,
                          height: 32.r,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFEAF0F0),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 17.sp,
                            color: AppColors.primary,
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
      ),
    );
  }
}

class _PetImage extends StatelessWidget {
  final String? imageUrl;

  const _PetImage({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return Container(
      width: 58.r,
      height: 58.r,
      padding: EdgeInsets.all(2.r),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.09),
        borderRadius: BorderRadius.circular(19.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.12),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: hasImage
            ? Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const _PetFallbackIcon(),
        )
            : const _PetFallbackIcon(),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusBadge({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 9.w,
        vertical: 5.h,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.11),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(
        text.trim().isEmpty ? 'Unknown' : text,
        style: TextStyle(
          fontSize: 10.5.sp,
          fontWeight: FontWeight.w900,
          color: color,
          height: 1,
        ),
      ),
    );
  }
}

class _SmallIconBox extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _SmallIconBox({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.r,
      height: 30.r,
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(11.r),
      ),
      child: Icon(
        icon,
        size: 16.sp,
        color: color,
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
      padding: EdgeInsets.symmetric(
        horizontal: 9.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: const Color(0xFFEAF0F0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.sp,
            color: AppColors.primary,
          ),
          SizedBox(width: 5.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF516163),
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _CancelledBadge extends StatelessWidget {
  final int count;

  const _CancelledBadge({
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 9.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE5484D).withOpacity(0.10),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(
        '$count cancelled',
        style: TextStyle(
          fontSize: 10.5.sp,
          fontWeight: FontWeight.w900,
          color: const Color(0xFFE5484D),
          height: 1,
        ),
      ),
    );
  }
}

class _PetFallbackIcon extends StatelessWidget {
  const _PetFallbackIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary.withOpacity(0.08),
      child: Icon(
        Icons.pets_rounded,
        color: AppColors.primary,
        size: 26.sp,
      ),
    );
  }
}
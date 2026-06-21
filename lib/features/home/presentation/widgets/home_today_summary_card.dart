import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/appointments/data/models/appointment_model.dart';
import 'package:aleef/features/pets/data/models/pet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeTodaySummaryCard extends StatelessWidget {
  final PetModel pet;
  final AppointmentModel appointment;
  final VoidCallback onBookTap;
  final VoidCallback onOpenPetTap;
  final VoidCallback onViewAppointmentTap;

  const HomeTodaySummaryCard({
    super.key,
    required this.pet,
    required this.appointment,
    required this.onBookTap,
    required this.onOpenPetTap,
    required this.onViewAppointmentTap,
  });

  bool get hasAppointment => appointment.doctor?.id != null;
  bool get hasOverdue => pet.overdueVaccinations.isNotEmpty;
  bool get hasUpcoming => pet.upcomingVaccinations.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final status = _SummaryStatus.fromPet(pet);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(27.r),
        border: Border.all(
          color: Colors.black.withOpacity(0.055),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.052),
            blurRadius: 24.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CardHeader(
            pet: pet,
            status: status,
            hasOverdue: hasOverdue,
            onOpenPetTap: onOpenPetTap,
          ),
          _CardBody(
            pet: pet,
            appointment: appointment,
            hasAppointment: hasAppointment,
            hasOverdue: hasOverdue,
            hasUpcoming: hasUpcoming,
            onBookTap: onBookTap,
            onViewAppointmentTap: onViewAppointmentTap,
          ),
        ],
      ),
    );
  }
}

// ───────────────── Header ─────────────────

class _CardHeader extends StatelessWidget {
  final PetModel pet;
  final _SummaryStatus status;
  final bool hasOverdue;
  final VoidCallback onOpenPetTap;

  const _CardHeader({
    required this.pet,
    required this.status,
    required this.hasOverdue,
    required this.onOpenPetTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: status.gradientColors,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -35.w,
            top: -38.h,
            child: _GlowCircle(
              size: 128.w,
              color: status.blobColor.withOpacity(0.25),
            ),
          ),
          Positioned(
            left: 70.w,
            bottom: -58.h,
            child: _GlowCircle(
              size: 104.w,
              color: Colors.white.withOpacity(0.07),
            ),
          ),
          Positioned(
            right: 38.w,
            bottom: -48.h,
            child: _GlowCircle(
              size: 72.w,
              color: status.blobColor.withOpacity(0.12),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 45.r,
                    height: 45.r,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.16),
                      ),
                    ),
                    child: Icon(
                      status.icon,
                      color: Colors.white,
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(width: 11.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TODAY FOR',
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white.withOpacity(0.52),
                            letterSpacing: 1.05,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          pet.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.05,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          status.message,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.62),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 13.h),
              Row(
                children: [
                  Flexible(
                    child: _StatusBadge(status: status),
                  ),
                  SizedBox(width: 9.w),
                  _HeaderActionButton(
                    title: hasOverdue ? 'Check now' : 'Open profile',
                    onTap: onOpenPetTap,
                    color: status.buttonColor,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final _SummaryStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.13),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status.badgeIcon,
            size: 12.5.sp,
            color: status.badgeColor,
          ),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              status.badgeText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w800,
                color: status.badgeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color color;

  const _HeaderActionButton({
    required this.title,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(100.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 8.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.075),
                blurRadius: 11.r,
                offset: Offset(0, 5.h),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
              SizedBox(width: 5.w),
              Icon(
                Icons.arrow_forward_rounded,
                size: 13.5.sp,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowCircle({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

// ───────────────── Body ─────────────────

class _CardBody extends StatelessWidget {
  final PetModel pet;
  final AppointmentModel appointment;
  final bool hasAppointment;
  final bool hasOverdue;
  final bool hasUpcoming;
  final VoidCallback onBookTap;
  final VoidCallback onViewAppointmentTap;

  const _CardBody({
    required this.pet,
    required this.appointment,
    required this.hasAppointment,
    required this.hasOverdue,
    required this.hasUpcoming,
    required this.onBookTap,
    required this.onViewAppointmentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 11.h),
      child: Row(
        children: [
          Expanded(
            child: _MiniItem(
              icon: hasOverdue
                  ? Icons.warning_amber_rounded
                  : Icons.vaccines_outlined,
              iconColor: hasOverdue
                  ? const Color(0xFFE5484D)
                  : const Color(0xFF2F80ED),
              bgColor: hasOverdue
                  ? const Color(0xFFE5484D)
                  : const Color(0xFF2F80ED),
              label: 'Vaccines',
              value: _vaccinesText(),
              valueColor: hasOverdue
                  ? const Color(0xFFE5484D)
                  : const Color(0xFF101828),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _MiniItem(
              icon: Icons.description_outlined,
              iconColor: const Color(0xFF8B5CF6),
              bgColor: const Color(0xFF8B5CF6),
              label: 'Records',
              value: '${pet.medicalRecords.length} saved',
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _MiniItem(
              icon: Icons.calendar_month_rounded,
              iconColor: AppColors.primary,
              bgColor: AppColors.primary,
              label: 'Next visit',
              value: hasAppointment ? _appointmentText() : 'Book now',
              valueColor: hasAppointment
                  ? const Color(0xFF101828)
                  : AppColors.primary,
              onTap: hasAppointment ? onViewAppointmentTap : onBookTap,
              showArrow: true,
            ),
          ),
        ],
      ),
    );
  }

  String _vaccinesText() {
    if (pet.overdueVaccinations.isNotEmpty) {
      return '${pet.overdueVaccinations.length} overdue';
    }

    if (pet.upcomingVaccinations.isNotEmpty) {
      return '${pet.upcomingVaccinations.length} upcoming';
    }

    return 'Up to date';
  }

  String _appointmentText() {
    final DateTime? date = appointment.date;
    final String cleanTime = appointment.time?.trim() ?? '';

    if (date == null && cleanTime.isEmpty) {
      return 'Booked';
    }

    if (date == null) {
      return cleanTime;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final apptDay = DateTime(date.year, date.month, date.day);

    final diff = apptDay.difference(today).inDays;

    if (diff == 0) {
      return cleanTime.isEmpty ? 'Today' : 'Today $cleanTime';
    }

    if (diff == 1) {
      return cleanTime.isEmpty ? 'Tomorrow' : 'Tmrw $cleanTime';
    }

    return '${date.day}/${date.month}';
  }
}

class _MiniItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String label;
  final String value;
  final Color valueColor;
  final VoidCallback? onTap;
  final bool showArrow;

  const _MiniItem({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.label,
    required this.value,
    this.valueColor = const Color(0xFF101828),
    this.onTap,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      height: 92.h,
      padding: EdgeInsets.fromLTRB(10.w, 9.h, 8.w, 8.h),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.065),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: bgColor.withOpacity(0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              color: bgColor.withOpacity(0.11),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 16.sp,
            ),
          ),
          const Spacer(),
          Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 8.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF98A2B3),
              letterSpacing: 0.4,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.2.sp,
                    fontWeight: FontWeight.w900,
                    color: valueColor,
                    height: 1.1,
                  ),
                ),
              ),
              if (showArrow) ...[
                SizedBox(width: 3.w),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 9.sp,
                  color: bgColor.withOpacity(0.55),
                ),
              ],
            ],
          ),
        ],
      ),
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: card,
      ),
    );
  }
}

// ───────────────── Status Model ─────────────────

class _SummaryStatus {
  final String message;
  final IconData icon;
  final List<Color> gradientColors;
  final Color blobColor;
  final Color buttonColor;
  final String badgeText;
  final IconData badgeIcon;
  final Color badgeColor;

  const _SummaryStatus({
    required this.message,
    required this.icon,
    required this.gradientColors,
    required this.blobColor,
    required this.buttonColor,
    required this.badgeText,
    required this.badgeIcon,
    required this.badgeColor,
  });

  factory _SummaryStatus.fromPet(PetModel pet) {
    if (pet.overdueVaccinations.isNotEmpty) {
      return const _SummaryStatus(
        message: 'Some care items need attention.',
        icon: Icons.warning_amber_rounded,
        gradientColors: [
          Color(0xFF301316),
          Color(0xFF5A1D22),
        ],
        blobColor: Color(0xFFE5484D),
        buttonColor: Color(0xFFE5484D),
        badgeText: 'Overdue vaccinations',
        badgeIcon: Icons.warning_amber_rounded,
        badgeColor: Color(0xFFFFB4B4),
      );
    }

    if (pet.upcomingVaccinations.isNotEmpty) {
      return const _SummaryStatus(
        message: 'Upcoming vaccine reminder is ready.',
        icon: Icons.vaccines_outlined,
        gradientColors: [
          Color(0xFF0B2445),
          Color(0xFF123D73),
        ],
        blobColor: Color(0xFF2F80ED),
        buttonColor: Color(0xFF2F80ED),
        badgeText: 'Vaccine reminder',
        badgeIcon: Icons.vaccines_outlined,
        badgeColor: Color(0xFFAED4FF),
      );
    }

    return const _SummaryStatus(
      message: 'Everything looks good today.',
      icon: Icons.check_circle_outline_rounded,
      gradientColors: [
        Color(0xFF0D3530),
        Color(0xFF267D77),
      ],
      blobColor: Color(0xFF45C4B8),
      buttonColor: AppColors.primary,
      badgeText: 'All care is up to date',
      badgeIcon: Icons.check_circle_outline_rounded,
      badgeColor: Color(0xFFB7FFF2),
    );
  }
}
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:aleef/features/doctor/home/data/models/confirmed_appointment_model.dart';
import 'package:aleef/features/doctor/home/presentation/pages/appointment_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmedAppointmentCard extends StatefulWidget {
  final ConfirmedAppointmentModel appointment;

  const ConfirmedAppointmentCard({
    super.key,
    required this.appointment,
  });

  @override
  State<ConfirmedAppointmentCard> createState() =>
      _ConfirmedAppointmentCardState();
}

class _ConfirmedAppointmentCardState extends State<ConfirmedAppointmentCard> {
  bool isPressed = false;

  String _formatTime(String time24) {
    try {
      if (time24.trim().isEmpty) return 'No time';

      final parts = time24.split(':');
      if (parts.length < 2) return time24;

      final hour = int.parse(parts[0]);
      final minute = parts[1];

      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

      return '$displayHour:$minute $period';
    } catch (_) {
      return time24;
    }
  }

  String _formatDate(String date) {
    try {
      if (date.trim().isEmpty) return 'No date';

      final parsedDate = DateTime.parse(date);

      final day = parsedDate.day.toString().padLeft(2, '0');
      final month = parsedDate.month.toString().padLeft(2, '0');
      final year = parsedDate.year.toString();

      return '$day/$month/$year';
    } catch (_) {
      return date;
    }
  }

  void _openDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AppointmentManagementScreen(
          appointment: widget.appointment,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appointment = widget.appointment;
    final pet = appointment.pet;
    final owner = appointment.owner;

    final String petName = pet.name.trim().isEmpty ? 'Pet Name' : pet.name;
    final String petType = pet.type.trim().isEmpty ? 'Pet' : pet.type;
    final String ownerName = owner.name.trim().isEmpty ? 'Owner' : owner.name;
    final String reason = appointment.reason.trim().isEmpty
        ? 'No reason provided'
        : appointment.reason;
    final String petImage = pet.profilePic?.trim() ?? '';

    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) {
        setState(() => isPressed = false);
        _openDetails();
      },
      onTapCancel: () => setState(() => isPressed = false),
      child: AnimatedScale(
        scale: isPressed ? 0.975 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.045),
                blurRadius: 22.r,
                offset: Offset(0, 10.h),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.025),
                blurRadius: 12.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: Stack(
              children: [
                Positioned(
                  right: -32.w,
                  top: -34.h,
                  child: Container(
                    width: 120.r,
                    height: 120.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.055),
                    ),
                  ),
                ),

                Positioned(
                  left: -45.w,
                  bottom: -55.h,
                  child: Container(
                    width: 130.r,
                    height: 130.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.success.withOpacity(0.045),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _PetAvatar(imageUrl: petImage),

                          SizedBox(width: 12.w),

                          Expanded(
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
                                        style: AppTextStyles.title16SemiBold
                                            .copyWith(
                                          fontSize: 17.sp,
                                          color: AppColors.textPrimary,
                                          height: 1.15,
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 8.w),

                                    const _ConfirmedBadge(),
                                  ],
                                ),

                                SizedBox(height: 6.h),

                                Row(
                                  children: [
                                    Icon(
                                      Icons.pets_rounded,
                                      size: 15.sp,
                                      color:
                                      AppColors.primary.withOpacity(0.85),
                                    ),
                                    SizedBox(width: 5.w),
                                    Expanded(
                                      child: Text(
                                        '$petType • $ownerName',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                        AppTextStyles.body14Regular.copyWith(
                                          color: AppColors.textSecondary,
                                          fontSize: 13.sp,
                                          height: 1.2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      Row(
                        children: [
                          Expanded(
                            child: _InfoBox(
                              icon: Icons.calendar_month_rounded,
                              label: 'Date',
                              value: _formatDate(appointment.date),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _InfoBox(
                              icon: Icons.access_time_filled_rounded,
                              label: 'Time',
                              value: _formatTime(appointment.time),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 14.h),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFA),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.055),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 30.r,
                              height: 30.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary.withOpacity(0.09),
                              ),
                              child: Icon(
                                Icons.notes_rounded,
                                size: 16.sp,
                                color: AppColors.primary,
                              ),
                            ),

                            SizedBox(width: 9.w),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reason',
                                    style:
                                    AppTextStyles.label14Medium.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 11.sp,
                                      height: 1.1,
                                    ),
                                  ),

                                  SizedBox(height: 4.h),

                                  Text(
                                    reason,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                    AppTextStyles.body14Regular.copyWith(
                                      color: AppColors.textPrimary,
                                      fontSize: 13.sp,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 14.h),

                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1.h,
                              color: AppColors.primary.withOpacity(0.07),
                            ),
                          ),

                          SizedBox(width: 12.w),

                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 13.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.09),
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'View Details',
                                  style: AppTextStyles.title16SemiBold.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 12.5.sp,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 16.sp,
                                  color: AppColors.primary,
                                ),
                              ],
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
      ),
    );
  }
}

class _PetAvatar extends StatelessWidget {
  final String imageUrl;

  const _PetAvatar({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage = imageUrl.isNotEmpty;

    return Container(
      width: 58.r,
      height: 58.r,
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.95),
            AppColors.primary.withOpacity(0.35),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.16),
            blurRadius: 12.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(2.r),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: ClipOval(
          child: hasImage
              ? Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _fallbackAvatar(),
          )
              : _fallbackAvatar(),
        ),
      ),
    );
  }

  Widget _fallbackAvatar() {
    return Image.asset(
      'assets/images/buddy.png',
      fit: BoxFit.cover,
    );
  }
}

class _ConfirmedBadge extends StatelessWidget {
  const _ConfirmedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 9.w,
        vertical: 5.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.10),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: AppColors.success.withOpacity(0.16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.success,
            ),
          ),
          SizedBox(width: 5.w),
          Text(
            'Confirmed',
            style: AppTextStyles.primary12Regular.copyWith(
              color: AppColors.success,
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoBox({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 11.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.055),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.07),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.06),
                  blurRadius: 8.r,
                  offset: Offset(0, 3.h),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 17.sp,
              color: AppColors.primary,
            ),
          ),

          SizedBox(width: 8.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body14Regular.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10.5.sp,
                    height: 1.05,
                  ),
                ),

                SizedBox(height: 3.h),

                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label14Medium.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
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
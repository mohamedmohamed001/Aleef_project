import 'dart:io';

import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentCard extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String date;
  final String time;
  final String petName;
  final String petType;
  final String status;
  final String imagePath;
  final VoidCallback? onViewDetails;

  const AppointmentCard({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    required this.petName,
    required this.petType,
    this.status = "Confirmed",
    this.imagePath = AppAssets.profilePhoto,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final statusData = _StatusData.fromStatus(status);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onViewDetails,
        borderRadius: BorderRadius.circular(28.r),
        child: Ink(
          width: double.infinity,
          decoration: BoxDecoration(
            color: statusData.cardBackgroundColor,
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(
              color: statusData.cardBorderColor,
              width: 1.w,
            ),
            boxShadow: [
              BoxShadow(
                color: statusData.cardShadowColor,
                blurRadius: 24.r,
                offset: Offset(0, 12.h),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28.r),
            child: Column(
              children: [
                _TopArea(
                  doctorName: doctorName,
                  specialty: specialty,
                  imagePath: imagePath,
                  statusData: statusData,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(14.w, 13.h, 14.w, 14.h),
                  child: Column(
                    children: [
                      _AppointmentInfoStrip(
                        date: date,
                        time: time,
                        petName: petName,
                        petType: petType,
                        statusData: statusData,
                      ),
                      SizedBox(height: 13.h),
                      Row(
                        children: [
                          Expanded(
                            child: _MiniNote(
                              petName: petName,
                              petType: petType,
                              statusData: statusData,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          _DetailsButton(
                            onTap: onViewDetails,
                            color: statusData.contentAccentColor,
                            text: statusData.buttonText,
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

class _TopArea extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String imagePath;
  final _StatusData statusData;

  const _TopArea({
    required this.doctorName,
    required this.specialty,
    required this.imagePath,
    required this.statusData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: statusData.cardGradientColors,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -42.w,
            top: -48.h,
            child: _SoftCircle(
              size: 118.r,
              opacity: 0.13,
            ),
          ),
          Positioned(
            right: 55.w,
            bottom: -54.h,
            child: _SoftCircle(
              size: 96.r,
              opacity: 0.07,
            ),
          ),
          Row(
            children: [
              _DoctorImage(
                imagePath: imagePath,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName.trim().isEmpty ? "Doctor" : doctorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      specialty.trim().isEmpty ? "Veterinarian" : specialty,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.82),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              _StatusChip(
                data: statusData,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DoctorImage extends StatelessWidget {
  final String imagePath;

  const _DoctorImage({
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath.trim().isNotEmpty;

    return Container(
      width: 62.r,
      height: 62.r,
      padding: EdgeInsets.all(2.5.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(21.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.22),
          width: 1.w,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: hasImage
            ? _BuildImage(path: imagePath)
            : const _DoctorFallback(),
      ),
    );
  }
}

class _BuildImage extends StatelessWidget {
  final String path;

  const _BuildImage({
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const _DoctorFallback(),
      );
    }

    if (path.startsWith('assets')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const _DoctorFallback(),
      );
    }

    return Image.file(
      File(path),
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const _DoctorFallback(),
    );
  }
}

class _DoctorFallback extends StatelessWidget {
  const _DoctorFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.12),
      child: Icon(
        Icons.medical_services_rounded,
        color: Colors.white,
        size: 28.sp,
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final _StatusData data;

  const _StatusChip({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 120.w,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 7.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.14),
          width: 1.w,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(
              color: data.dotColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              data.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentInfoStrip extends StatelessWidget {
  final String date;
  final String time;
  final String petName;
  final String petType;
  final _StatusData statusData;

  const _AppointmentInfoStrip({
    required this.date,
    required this.time,
    required this.petName,
    required this.petType,
    required this.statusData,
  });

  @override
  Widget build(BuildContext context) {
    final color = statusData.contentAccentColor;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 12.h,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.055),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: color.withOpacity(0.12),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _InlineInfo(
                  icon: Icons.calendar_month_rounded,
                  label: "Date",
                  value: date.trim().isEmpty ? "--" : date,
                  color: color,
                ),
              ),
              _DividerLine(
                color: color,
              ),
              Expanded(
                child: _InlineInfo(
                  icon: Icons.access_time_rounded,
                  label: "Time",
                  value: time.trim().isEmpty ? "--" : time,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 10.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: color.withOpacity(0.12),
                width: 1.w,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32.r,
                  height: 32.r,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.pets_rounded,
                    color: color,
                    size: 17.sp,
                  ),
                ),
                SizedBox(width: 9.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        petName.trim().isEmpty ? "Pet" : petName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: const Color(0xFF101828),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        petType.trim().isEmpty
                            ? "Pet appointment"
                            : "${petType.trim()} appointment",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: const Color(0xFF667085),
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w600,
                          height: 1,
                        ),
                      ),
                    ],
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

class _InlineInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InlineInfo({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34.r,
          height: 34.r,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13.r),
            border: Border.all(
              color: color.withOpacity(0.12),
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: 17.sp,
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
                style: TextStyle(
                  color: const Color(0xFF98A2B3),
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF101828),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DividerLine extends StatelessWidget {
  final Color color;

  const _DividerLine({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.w,
      height: 34.h,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      color: color.withOpacity(0.12),
    );
  }
}

class _MiniNote extends StatelessWidget {
  final String petName;
  final String petType;
  final _StatusData statusData;

  const _MiniNote({
    required this.petName,
    required this.petType,
    required this.statusData,
  });

  @override
  Widget build(BuildContext context) {
    final name = petName.trim().isEmpty ? "your pet" : petName.trim();
    final color = statusData.contentAccentColor;

    return Row(
      children: [
        Container(
          width: 28.r,
          height: 28.r,
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(
            statusData.noteIcon,
            color: color,
            size: 15.sp,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            statusData.noteText(name),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF667085),
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailsButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color color;
  final String text;

  const _DetailsButton({
    required this.onTap,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100.r),
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 10.h,
          ),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(100.r),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.18),
                blurRadius: 12.r,
                offset: Offset(0, 6.h),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              SizedBox(width: 6.w),
              Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusData {
  final String label;
  final Color dotColor;
  final Color buttonColor;
  final String buttonText;
  final IconData noteIcon;
  final List<Color> gradientColors;
  final String Function(String petName) noteText;

  const _StatusData({
    required this.label,
    required this.dotColor,
    required this.buttonColor,
    required this.buttonText,
    required this.noteIcon,
    required this.gradientColors,
    required this.noteText,
  });

  bool get isRejectedOrCancelled {
    final lowerLabel = label.toLowerCase();

    return lowerLabel.contains("rejected") ||
        lowerLabel.contains("cancelled") ||
        lowerLabel.contains("canceled");
  }

  Color get cardBackgroundColor {
    if (isRejectedOrCancelled) {
      return const Color(0xFFFFFAFA);
    }

    return Colors.white;
  }

  Color get cardBorderColor {
    if (isRejectedOrCancelled) {
      return buttonColor.withOpacity(0.18);
    }

    return const Color(0xFFE7EEEE);
  }

  Color get cardShadowColor {
    if (isRejectedOrCancelled) {
      return buttonColor.withOpacity(0.10);
    }

    return Colors.black.withOpacity(0.055);
  }

  List<Color> get cardGradientColors {
    if (isRejectedOrCancelled) {
      return gradientColors;
    }

    return const [
      AppColors.primary,
      Color(0xFF20736D),
      Color(0xFF17635E),
    ];
  }

  Color get contentAccentColor {
    if (isRejectedOrCancelled) {
      return buttonColor;
    }

    return AppColors.primary;
  }

  factory _StatusData.fromStatus(String status) {
    final lower = status.toLowerCase().trim();

    if (lower.isEmpty) {
      return _confirmed();
    }

    if (lower.contains("pending")) {
      return _pending();
    }

    if (lower.contains("accepted") ||
        lower.contains("confirmed") ||
        lower == "accept") {
      return _confirmed();
    }

    if (lower.contains("completed")) {
      return _completed();
    }

    if (lower.contains("cancelled-by-owner") ||
        lower.contains("canceled-by-owner")) {
      return _cancelledByOwner();
    }

    if (lower.contains("cancelled-by-doctor") ||
        lower.contains("canceled-by-doctor")) {
      return _cancelledByDoctor();
    }

    if (lower.contains("rejected") ||
        lower.contains("reject") ||
        lower.contains("declined") ||
        lower.contains("decline")) {
      return _rejected();
    }

    if (lower.contains("cancelled") || lower.contains("canceled")) {
      return _cancelled();
    }

    return _StatusData(
      label: _formatUnknownStatus(lower),
      dotColor: const Color(0xFF23E58B),
      buttonColor: AppColors.primary,
      buttonText: "Details",
      noteIcon: Icons.event_available_rounded,
      gradientColors: const [
        AppColors.primary,
        Color(0xFF20736D),
        Color(0xFF17635E),
      ],
      noteText: (petName) => "Visit scheduled for $petName",
    );
  }

  static _StatusData _confirmed() {
    return const _StatusData(
      label: "Confirmed",
      dotColor: Color(0xFF23E58B),
      buttonColor: AppColors.primary,
      buttonText: "Details",
      noteIcon: Icons.event_available_rounded,
      gradientColors: [
        AppColors.primary,
        Color(0xFF20736D),
        Color(0xFF17635E),
      ],
      noteText: _confirmedText,
    );
  }

  static _StatusData _pending() {
    return const _StatusData(
      label: "Pending",
      dotColor: Color(0xFFFFC857),
      buttonColor: Color(0xFFB97800),
      buttonText: "Details",
      noteIcon: Icons.hourglass_top_rounded,
      gradientColors: [
        Color(0xFFB97800),
        Color(0xFF9A6500),
        Color(0xFF7C5200),
      ],
      noteText: _pendingText,
    );
  }

  static _StatusData _completed() {
    return const _StatusData(
      label: "Completed",
      dotColor: Color(0xFF9EE7FF),
      buttonColor: Color(0xFF2F80ED),
      buttonText: "Details",
      noteIcon: Icons.check_circle_rounded,
      gradientColors: [
        Color(0xFF2F80ED),
        Color(0xFF256FD0),
        Color(0xFF1D5BA8),
      ],
      noteText: _completedText,
    );
  }

  static _StatusData _rejected() {
    return const _StatusData(
      label: "Rejected",
      dotColor: Color(0xFFFFB4B4),
      buttonColor: Color(0xFFE5484D),
      buttonText: "Reason",
      noteIcon: Icons.cancel_rounded,
      gradientColors: [
        Color(0xFFE5484D),
        Color(0xFFC93C42),
        Color(0xFFA83238),
      ],
      noteText: _rejectedText,
    );
  }

  static _StatusData _cancelledByOwner() {
    return const _StatusData(
      label: "Cancelled by Owner",
      dotColor: Color(0xFFFFB4B4),
      buttonColor: Color(0xFFE5484D),
      buttonText: "Details",
      noteIcon: Icons.person_off_rounded,
      gradientColors: [
        Color(0xFFE5484D),
        Color(0xFFC93C42),
        Color(0xFFA83238),
      ],
      noteText: _cancelledByOwnerText,
    );
  }

  static _StatusData _cancelledByDoctor() {
    return const _StatusData(
      label: "Cancelled by Doctor",
      dotColor: Color(0xFFFFB4B4),
      buttonColor: Color(0xFFE5484D),
      buttonText: "Reason",
      noteIcon: Icons.medical_services_outlined,
      gradientColors: [
        Color(0xFFE5484D),
        Color(0xFFC93C42),
        Color(0xFFA83238),
      ],
      noteText: _cancelledByDoctorText,
    );
  }

  static _StatusData _cancelled() {
    return const _StatusData(
      label: "Cancelled",
      dotColor: Color(0xFFFFB4B4),
      buttonColor: Color(0xFFE5484D),
      buttonText: "Details",
      noteIcon: Icons.event_busy_rounded,
      gradientColors: [
        Color(0xFFE5484D),
        Color(0xFFC93C42),
        Color(0xFFA83238),
      ],
      noteText: _cancelledText,
    );
  }

  static String _confirmedText(String petName) {
    return "Visit scheduled for $petName";
  }

  static String _pendingText(String petName) {
    return "Waiting for doctor approval";
  }

  static String _completedText(String petName) {
    return "Visit completed for $petName";
  }

  static String _rejectedText(String petName) {
    return "Appointment rejected by doctor";
  }

  static String _cancelledByOwnerText(String petName) {
    return "Appointment cancelled by you";
  }

  static String _cancelledByDoctorText(String petName) {
    return "Appointment cancelled by doctor";
  }

  static String _cancelledText(String petName) {
    return "Appointment cancelled";
  }

  static String _formatUnknownStatus(String text) {
    if (text.isEmpty) return text;

    return text
        .replaceAll('-', ' ')
        .split(' ')
        .where((word) => word.trim().isNotEmpty)
        .map(_capitalize)
        .join(' ');
  }

  static String _capitalize(String text) {
    if (text.isEmpty) return text;

    return text[0].toUpperCase() + text.substring(1);
  }
}

class _SoftCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _SoftCircle({
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}
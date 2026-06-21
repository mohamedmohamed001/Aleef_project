import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentStatusChip extends StatelessWidget {
  final String status;

  const AppointmentStatusChip({
    super.key,
    required this.status,
  });

  String get _lowerStatus => status.toLowerCase().trim();

  bool get isConfirmed =>
      _lowerStatus == "confirmed" ||
          _lowerStatus == "accepted" ||
          _lowerStatus == "accept";

  bool get isPending => _lowerStatus == "pending";

  bool get isCompleted => _lowerStatus == "completed";

  bool get isCancelled =>
      _lowerStatus.contains("cancelled") ||
          _lowerStatus.contains("canceled");

  bool get isRejected =>
      _lowerStatus.contains("rejected") ||
          _lowerStatus.contains("reject") ||
          _lowerStatus.contains("declined") ||
          _lowerStatus.contains("decline");

  bool get isDanger => isCancelled || isRejected;

  String get displayStatus {
    if (_lowerStatus.isEmpty) return "Status";

    return status
        .replaceAll('-', ' ')
        .split(' ')
        .where((word) => word.trim().isNotEmpty)
        .map((word) {
      final clean = word.trim();
      return clean[0].toUpperCase() + clean.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor;
    final Color textColor;
    final Color borderColor;

    if (isDanger) {
      backgroundColor = const Color(0xFFFFF1F2);
      textColor = const Color(0xFFE5484D);
      borderColor = const Color(0xFFE5484D).withOpacity(0.18);
    } else {
      backgroundColor = AppColors.primary.withOpacity(0.12);
      textColor = AppColors.primary;
      borderColor = AppColors.primary.withOpacity(0.16);
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 6.h,
      ),
      constraints: BoxConstraints(
        maxWidth: 125.w,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: borderColor,
          width: 1.w,
        ),
      ),
      child: Text(
        displayStatus,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: AppTextStyles.primary12Regular.copyWith(
          fontSize: 11.sp,
          color: textColor,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
  }
}
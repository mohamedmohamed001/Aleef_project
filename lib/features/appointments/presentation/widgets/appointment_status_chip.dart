import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentStatusChip extends StatelessWidget {
  final String status;

  const AppointmentStatusChip({super.key, required this.status});

  bool get isConfirmed => status.toLowerCase() == "confirmed";

  bool get isPending => status.toLowerCase() == "pending";

  bool get isCompleted => status.toLowerCase() == "completed";

  bool get isCancelled => status.toLowerCase() == "cancelled";


  @override
  Widget build(BuildContext context) {
    final Color backgroundColor;
    final Color textColor;

    if (isConfirmed) {
      backgroundColor = const Color(0xFF22C55E).withOpacity(0.18);
      textColor = const Color(0xFFBBF7D0);
    } else if (isPending) {
      backgroundColor = const Color(0xFFF59E0B).withOpacity(0.18);
      textColor = const Color(0xFFFCD34D);
    } else if (isCompleted) {
      backgroundColor =  AppColors.primary.withOpacity(0.40);
      textColor = const Color(0xFFA6F4DE);
    } else if ( isCancelled){
      backgroundColor =  Colors.red.withOpacity(0.40);
      textColor = Colors.red;
    }
    else {
      backgroundColor = Colors.transparent;
      textColor = Colors.transparent;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      constraints: BoxConstraints(
        maxWidth: 110.w, // مهم جدًا عشان ميكسرش اللي حواليه
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: AppTextStyles.primary12Regular.copyWith(
          fontSize: 11.sp,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

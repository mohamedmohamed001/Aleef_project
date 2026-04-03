import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppointmentStatusChip extends StatelessWidget {
  final String status;

  const AppointmentStatusChip({
    super.key,
    required this.status,
  });

  bool get isConfirmed => status.toLowerCase() == "confirmed";
  bool get isPending => status.toLowerCase() == "pending";

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
    } else {
      backgroundColor = Colors.white.withOpacity(0.18);
      textColor = Colors.white;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: AppTextStyles.primary12Regular.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
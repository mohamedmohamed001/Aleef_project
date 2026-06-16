import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReceiptRow extends StatelessWidget {
  final String title;
  final double value;
  final bool isTotal;

  const ReceiptRow({
    super.key,
    required this.title,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isTotal ? const Color(0xFF152E2C) : const Color(0xFF7A8C8A),
            fontSize: isTotal ? 17.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
        Text(
          "\$${value.toStringAsFixed(2)}",
          style: TextStyle(
            color: isTotal ? AppColors.primary : const Color(0xFF152E2C),
            fontSize: isTotal ? 21.sp : 14.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

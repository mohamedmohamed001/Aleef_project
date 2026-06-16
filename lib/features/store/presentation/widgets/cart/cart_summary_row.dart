import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aleef/core/theme/app_colors.dart';

class CartSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const CartSummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? const Color(0xFF1D1E20) : AppColors.hint,
            fontSize: isTotal ? 18.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF1D1E20),
            fontSize: isTotal ? 20.sp : 15.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

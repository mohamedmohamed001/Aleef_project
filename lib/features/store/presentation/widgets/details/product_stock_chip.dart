import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aleef/core/theme/app_colors.dart';

class ProductStockChip extends StatelessWidget {
  final int availableStock;

  const ProductStockChip({
    super.key,
    required this.availableStock,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    Color bgColor;
    String text;

    if (availableStock > 5) {
      color = AppColors.primary;
      bgColor = AppColors.primary.withValues(alpha: 0.1);
      text = "In stock";
    } else if (availableStock > 0) {
      color = AppColors.warning;
      bgColor = AppColors.warning.withValues(alpha: 0.12);
      text = "Only $availableStock items left";
    } else {
      color = Colors.red;
      bgColor = Colors.red.withValues(alpha: 0.1);
      text = "Out of stock";
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 13.sp,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

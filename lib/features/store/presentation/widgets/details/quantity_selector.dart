import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// ➖ Minus
          SizedBox(
            width: 34.w,
            height: 34.h,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: onDecrement,
              icon: const Icon(
                Icons.remove,
                size: 18,
                color: Color(0xFF1D1E20),
              ),
            ),
          ),

          SizedBox(width: 6.w),

          /// 🔢 Quantity
          Text(
            '$quantity',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1E20),
            ),
          ),

          SizedBox(width: 6.w),

          /// ➕ Plus
          SizedBox(
            width: 34.w,
            height: 34.h,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: onIncrement,
              icon: Icon(
                Icons.add,
                size: 18,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
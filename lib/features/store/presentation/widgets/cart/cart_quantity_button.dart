import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aleef/core/theme/app_colors.dart';

class CartQuantityButton extends StatelessWidget {
  final IconData icon;
  final bool isPrimary;
  final bool isEnabled;
  final VoidCallback onTap;

  const CartQuantityButton({
    super.key,
    required this.icon,
    this.isPrimary = false,
    this.isEnabled = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = !isEnabled
        ? Colors.grey.shade200
        : isPrimary
            ? AppColors.primary
            : Colors.white;

    final Color borderColor = !isEnabled
        ? Colors.grey.shade300
        : isPrimary
            ? AppColors.primary
            : const Color(0xFFE0E0E0);

    final Color iconColor = !isEnabled
        ? Colors.grey
        : isPrimary
            ? Colors.white
            : Colors.black;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: isEnabled ? 1 : 0.5,
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 1.w),
          ),
          child: Icon(
            icon,
            size: 16.sp,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}

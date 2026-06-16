import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

class StoreCategoryChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const StoreCategoryChip({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  IconData get icon {
    switch (title.toLowerCase()) {
      case 'dogs':
        return Icons.pets_rounded;
      case 'cats':
        return Icons.cruelty_free_rounded;
      case 'food':
        return Icons.restaurant_rounded;
      case 'toys':
        return Icons.sports_baseball_rounded;
      default:
        return Icons.grid_view_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.primary.withOpacity(0.12),
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.22)
                    : Colors.black.withOpacity(0.04),
                blurRadius: 12.r,
                offset: Offset(0, 6.h),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16.sp,
                color: isSelected ? Colors.white : AppColors.primary,
              ),
              SizedBox(width: 7.w),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF172222),
                  fontWeight: FontWeight.w800,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
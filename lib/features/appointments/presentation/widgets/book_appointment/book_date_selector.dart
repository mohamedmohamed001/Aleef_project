import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'book_empty_message.dart';

class BookDateSelector extends StatelessWidget {
  final List<dynamic> availableDays;
  final int selectedIndex;
  final ValueChanged<int> onDateSelected;

  const BookDateSelector({
    super.key,
    required this.availableDays,
    required this.selectedIndex,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (availableDays.isEmpty) {
      return const BookEmptyMessage(message: "No available days");
    }

    return SizedBox(
      height: 92.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: availableDays.length,
        separatorBuilder: (_, _) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final item = availableDays[index];
          final isSelected = selectedIndex == index;

          final display = item.display?.toString() ?? "";
          final parts = display.trim().split(RegExp(r'\s+'));

          final day = parts.isNotEmpty ? parts[0] : "";
          final date = parts.length >= 3 ? parts[2] : "";

          return GestureDetector(
            onTap: () => onDateSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: 72.w,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(22.r),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade200,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.18)
                        : Colors.black.withOpacity(0.025),
                    blurRadius: isSelected ? 12.r : 8.r,
                    offset: Offset(0, isSelected ? 6.h : 4.h),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 7.h),
                  Text(
                    date,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
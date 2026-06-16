import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class StoreSortButton extends StatelessWidget {
  final Map<String, String> sortOptions;
  final String? selectedSort;
  final ValueChanged<String?> onSortChanged;

  const StoreSortButton({
    super.key,
    required this.sortOptions,
    required this.selectedSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      onSelected: onSortChanged,
      itemBuilder: (context) {
        return sortOptions.keys.map((title) {
          return PopupMenuItem<String>(
            value: title,
            child: Row(
              children: [
                if (selectedSort == title)
                  Icon(
                    Icons.check_rounded,
                    color: AppColors.primary,
                    size: 18.sp,
                  )
                else
                  SizedBox(width: 18.sp),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        height: 42.h,
        width: 42.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFFE6ECEC)),
        ),
        child: Icon(
          Icons.tune_rounded,
          color: AppColors.primary,
          size: 21.sp,
        ),
      ),
    );
  }
}

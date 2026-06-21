import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class StoreCategoryList extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const StoreCategoryList({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = category == selectedCategory;

          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: selected ? AppColors.primary : const Color(0xFFE6ECEC),
                ),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF667170),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

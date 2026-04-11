import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

class StoreSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const StoreSearchBar({
    super.key,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            size: 20,
            color: AppColors.hint,
          ),

          SizedBox(width: 8.w),

          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: AppColors.hint,
                ),
                border: InputBorder.none,
                isCollapsed: true, // 🔥 مهم عشان يمنع الزنقة
              ),
            ),
          ),
        ],
      ),
    );
  }
}
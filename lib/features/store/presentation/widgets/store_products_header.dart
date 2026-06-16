import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoreProductsHeader extends StatelessWidget {
  final String title;
  final int count;
  final Widget sortButton;

  const StoreProductsHeader({
    super.key,
    required this.title,
    required this.count,
    required this.sortButton,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF1D1E20),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                '$count items found',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.42),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        sortButton,
      ],
    );
  }
}

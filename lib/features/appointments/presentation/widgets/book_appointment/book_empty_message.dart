import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookEmptyMessage extends StatelessWidget {
  final String message;

  const BookEmptyMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.red,
          fontSize: 14.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

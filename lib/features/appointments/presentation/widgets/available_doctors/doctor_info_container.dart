import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorInfoContainer extends StatelessWidget {
  final Widget child;

  const DoctorInfoContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.grey.shade700,
          height: 1.7,
        ),
        child: child,
      ),
    );
  }
}
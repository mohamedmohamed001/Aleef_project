import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorDetailsSectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const DoctorDetailsSectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .035),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(icon, color: AppColors.primary, size: 21.sp),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF122C2A),
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }
}

import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorEditProfileSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const DoctorEditProfileSection({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: const Color(0xFFE8EEEE),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 14.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(13.r),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 19.sp,
                ),
              ),

              SizedBox(width: 10.w),

              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1F2937),
                    letterSpacing: -0.1,
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
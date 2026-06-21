import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionCard extends StatelessWidget {
  final String title;
  final String buttonText;
  final IconData icon;
  final Color borderColor;
  final VoidCallback onTap;

  const ActionCard({
    super.key,
    required this.title,
    required this.buttonText,
    required this.icon,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: borderColor,
          width: 1.3.w,
        ),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.25),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                color: const Color(0xFF001533),
                fontWeight: FontWeight.w900,
                height: 1.35,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 20.sp,
                    color: const Color(0xFF344054),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    buttonText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF001533),
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
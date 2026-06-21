import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class AppointmentInfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String mainText;
  final String subText;

  const AppointmentInfoItem({
    super.key,
    required this.icon,
    required this.title,
    required this.mainText,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44.r,
          height: 44.r,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(38, 125, 119, 0.08),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            size: 20.sp,
            color: AppColors.primary,
          ),
        ),

        SizedBox(width: 12.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body14Regular.copyWith(
                  fontSize: 11.sp,
                  color: Colors.grey.shade600,
                ),
              ),

              SizedBox(height: 2.h),

              Text(
                mainText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.title16SemiBold.copyWith(
                  fontSize: 13.sp,
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: 2.h),

              Text(
                subText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body14Regular.copyWith(
                  fontSize: 11.sp,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
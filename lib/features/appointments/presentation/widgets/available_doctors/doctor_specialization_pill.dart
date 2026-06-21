import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

class DoctorSpecializationPill extends StatelessWidget {
  final String text;

  const DoctorSpecializationPill({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final cleanText =
    text.trim().isEmpty || text == 'null' ? 'Veterinary' : text.trim();

    return Container(
      constraints: BoxConstraints(maxWidth: 190.w),
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(99.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.08),
          width: 1.w,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.medical_services_rounded,
            size: 13.r,
            color: AppColors.primary,
          ),
          SizedBox(width: 5.w),
          Flexible(
            child: Text(
              cleanText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
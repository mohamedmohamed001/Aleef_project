import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

class DoctorArrowButton extends StatelessWidget {
  final VoidCallback? onTap;

  const DoctorArrowButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 31.w,
        height: 31.w,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 11.r,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
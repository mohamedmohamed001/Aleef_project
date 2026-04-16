import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorSectionTitle extends StatelessWidget {
  final String title;

  const DoctorSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.titleLarge.copyWith(
        fontSize: 20.sp,
      ),
    );
  }
}
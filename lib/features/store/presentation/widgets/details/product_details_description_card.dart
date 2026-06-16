import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_text_styles.dart';

class ProductDetailsDescriptionCard extends StatelessWidget {
  final String description;

  const ProductDetailsDescriptionCard({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: AppTextStyles.black16Bold.copyWith(
              fontSize: 17.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            description,
            style: AppTextStyles.body14Regular.copyWith(
              height: 1.6,
              color: Colors.black.withValues(alpha: 0.68),
            ),
          ),
        ],
      ),
    );
  }
}

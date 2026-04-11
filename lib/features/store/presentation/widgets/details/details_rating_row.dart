import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

class DetailsRatingRow extends StatelessWidget {
  final double avgRate;
  final int ratingQuantity;

  const DetailsRatingRow({super.key, required this.avgRate, required this.ratingQuantity,});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
          5,
              (index) => Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: Icon(
              Icons.star,
              color: AppColors.primary,
              size: 18, // ثابت عشان ميصغرش زيادة
            ),
          ),
        ),

        SizedBox(width: 6.w),

        Text(
          '$avgRate ($ratingQuantity)',
          style: const TextStyle(
            color: AppColors.hint,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
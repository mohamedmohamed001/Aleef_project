import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

class DetailsRatingRow extends StatelessWidget {
  final double avgRate;
  final int ratingQuantity;

  const DetailsRatingRow({
    super.key,
    required this.avgRate,
    required this.ratingQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ... List.generate(
          5,
              (index) => Icon(
            Icons.star,
            color: index < avgRate.round()
                ? const Color(0xFF5DB1A3)
                : Colors.grey.shade300,
            size: 14,
          ),
        ),

        SizedBox(width: 6.w),

        Text(
          '$avgRate ($ratingQuantity)',
          style: const TextStyle(color: AppColors.hint, fontSize: 13),
        ),
      ],
    );
  }
}

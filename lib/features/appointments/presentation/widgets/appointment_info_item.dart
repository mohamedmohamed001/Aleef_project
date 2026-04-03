import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AppointmentInfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String mainText;
  final String subText;

  const AppointmentInfoItem({
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
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(38, 125, 119, 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 22,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body14Regular.copyWith(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                mainText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.title16SemiBold.copyWith(
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subText,
                style: AppTextStyles.body14Regular.copyWith(
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
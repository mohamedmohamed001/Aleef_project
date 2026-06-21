import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/pet_model.dart';

class PetInfoSection extends StatelessWidget {
  final PetModel currentPet;

  const PetInfoSection({
    super.key,
    required this.currentPet,
  });

  bool _isEmptyValue(dynamic value) {
    if (value == null) return true;

    final text = value.toString().trim().toLowerCase();

    return text.isEmpty ||
        text == 'null' ||
        text == 'n/a' ||
        text == 'na' ||
        text == 'none';
  }

  String _formatAge(dynamic value) {
    if (_isEmptyValue(value)) return 'N/A';

    final text = value.toString().trim();

    if (text == '0') return 'N/A';

    if (text.toLowerCase().contains('year')) {
      return text;
    }

    return '$text years';
  }

  String _formatWeight(dynamic value) {
    if (_isEmptyValue(value)) return 'N/A';

    final text = value.toString().trim();

    if (text == '0') return 'N/A';

    if (text.toLowerCase().contains('kg')) {
      return text;
    }

    return '$text kg';
  }

  String _formatNormalText(dynamic value) {
    if (_isEmptyValue(value)) return 'N/A';

    final text = value.toString().trim();

    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Pet Information",
          style: AppTextStyles.title16SemiBold,
        ),

        SizedBox(height: 15.h),

        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
              color: AppColors.border.withOpacity(0.3),
            ),
          ),
          child: Column(
            children: [
              _buildInfoRow(
                "Age",
                _formatAge(currentPet.age),
              ),

              const Divider(
                height: 20,
                color: AppColors.border,
              ),

              _buildInfoRow(
                "Weight",
                _formatWeight(currentPet.weight),
              ),

              const Divider(
                height: 20,
                color: AppColors.border,
              ),

              _buildInfoRow(
                "Gender",
                _formatNormalText(currentPet.gender),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.body14Regular,
        ),

        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.label14Medium,
          ),
        ),
      ],
    );
  }
}
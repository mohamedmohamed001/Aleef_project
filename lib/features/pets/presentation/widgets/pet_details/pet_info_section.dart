import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/pet_model.dart';

class PetInfoSection extends StatelessWidget {
  final PetModel currentPet;
  const PetInfoSection({super.key, required this.currentPet});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Pet Information", style: AppTextStyles.title16SemiBold),
        SizedBox(height: 15.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: AppColors.border.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              _buildInfoRow("Age","${ currentPet.age}years"),
              const Divider(height: 20, color: AppColors.border),
              _buildInfoRow("weight","${currentPet.weight} kg"),
              const Divider(height: 20, color: AppColors.border),
              _buildInfoRow("Gender", currentPet.gender),
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
        Text(label, style: AppTextStyles.body14Regular),
        Text(value, style: AppTextStyles.label14Medium),
      ],
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/pet_model.dart';

class PetHeaderCard extends StatelessWidget {
  final PetModel currentPet;
  const PetHeaderCard({super.key, required this.currentPet});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 55.r,
            backgroundColor: AppColors.inputFill,
            child: ClipOval(child: _buildPetImage(currentPet.profilePic)),
          ),
          SizedBox(height: 12.h),
          Text(currentPet.name, style: AppTextStyles.heading24Bold),
          Text(currentPet.type, style: AppTextStyles.body14Regular),
          SizedBox(height: 20.h),
          
        ],
      ),
    );
  }

  Widget _buildPetImage(String imagePath) {
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: 110.r,
        height: 110.r,
        fit: BoxFit.cover,
      );
    } else if (imagePath.startsWith('assets')) {
      return Image.asset(
        imagePath,
        width: 110.r,
        height: 110.r,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(imagePath),
        width: 110.r,
        height: 110.r,
        fit: BoxFit.cover,
      );
    }
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.body14Regular),
        SizedBox(height: 4.h),
        Text(
          value,
          style: AppTextStyles.title16SemiBold.copyWith(
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

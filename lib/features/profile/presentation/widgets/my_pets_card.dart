import 'dart:io';

import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/pets/data/models/pet_model.dart';
import 'package:aleef/features/pets/presentation/pages/pet_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_assets.dart';

class MyPetsCard extends StatelessWidget {
  final PetModel pet;
  const MyPetsCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PetProfileScreen(pet:pet)),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12.r,
              offset: Offset(0, 6.h),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 🐶 Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: 
              _buildPetImage(pet.profilePic),
            ),

            SizedBox(height: 10.h),

            /// 🐾 Name
            Text(
              pet.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.black16Bold.copyWith(fontSize: 14),
            ),

            SizedBox(height: 4.h),

            /// 🐾 Info
            Text(
              "${pet.type}.${pet.age}years",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.hint14Regular.copyWith(
                color: Colors.grey.shade600,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
  // ضيفي دي تحت خالص في الكلاس
Widget _buildPetImage(String? path) {
  if (path == null || path.isEmpty) {
    return Container(
      height: 60.r, width: 60.r,
      color: AppColors.inputFill,
      child: Icon(Icons.pets, color: AppColors.hint),
    );
  }
  if (path.startsWith('http')) {
    return Image.network(path, height: 60.r, width: 60.r, fit: BoxFit.cover);
  } else if (path.startsWith('assets')) {
    return Image.asset(path, height: 60.r, width: 60.r, fit: BoxFit.cover);
  } else {
    return Image.file(File(path), height: 60.r, width: 60.r, fit: BoxFit.cover);
  }
}
}

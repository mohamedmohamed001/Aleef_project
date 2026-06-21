import 'dart:io';

import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/pets/data/models/pet_model.dart';
import 'package:aleef/features/pets/presentation/pages/pet_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_text_styles.dart';

class MyPetsCard extends StatelessWidget {
  final PetModel pet;

  const MyPetsCard({
    super.key,
    required this.pet,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(26.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(26.r),
        onTap: () {
          debugPrint("========== MY PETS CARD TAP ==========");
          debugPrint("PET ID: ${pet.id}");
          debugPrint("PET NAME: ${pet.name}");
          debugPrint("PET TYPE: ${pet.type}");
          debugPrint("======================================");

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PetProfileScreen(pet: pet),
            ),
          );
        },
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26.r),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.06),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.045),
                blurRadius: 18.r,
                offset: Offset(0, 8.h),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(11.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(21.r),
                          child: _buildPetImage(pet.profilePic),
                        ),
                      ),

                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.92),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            pet.gender.isEmpty ? "Pet" : pet.gender,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10.h),

                Text(
                  pet.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.black16Bold.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                SizedBox(height: 5.h),

                Row(
                  children: [
                    Icon(
                      Icons.pets_rounded,
                      size: 13.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: Text(
                        _petSubtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.hint14Regular.copyWith(
                          color: Colors.grey.shade600,
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String get _petSubtitle {
    final type = pet.type.isEmpty ? "Pet" : pet.type;
    final age = pet.age.isEmpty ? "0" : pet.age;

    return "$type • $age years";
  }

  Widget _buildPetImage(String? path) {
    final placeholder = Container(
      color: AppColors.primary.withOpacity(0.08),
      child: Center(
        child: Icon(
          Icons.pets_rounded,
          color: AppColors.primary.withOpacity(0.75),
          size: 38.sp,
        ),
      ),
    );

    if (path == null || path.isEmpty) {
      return placeholder;
    }

    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => placeholder,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return Container(
            color: Colors.grey.shade100,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
          );
        },
      );
    }

    if (path.startsWith('assets')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => placeholder,
      );
    }

    return Image.file(
      File(path),
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => placeholder,
    );
  }
}
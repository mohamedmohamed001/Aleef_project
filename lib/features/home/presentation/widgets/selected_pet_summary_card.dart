import 'dart:io';

import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/pets/data/models/pet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedPetSummaryCard extends StatelessWidget {
  final PetModel? pet;
  final VoidCallback onTap;
  final VoidCallback onAddPetTap;

  const SelectedPetSummaryCard({
    super.key,
    required this.pet,
    required this.onTap,
    required this.onAddPetTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasPet = pet != null;

    return InkWell(
      onTap: hasPet ? onTap : onAddPetTap,
      borderRadius: BorderRadius.circular(28.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.13),
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.10),
            width: 1.w,
          ),
        ),
        child: Row(
          children: [
            _PetImage(
              imagePath: pet?.profilePic,
              hasPet: hasPet,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: hasPet ? _PetInfo(pet: pet!) : const _EmptyPetInfo(),
            ),
            SizedBox(width: 10.w),
            Icon(
              hasPet ? Icons.arrow_forward_ios_rounded : Icons.add_rounded,
              color: Colors.white.withOpacity(0.92),
              size: hasPet ? 22.sp : 26.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class _PetImage extends StatelessWidget {
  final String? imagePath;
  final bool hasPet;

  const _PetImage({
    required this.imagePath,
    required this.hasPet,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasPet || imagePath == null || imagePath!.isEmpty) {
      return Container(
        width: 78.r,
        height: 78.r,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.16),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Icon(
          Icons.pets_rounded,
          color: Colors.white,
          size: 34.sp,
        ),
      );
    }

    final path = imagePath!;

    Widget image;

    if (path.startsWith('http')) {
      image = Image.network(
        path,
        width: 78.r,
        height: 78.r,
        fit: BoxFit.cover,
      );
    } else if (path.startsWith('assets')) {
      image = Image.asset(
        path,
        width: 78.r,
        height: 78.r,
        fit: BoxFit.cover,
      );
    } else {
      image = Image.file(
        File(path),
        width: 78.r,
        height: 78.r,
        fit: BoxFit.cover,
      );
    }

    return Container(
      width: 78.r,
      height: 78.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.28),
          width: 1.2.w,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.r),
        child: image,
      ),
    );
  }
}

class _PetInfo extends StatelessWidget {
  final PetModel pet;

  const _PetInfo({
    required this.pet,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                pet.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 5.h,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF19D58B),
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getGenderIcon(pet.gender),
                    color: Colors.white,
                    size: 12.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    "Healthy",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Text(
          "${pet.type} • ${pet.age} years",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white.withOpacity(0.86),
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  IconData _getGenderIcon(String? gender) {
    final value = gender?.toLowerCase().trim();

    if (value == "male") {
      return Icons.male_rounded;
    }

    if (value == "female") {
      return Icons.female_rounded;
    }

    return Icons.favorite_rounded;
  }
}

class _EmptyPetInfo extends StatelessWidget {
  const _EmptyPetInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Add your first pet",
          style: TextStyle(
            color: Colors.white,
            fontSize: 21.sp,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          "Create a pet profile.",
          style: TextStyle(
            color: Colors.white.withOpacity(0.84),
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
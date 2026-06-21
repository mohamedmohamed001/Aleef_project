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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: hasPet ? onTap : onAddPetTap,
        borderRadius: BorderRadius.circular(26.r),
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.all(13.r),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.13),
            borderRadius: BorderRadius.circular(26.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.14),
              width: 1.w,
            ),
          ),
          child: hasPet
              ? _SelectedPetContent(pet: pet!)
              : const _EmptyPetContent(),
        ),
      ),
    );
  }
}

class _SelectedPetContent extends StatelessWidget {
  final PetModel pet;

  const _SelectedPetContent({
    required this.pet,
  });

  @override
  Widget build(BuildContext context) {
    final status = _PetStatus.fromPet(pet);

    return Row(
      children: [
        _PetImage(
          imagePath: pet.profilePic,
          petType: pet.type,
        ),

        SizedBox(width: 13.w),

        Expanded(
          child: Column(
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
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  _StatusBadge(status: status),
                ],
              ),

              SizedBox(height: 7.h),

              Text(
                _petSubtitle(pet),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.84),
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: 10.w),

        Container(
          width: 38.r,
          height: 38.r,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.16),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
            ),
          ),
          child: Icon(
            Icons.arrow_forward_rounded,
            color: Colors.white,
            size: 21.sp,
          ),
        ),
      ],
    );
  }

  String _petSubtitle(PetModel pet) {
    final type = pet.type.trim();
    final age = _formatAge(pet.age);

    if (type.isNotEmpty && age.isNotEmpty) {
      return "$type • $age";
    }

    if (type.isNotEmpty) return type;
    if (age.isNotEmpty) return age;

    return "Pet profile";
  }

  String _formatAge(String age) {
    final value = age.trim();

    if (value.isEmpty || value == "0") return "";

    final match = RegExp(r'\d+').firstMatch(value);
    final number = match == null ? null : int.tryParse(match.group(0)!);

    if (number == null) {
      if (value.toLowerCase().contains("old")) return value;
      return "$value old";
    }

    if (number == 1) return "1 year old";

    return "$number years old";
  }
}

class _EmptyPetContent extends StatelessWidget {
  const _EmptyPetContent();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 58.r,
          height: 58.r,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.16),
            borderRadius: BorderRadius.circular(21.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
            ),
          ),
          child: Icon(
            Icons.pets_rounded,
            color: Colors.white,
            size: 29.sp,
          ),
        ),

        SizedBox(width: 13.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add your first pet",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                  letterSpacing: -0.3,
                ),
              ),

              SizedBox(height: 7.h),

              Text(
                "Create a profile to track visits and care.",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.82),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: 10.w),

        Container(
          width: 38.r,
          height: 38.r,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.add_rounded,
            color: AppColors.primary,
            size: 24.sp,
          ),
        ),
      ],
    );
  }
}

class _PetImage extends StatelessWidget {
  final String imagePath;
  final String petType;

  const _PetImage({
    required this.imagePath,
    required this.petType,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath.trim().isNotEmpty;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 62.r,
          height: 62.r,
          padding: EdgeInsets.all(2.5.r),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.18),
              width: 1.w,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(19.r),
            child: hasImage
                ? _BuildPetImage(
              path: imagePath,
              petType: petType,
            )
                : _PetFallbackIcon(type: petType),
          ),
        ),

        Positioned(
          right: -2.w,
          bottom: -2.h,
          child: Container(
            width: 18.r,
            height: 18.r,
            decoration: BoxDecoration(
              color: const Color(0xFF23E58B),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2.5.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BuildPetImage extends StatelessWidget {
  final String path;
  final String petType;

  const _BuildPetImage({
    required this.path,
    required this.petType,
  });

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _PetFallbackIcon(type: petType),
      );
    }

    if (path.startsWith('assets')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
      );
    }

    return Image.file(
      File(path),
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => _PetFallbackIcon(type: petType),
    );
  }
}

class _PetFallbackIcon extends StatelessWidget {
  final String type;

  const _PetFallbackIcon({
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final lowerType = type.toLowerCase();

    final icon = lowerType.contains('cat')
        ? Icons.cruelty_free_rounded
        : Icons.pets_rounded;

    return Container(
      color: Colors.white.withOpacity(0.12),
      child: Icon(
        icon,
        color: Colors.white,
        size: 29.sp,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final _PetStatus status;

  const _StatusBadge({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 5.h,
      ),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(
          color: status.color.withOpacity(0.16),
          width: 1.w,
        ),
      ),
      child: Text(
        status.label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontSize: 9.5.sp,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

class _PetStatus {
  final String label;
  final Color color;

  const _PetStatus({
    required this.label,
    required this.color,
  });

  factory _PetStatus.fromPet(PetModel pet) {
    if (pet.overdueVaccinations.isNotEmpty) {
      return const _PetStatus(
        label: "Needs care",
        color: Color(0xFFFFC857),
      );
    }

    if (pet.upcomingVaccinations.isNotEmpty) {
      return const _PetStatus(
        label: "Upcoming",
        color: Color(0xFF9EE7FF),
      );
    }

    return const _PetStatus(
      label: "Healthy",
      color: Color(0xFF23E58B),
    );
  }
}
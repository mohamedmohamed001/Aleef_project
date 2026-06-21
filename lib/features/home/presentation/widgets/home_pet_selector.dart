import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/pets/data/models/pet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePetSelector extends StatelessWidget {
  final List<PetModel> pets;
  final int selectedIndex;
  final void Function(int index) onPetSelected;

  const HomePetSelector({
    super.key,
    required this.pets,
    required this.selectedIndex,
    required this.onPetSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (pets.length <= 1) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: Colors.black.withOpacity(0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Container(
                  width: 28.r,
                  height: 28.r,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.pets_rounded,
                    color: AppColors.primary,
                    size: 16.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    "Choose pet",
                    style: TextStyle(
                      color: const Color(0xFF101828),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  "${pets.length} pets",
                  style: TextStyle(
                    color: const Color(0xFF667085),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          SizedBox(
            height: 46.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: pets.length,
              separatorBuilder: (_, _) => SizedBox(width: 9.w),
              itemBuilder: (context, index) {
                final pet = pets[index];
                final isSelected = index == selectedIndex;

                return _PetSelectorChip(
                  pet: pet,
                  isSelected: isSelected,
                  onTap: () => onPetSelected(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PetSelectorChip extends StatelessWidget {
  final PetModel pet;
  final bool isSelected;
  final VoidCallback onTap;

  const _PetSelectorChip({
    required this.pet,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = pet.profilePic.trim().isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : const Color(0xFFF8FAFA),
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : AppColors.primary.withOpacity(0.08),
          width: 1.w,
        ),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.20),
            blurRadius: 14.r,
            offset: Offset(0, 7.h),
          ),
        ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(100.r),
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              start: 6.w,
              end: 13.w,
              top: 5.h,
              bottom: 5.h,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 34.r,
                  height: 34.r,
                  padding: EdgeInsets.all(1.4.r),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.22)
                        : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: hasImage
                        ? Image.network(
                      pet.profilePic,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _FallbackPetIcon(
                        isSelected: isSelected,
                      ),
                    )
                        : _FallbackPetIcon(isSelected: isSelected),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  pet.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF101828),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (isSelected) ...[
                  SizedBox(width: 7.w),
                  Container(
                    width: 18.r,
                    height: 18.r,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 13.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FallbackPetIcon extends StatelessWidget {
  final bool isSelected;

  const _FallbackPetIcon({
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isSelected
          ? Colors.white.withOpacity(0.10)
          : AppColors.primary.withOpacity(0.08),
      child: Icon(
        Icons.pets_rounded,
        color: isSelected ? Colors.white : AppColors.primary,
        size: 18.sp,
      ),
    );
  }
}
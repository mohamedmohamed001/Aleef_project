import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'book_empty_message.dart';

class BookPetSelector extends StatelessWidget {
  final List<dynamic> pets;
  final String? selectedPetId;
  final ValueChanged<String> onPetSelected;

  const BookPetSelector({
    super.key,
    required this.pets,
    required this.selectedPetId,
    required this.onPetSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (pets.isEmpty) {
      return const BookEmptyMessage(message: "No pets found");
    }

    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: pets.map((pet) {
        final value = pet.id.toString();
        final isSelected = selectedPetId == value;

        return GestureDetector(
          onTap: () => onPetSelected(value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 11.h,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey.shade200,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "🐶",
                  style: TextStyle(fontSize: 16.sp),
                ),
                SizedBox(width: 6.w),
                Text(
                  pet.name ?? "",
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

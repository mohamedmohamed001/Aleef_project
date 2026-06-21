import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class CustomPetTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  const CustomPetTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.label14Medium.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            validator: validator,
            readOnly: readOnly,
            onTap: onTap,
            style: AppTextStyles.label14Medium.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              hintStyle: AppTextStyles.label14Medium.copyWith(
                color: AppColors.hint,
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFA),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 18.w,
                vertical: 18.h,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.r),
                borderSide: BorderSide(
                  color: AppColors.border.withOpacity(.8),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.r),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.8,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.r),
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.r),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 1.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomPetChoiceChips extends StatelessWidget {
  final String label;
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String> onSelected;
  final IconData Function(String item)? iconBuilder;

  const CustomPetChoiceChips({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.items,
    required this.onSelected,
    this.iconBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.label14Medium.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: items.map((item) {
              final bool isSelected = selectedValue == item;

              return Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    end: item == items.last ? 0 : 10.w,
                  ),
                  child: GestureDetector(
                    onTap: () => onSelected(item),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : const Color(0xFFF8FAFA),
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border.withOpacity(.8),
                        ),
                        boxShadow: isSelected
                            ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(.18),
                            blurRadius: 14.r,
                            offset: Offset(0, 7.h),
                          ),
                        ]
                            : [],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            iconBuilder?.call(item) ??
                                Icons.check_circle_outline_rounded,
                            color: isSelected
                                ? Colors.white
                                : AppColors.primary,
                            size: 19.sp,
                          ),
                          SizedBox(width: 7.w),
                          Text(
                            item[0].toUpperCase() + item.substring(1),
                            style: AppTextStyles.label14Medium.copyWith(
                              color:
                              isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class CustomPetDropdown extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;

  const CustomPetDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.label14Medium.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            height: 58.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFA),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: AppColors.border.withOpacity(.8),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                borderRadius: BorderRadius.circular(18.r),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.primary,
                  size: 24.sp,
                ),
                hint: Text(
                  hint,
                  style: AppTextStyles.label14Medium.copyWith(
                    color: AppColors.hint,
                  ),
                ),
                items: items
                    .map(
                      (item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item[0].toUpperCase() + item.substring(1),
                      style: AppTextStyles.label14Medium,
                    ),
                  ),
                )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
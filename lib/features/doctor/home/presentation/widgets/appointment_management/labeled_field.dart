import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LabeledField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;

  const LabeledField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF001533),
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF001533),
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon == null
                ? null
                : Icon(
              prefixIcon,
              color: AppColors.primary,
              size: 21.sp,
            ),
            hintStyle: TextStyle(
              color: const Color(0xFF8A94A6),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: Color(0xFFE1E5EA),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 1.4.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
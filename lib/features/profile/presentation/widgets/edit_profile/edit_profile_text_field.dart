import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;

  const EditProfileTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: AppColors.primary,
      style: TextStyle(
        color: const Color(0xFF111827),
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),

        filled: true,
        fillColor: const Color(0xFFF7FAFA),

        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(
            color: AppColors.primary.withOpacity(0.08),
            width: 1.w,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(
            color: AppColors.primary.withOpacity(0.55),
            width: 1.3.w,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(
            color: AppColors.error.withOpacity(0.7),
            width: 1.2.w,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(
            color: AppColors.error,
            width: 1.3.w,
          ),
        ),
      ),
    );
  }
}
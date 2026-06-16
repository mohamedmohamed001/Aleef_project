import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TicketTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final int? maxLength;
  final FocusNode? focusNode;

  const TicketTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.keyboardType,
    this.inputFormatters,
    this.obscureText = false,
    this.maxLength,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      maxLength: maxLength,
      cursorColor: AppColors.primary,
      style: TextStyle(
        color: const Color(0xFF152E2C),
        fontSize: 13.5.sp,
        fontWeight: FontWeight.w800,
      ),
      decoration: InputDecoration(
        counterText: "",
        hintText: label,
        hintStyle: TextStyle(
          color: const Color(0xFF9AA7A6),
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20.sp),
        filled: true,
        fillColor: const Color(0xFFF6FAF9),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17.r),
          borderSide: BorderSide(color: const Color(0xFFE3ECEB), width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17.r),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5.w),
        ),
      ),
    );
  }
}
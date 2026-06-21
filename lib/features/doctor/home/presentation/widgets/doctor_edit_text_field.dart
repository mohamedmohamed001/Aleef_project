import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aleef/core/theme/app_colors.dart';

class DoctorEditTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool enabled;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  const DoctorEditTextField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.enabled = true,
    this.validator,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = !enabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: isDisabled ? Colors.black45 : Colors.black87,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          style: TextStyle(
            fontSize: 14.sp,
            color: isDisabled ? Colors.black45 : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDisabled
                ? const Color(0xFFEFF2F2)
                : const Color(0xFFF8F9FA),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 12.h,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Color(0xFFE1E8E8),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Color(0xFFE9ECEF),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Color(0xFFE9ECEF),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Colors.redAccent,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
          ),
          validator: validator ??
                  (value) {
                if (!label.contains('Optional') &&
                    (value == null || value.trim().isEmpty)) {
                  return 'This field is required';
                }
                return null;
              },
        ),
      ],
    );
  }
}
import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookReasonFields extends StatelessWidget {
  final TextEditingController reasonController;
  final TextEditingController notesController;

  const BookReasonFields({
    super.key,
    required this.reasonController,
    required this.notesController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: reasonController,
          decoration: _inputDecoration(
            hintText: "e.g. Annual checkup, vaccination...",
          ),
        ),
        SizedBox(height: 12.h),
        TextFormField(
          controller: notesController,
          maxLines: 4,
          decoration: _inputDecoration(
            hintText: "Additional notes optional...",
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.r),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.r),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.r),
        borderSide: BorderSide(color: AppColors.primary, width: 1.4),
      ),
    );
  }
}

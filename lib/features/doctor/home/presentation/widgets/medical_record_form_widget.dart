import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicalRecordFormWidget extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController conditionController;
  final TextEditingController descController;

  const MedicalRecordFormWidget({
    super.key,
    required this.titleController,
    required this.conditionController,
    required this.descController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Medical Documentation",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          _buildField(
            titleController,
            'Record Title',
            'e.g., Annual Checkup 2026',
          ),
          _buildField(
            conditionController,
            'Condition',
            'e.g., Healthy, Skin Allergy, etc.',
          ),
          _buildField(
            descController,
            'Description',
            'Detailed notes about the examination and findings...',
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    String hint, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Text(label, style: TextStyle(fontSize: 13.sp)),
        ),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'edit_profile_text_field.dart';

class EditProfileFormSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;

  const EditProfileFormSection({
    super.key,
    required this.nameController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Basic Information',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 22.h),

        const Text(
          'Full Name',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10.h),

        EditProfileTextField(
          controller: nameController,
          hintText: 'Enter your full name',
        ),

        SizedBox(height: 20.h),

        const Text(
          'Phone Number',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10.h),

        EditProfileTextField(
          controller: phoneController,
          hintText: 'Enter your phone number',
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../auth_field_label.dart';
import '../custom_text_form.dart';

class PersonalInformation extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  final String? Function(String?)? fullNameValidator;
  final String? Function(String?)? emailValidator;
  final String? Function(String?)? phoneValidator;

  const PersonalInformation({
    super.key,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    this.fullNameValidator,
    this.emailValidator,
    this.phoneValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuthFieldLabel(
          title: "Full Name",
          icon: Icons.person_outline,
        ),
        SizedBox(height: 8.h),
        CustomTextFormField(
          controller: fullNameController,
          hintText: "Enter your full name",
          iconPrefix: Icons.person_outline,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          validator: fullNameValidator,
        ),

        SizedBox(height: 16.h),

        const AuthFieldLabel(
          title: "Email Address",
          icon: Icons.mail_outline,
        ),
        SizedBox(height: 8.h),
        CustomTextFormField(
          controller: emailController,
          hintText: "doctor@example.com",
          iconPrefix: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: emailValidator,
        ),

        SizedBox(height: 16.h),

        const AuthFieldLabel(
          title: "Phone Number",
          icon: Icons.phone_outlined,
        ),
        SizedBox(height: 8.h),
        CustomTextFormField(
          controller: phoneController,
          hintText: "+20 100 123 4567",
          iconPrefix: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          validator: phoneValidator,
        ),
      ],
    );
  }
}
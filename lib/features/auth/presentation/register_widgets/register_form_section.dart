import 'package:flutter/material.dart';

import '../widgets/auth_primary_button.dart';
import '../widgets/custom_text_form.dart';
import 'auth_field_label.dart';

class RegisterFormSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isLoading;
  final VoidCallback onRegisterPressed;

  const RegisterFormSection({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isLoading,
    required this.onRegisterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuthFieldLabel(text: "Full Name"),
        const SizedBox(height: 8),
        CustomTextFormField(
          controller: nameController,
          hintText: "Enter your name",
          iconPrefix: Icons.person_outline,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
        ),

        const SizedBox(height: 18),

        const AuthFieldLabel(text: "Email Address"),
        const SizedBox(height: 8),
        CustomTextFormField(
          controller: emailController,
          hintText: "Enter your email",
          iconPrefix: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 18),

        const AuthFieldLabel(text: "Phone Number"),
        const SizedBox(height: 8),
        CustomTextFormField(
          controller: phoneController,
          hintText: "Enter your phone",
          iconPrefix: Icons.phone_android_outlined,
          keyboardType: TextInputType.phone,
        ),

        const SizedBox(height: 18),

        const AuthFieldLabel(text: "Password"),
        const SizedBox(height: 8),
        CustomTextFormField(
          controller: passwordController,
          hintText: "Enter your password",
          iconPrefix: Icons.lock_outline,
          isPassword: true,
          keyboardType: TextInputType.visiblePassword,
        ),

        const SizedBox(height: 18),

        const AuthFieldLabel(text: "Confirm Password"),
        const SizedBox(height: 8),
        CustomTextFormField(
          controller: confirmPasswordController,
          hintText: "Confirm your password",
          iconPrefix: Icons.lock_outline,

          isPassword: true,
          keyboardType: TextInputType.visiblePassword,
        ),

        const SizedBox(height: 24),

        AuthPrimaryButton(
          text: "Create Account",
          isLoading: isLoading,
          onPressed: onRegisterPressed,
        ),
      ],
    );
  }
}

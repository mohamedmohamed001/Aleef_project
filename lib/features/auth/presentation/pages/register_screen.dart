import 'package:aleef/core/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_routes.dart';
import '../../data/services/auth_api_service.dart';
import '../providers/verify_provider.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_field_label.dart';
import '../widgets/auth_footer_text.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_snackbar.dart';
import '../widgets/auth_trust_note.dart';
import '../widgets/custom_text_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (isLoading) return;

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    setState(() {
      isLoading = true;
    });

    final result = await AuthApiService().register(
      email,
      password,
      name,
      phone,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (result.success) {
      context.read<VerifyProvider>().setVerificationData(
        email: email,
        doctor: false,
      );

      showAuthSnackBar(
        context,
        message: result.message,
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.verificationOtp,
            (route) => false,
      );
    } else {
      showAuthSnackBar(
        context,
        message: result.message,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: "Create Account",
      subtitle: "Start your pet care journey with ALEEF.",
      backgroundHeight: 300,
      backgroundIcon: Icons.pets_rounded,
      accentIcon: Icons.favorite_rounded,
      spacingAfterHero: 22,
      footer: AuthFooterText(
        normalText: 'Already have an account? ',
        actionText: 'Login',
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.login);
        },
      ),
      child: Form(
        key: _formKey,
        child: AuthCard(
          title: "Register",
          subtitle: "Create your account in a few simple steps.",
          children: [
            SizedBox(height: 22.h),
            const AuthFieldLabel(
              title: "Full Name",
              icon: Icons.person_outline,
            ),
            SizedBox(height: 8.h),
            CustomTextFormField(
              controller: nameController,
              hintText: "Enter your name",
              iconPrefix: Icons.person_outline,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              validator: Validators.validateName,
            ),
            SizedBox(height: 14.h),
            const AuthFieldLabel(
              title: "Email Address",
              icon: Icons.email_outlined,
            ),
            SizedBox(height: 8.h),
            CustomTextFormField(
              controller: emailController,
              hintText: "Enter your email",
              iconPrefix: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: Validators.validateEmail,
            ),
            SizedBox(height: 14.h),
            const AuthFieldLabel(
              title: "Phone Number",
              icon: Icons.phone_android_outlined,
            ),
            SizedBox(height: 8.h),
            CustomTextFormField(
              controller: phoneController,
              hintText: "Enter your phone",
              iconPrefix: Icons.phone_android_outlined,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              validator: Validators.validatePhone,
            ),
            SizedBox(height: 14.h),
            const AuthFieldLabel(
              title: "Password",
              icon: Icons.lock_outline,
            ),
            SizedBox(height: 8.h),
            CustomTextFormField(
              isPassword: true,
              controller: passwordController,
              hintText: "Enter your password",
              iconPrefix: Icons.lock_outline,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
              // validator: Validators.validatePassword,
            ),
            SizedBox(height: 14.h),
            const AuthFieldLabel(
              title: "Confirm Password",
              icon: Icons.lock_outline,
            ),
            SizedBox(height: 8.h),
            CustomTextFormField(
              isPassword: true,
              controller: confirmPasswordController,
              hintText: "Confirm your password",
              iconPrefix: Icons.lock_outline,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              // validator: (value) => Validators.validateConfirmPassword(
              //     value, passwordController.text),
            ),
            SizedBox(height: 22.h),
            AuthPrimaryButton(
              text: "Create Account",
              isLoading: isLoading,
              onPressed: _handleRegister,
            ),
            SizedBox(height: 16.h),
            const AuthTrustNote(),
          ],
        ),
      ),
    );
  }
}

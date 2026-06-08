import 'package:aleef/core/routing/app_routes.dart';
import 'package:aleef/core/services/fcm_service.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../providers/bottom_nav_provider.dart';
import '../../data/services/doctor_auth_api_service.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_field_label.dart';
import '../widgets/auth_footer_text.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_snackbar.dart';
import '../widgets/custom_text_form.dart';

class DoctorLoginScreen extends StatefulWidget {
  const DoctorLoginScreen({super.key});

  @override
  State<DoctorLoginScreen> createState() => _DoctorLoginScreenState();
}

class _DoctorLoginScreenState extends State<DoctorLoginScreen> {
  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  final DoctorAuthApiService _authApiService =
  DoctorAuthApiService();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (isLoading) return;

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final result = await _authApiService.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    debugPrint("================================");
    debugPrint("DOCTOR LOGIN RESPONSE:");
    debugPrint(result.toString());
    debugPrint("================================");

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (result != null) {
      final fcmToken =
      await FcmService.initAndGetToken();

      debugPrint(
        "✅ Doctor Token after login: $fcmToken",
      );

      if (!mounted) return;

      context.read<BottomNavProvider>().changeTab(0);

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.doctorMainLayout,
            (route) => false,
      );
    } else {
      showAuthSnackBar(
        context,
        message: "Login failed",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: "Welcome Back Doctor",
      subtitle:
      "Sign in to manage appointments and patients.",
      backgroundHeight: 315,
      backgroundIcon:
      Icons.medical_services_rounded,
      accentIcon:
      Icons.verified_rounded,
      spacingAfterHero: 24,
      footer: AuthFooterText(
        normalText: "Don’t have an account? ",
        actionText: "Create Account",
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.doctorRegister,
          );
        },
      ),
      child: Form(
        key: _formKey,
        child: AuthCard(
          title: "Doctor Login",
          subtitle:
          "Access your professional dashboard.",
          children: [
            SizedBox(height: 24.h),

            const AuthFieldLabel(
              title: "Email Address",
              icon: Icons.email_outlined,
            ),

            SizedBox(height: 8.h),

            CustomTextFormField(
              validator: Validators.validateEmail,
              controller: emailController,
              hintText: "Enter your email",
              iconPrefix: Icons.email_outlined,
              keyboardType:
              TextInputType.emailAddress,
              textInputAction:
              TextInputAction.next,
            ),

            SizedBox(height: 16.h),

            const AuthFieldLabel(
              title: "Password",
              icon: Icons.lock_outline,
            ),

            SizedBox(height: 8.h),

            CustomTextFormField(
              validator:
              Validators.validatePassword,
              isPassword: true,
              controller: passwordController,
              hintText: "Enter your password",
              iconPrefix:
              Icons.lock_outline,
              keyboardType:
              TextInputType.visiblePassword,
              textInputAction:
              TextInputAction.done,
            ),

            SizedBox(height: 4.h),

            Align(
              alignment:
              AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor:
                  AppColors.primary,
                  padding:
                  EdgeInsets.symmetric(
                    horizontal: 4.w,
                  ),
                  minimumSize:
                  Size(0, 38.h),
                  tapTargetSize:
                  MaterialTapTargetSize
                      .shrinkWrap,
                ),
                child: Text(
                  "Forget Password?",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
              ),
            ),

            SizedBox(height: 10.h),

            AuthPrimaryButton(
              text: "Login",
              isLoading: isLoading,
              onPressed: _handleLogin,
            ),

            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
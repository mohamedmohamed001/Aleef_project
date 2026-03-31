import 'package:aleef/core/routing/app_routes.dart';
import 'package:flutter/material.dart';

import '../../data/services/auth_api_service.dart';
import '../widgets/auth_footer_text.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/custom_text_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthApiService _authApiService = AuthApiService();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    final success = await _authApiService.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (success == true) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.mainLayout,
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login failed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outlineColor = theme.colorScheme.outline;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthHeader(
                  title: "Welcome Back!",
                  subtitle: "Sign in to your ALEEF account",
                ),
                const SizedBox(height: 16),

                Text(
                  "Email Address",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: outlineColor,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: emailController,
                  hintText: "Enter your email",
                  iconPrefix: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),

                Text(
                  "Password",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: outlineColor,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: passwordController,
                  hintText: "Enter your password",
                  iconPrefix: Icons.lock_outline,
                  iconSuffix: Icons.remove_red_eye_outlined,
                  obSecureText: true,
                  keyboardType: TextInputType.visiblePassword,
                ),

                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forget Password?",
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                AuthPrimaryButton(
                  text: "Login",
                  isLoading: isLoading,
                  onPressed: _handleLogin,
                ),

                const SizedBox(height: 12),

                AuthFooterText(
                  normalText: "Don’t have an account? ",
                  actionText: "Signup",
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.register);
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
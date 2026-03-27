import 'package:aleef/core/routing/app_routes.dart';
import 'package:aleef/core/utils/app_assets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/services/auth_api_service.dart';
import '../widgets/custom_text_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(AppAssets.backGroundLogin),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Expanded(
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      "Sign in to your ALEEF account",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Email Address",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),

                    // SizedBox(height: 8),
                    CustomTextFormField(
                      controller: emailController,
                      hintText: "Enter your email",
                      iconPrefix: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    Text(
                      "password",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),

                    // SizedBox(height: 20),
                    CustomTextFormField(
                      controller: passwordController,
                      hintText: "Enter your password",
                      iconPrefix: Icons.lock_outline,
                      iconSuffix: Icons.remove_red_eye_outlined,
                      obSecureText: true,
                      keyboardType: TextInputType.visiblePassword ,

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
                    SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              setState(() {
                                isLoading = true;
                              });
                              final success = await AuthApiService().login(
                                emailController.text,
                                passwordController.text,
                              );
                              setState(() {
                                isLoading = false;
                              });

                              if (success == true) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  AppRoutes.register,
                                  (route) => false,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Login failed"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                      child: isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text("Login"),
                    ),
                    SizedBox(height: 5),
                    Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(text: "Don’t have an account? "),
                            TextSpan(
                              text: "Signup",
                              style: theme.textTheme.labelMedium!.copyWith(
                                color: theme.colorScheme.primary,
                                decoration: TextDecoration.underline,
                                decorationColor: theme.colorScheme.primary,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.register,
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

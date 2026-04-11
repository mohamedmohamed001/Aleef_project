import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/routing/app_routes.dart';
import '../../data/services/auth_api_service.dart';
import '../providers/verify_provider.dart';
import '../widgets/auth_footer_text.dart';
import '../widgets/custom_text_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;

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
  @override
  Widget build(BuildContext context) {


    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 34,
                    width: 34,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadiusGeometry.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Image.asset("assets/images/logo.png"),
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    "ALEEF",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              Text("Create Account", style: AppTextStyles.titleLarge),
              Text("Join thousands of happy pet owners"),
              SizedBox(height: 1),
              CustomTextFormField(
                controller: nameController,
                hintText: "Enter your name",
                iconPrefix: Icons.person_outline,
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 1),
              CustomTextFormField(
                controller: emailController,
                hintText: "Enter your email",
                iconPrefix: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 1),
              CustomTextFormField(
                controller: phoneController,
                hintText: "Enter your phone",
                iconPrefix: Icons.phone_android_outlined,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 1),
              CustomTextFormField(
                isPassword: true,
                controller: passwordController,
                hintText: "Enter your password",
                iconPrefix: Icons.lock_outline,

                keyboardType: TextInputType.visiblePassword,
              ),
              SizedBox(height: 1),
              CustomTextFormField(
                keyboardType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please confirm your password";
                  }
                  if (value != passwordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
                isPassword: true,
                controller: confirmPasswordController,
                hintText: "Confirm your password",
                iconPrefix: Icons.lock_outline,
              ),
              SizedBox(height: 1),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });
                        final success = await AuthApiService().register(
                          emailController.text,
                          passwordController.text,
                          nameController.text,
                          phoneController.text,
                        );
                        final email = emailController.text;
                        Provider.of<VerifyProvider>(
                          context,
                          listen: false,
                        ).setEmail(email);
                        setState(() {
                          isLoading = false;
                        });

                        if (success == true) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.verificationOtp,
                            (route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Registration failed"),
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
                    : Text("Create Account"),
              ),
              SizedBox(height: 1),
              Align(
                alignment: Alignment.center,
                child: AuthFooterText(
                  normalText: 'Already have an account? ',
                  actionText: 'Login',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.login);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

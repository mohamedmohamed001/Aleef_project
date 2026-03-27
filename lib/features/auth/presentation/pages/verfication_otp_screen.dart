import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/services/auth_api_service.dart';
import '../providers/verify_provider.dart';
import '../widgets/custom_text_form.dart';

class VerificationOtpScreen extends StatefulWidget {
  const VerificationOtpScreen({super.key});

  @override
  State<VerificationOtpScreen> createState() => _VerificationOtpScreenState();
}

class _VerificationOtpScreenState extends State<VerificationOtpScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final verificationController = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SafeArea(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    height: 34,
                    width: 34,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadiusGeometry.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        "A",
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
              Text("Verification", style: AppTextStyles.titleLarge),
              Text("Enter your verification code"),
              SizedBox(height: 10),
              CustomTextFormField(
                controller: verificationController,
                hintText: "Enter your verification code",
                iconPrefix: Icons.security_outlined,
              ),
              SizedBox(height: 1),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });
                        final success = await AuthApiService().verifyOtp(
                          verificationController.text,
                          Provider.of<VerifyProvider>(
                            context,
                            listen: false,
                          ).email!,
                        );
                        setState(() {
                          isLoading = false;
                        });

                        if (success == true) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.home,
                            (route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Verification failed"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                child: isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Text("verify"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

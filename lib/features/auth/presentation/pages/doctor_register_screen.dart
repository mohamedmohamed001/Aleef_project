import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/validators/validators.dart';
import '../providers/doctor_register_provider.dart';
import '../providers/verify_provider.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_snackbar.dart';
import '../widgets/doctor_register/identity_verification_section.dart';
import '../widgets/doctor_register/personal_information.dart';
import '../widgets/doctor_register/professional_information.dart';
import '../widgets/custom_text_form.dart';
import '../../../../core/theme/app_colors.dart';

class DoctorRegisterScreen extends StatefulWidget {
  const DoctorRegisterScreen({super.key});

  @override
  State<DoctorRegisterScreen> createState() => _DoctorRegisterScreenState();
}

class _DoctorRegisterScreenState extends State<DoctorRegisterScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  int currentStep = 0;

  File? selectedProfilePic;
  File? selectedNationalIdFront;
  File? selectedNationalIdBack;
  File? selectedIdentityVerificationImage;

  static const int totalSteps = 4;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    licenseController.dispose();
    cityController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _goBack() {
    FocusScope.of(context).unfocus();
    if (currentStep == 0) {
      Navigator.pop(context);
      return;
    }
    setState(() {
      currentStep--;
    });
  }

  Future<void> _handleContinue() async {
    FocusScope.of(context).unfocus();
    final provider = context.read<DoctorRegisterProvider>();

    // تحقق من كل الحقول
    if (!_formKey.currentState!.validate()) return;

    // التحقق من الصور في المرحلة الثالثة
    if (currentStep == 2) {
      if (selectedProfilePic == null ||
          selectedNationalIdFront == null ||
          selectedNationalIdBack == null ||
          selectedIdentityVerificationImage == null) {
        showAuthSnackBar(context, message: "Please upload all required documents");
        return;
      }
    }

    if (currentStep < totalSteps - 1) {
      setState(() => currentStep++);
      return;
    }

    // المرحلة الرابعة: إرسال البيانات للـ Provider
    final success = await provider.registerDoctor(
      name: fullNameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      licenseNumber: licenseController.text.trim(),
      city: cityController.text.trim(),
      address: addressController.text.trim(),
      specialization: "Veterinary",
      appointmentFee: 250,
      profilePic: selectedProfilePic!,
      NationalIdFront: selectedNationalIdFront!,
      NationalIdBack: selectedNationalIdBack!,
      IdentityVerificationImage: selectedIdentityVerificationImage!,
      password: passwordController.text.trim(),
    );

    if (success) {

      context.read<VerifyProvider>().setVerificationData(
        email: emailController.text.trim(),
        doctor: true,
      );

      showAuthSnackBar(
        context,
        message: "Verification code sent to your email",
        type: AuthSnackBarType.success,
      );

      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      if (!mounted) return;

      Navigator.pushNamed(
        context,
        AppRoutes.verificationOtp,
      );
    }
  }

  Widget _buildCurrentStepContent() {
    switch (currentStep) {
      case 0:
        return PersonalInformation(
          fullNameController: fullNameController,
          emailController: emailController,
          phoneController: phoneController,
          // validators للـ fields إلزامية
          fullNameValidator: Validators.validateName,
          emailValidator: Validators.validateEmail,
          phoneValidator: Validators.validatePhone,
        );
      case 1:
        return ProfessionalInformation(
          licenseController: licenseController,
          cityController: cityController,
          addressController: addressController,
          licenseValidator: (v) => v!.isEmpty ? "License is required" : null,
          cityValidator: (v) => v!.isEmpty ? "City is required" : null,
          addressValidator: (v) => v!.isEmpty ? "Address is required" : null,
        );
      case 2:
        return IdentityVerificationSection(
          onProfilePicSelected: (file) => selectedProfilePic = file,
          onIdFrontSelected: (file) => selectedNationalIdFront = file,
          onIdBackSelected: (file) => selectedNationalIdBack = file,
          onIdentityImageSelected: (file) => selectedIdentityVerificationImage = file,
        );
      case 3:
        return Column(
          children: [
            CustomTextFormField(
              controller: passwordController,
              isPassword: true,
              hintText: "Enter your password",
              validator: Validators.validatePassword,
            ),
            SizedBox(height: 14.h),
            CustomTextFormField(
              controller: confirmPasswordController,
              isPassword: true,
              hintText: "Confirm your password",
              validator: (v) => Validators.validateConfirmPassword(
                v,
                passwordController.text,
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  String get _cardTitle {
    switch (currentStep) {
      case 0:
        return "Personal Information";
      case 1:
        return "Professional Information";
      case 2:
        return "Identity Verification";
      case 3:
        return "Set Password";
      default:
        return "Doctor Registration";
    }
  }

  String get _cardSubtitle {
    switch (currentStep) {
      case 0:
        return "Tell us who you are and how we can contact you.";
      case 1:
        return "Add your professional and clinic information.";
      case 2:
        return "Upload your documents to verify your doctor account.";
      case 3:
        return "Set a secure password for your account.";
      default:
        return "Complete your professional profile.";
    }
  }

  String get _buttonText => currentStep == totalSteps - 1 ? "Complete Registration" : "Continue";

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DoctorRegisterProvider>();

    return AuthScaffold(
      title: "Veterinarian Signup",
      subtitle: "Create your verified doctor account on ALEEF.",
      backgroundHeight: 275,
      backgroundIcon: Icons.medical_services_rounded,
      accentIcon: Icons.verified_rounded,
      spacingAfterHero: 14,
      child: Form(
        key: _formKey,
        child: AuthCard(
          title: _cardTitle,
          subtitle: _cardSubtitle,
          children: [
            SizedBox(height: 18.h),
            DoctorRegisterStepsIndicator(
              currentStep: currentStep,
              totalSteps: totalSteps,
            ),
            SizedBox(height: 22.h),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                final slideAnimation = Tween<Offset>(
                  begin: const Offset(0.04, 0),
                  end: Offset.zero,
                ).animate(animation);

                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: child,
                  ),
                );
              },
              child: KeyedSubtree(
                key: ValueKey(currentStep),
                child: _buildCurrentStepContent(),
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52.h,
                    child: OutlinedButton(
                      onPressed: provider.isLoading ? null : _goBack,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(
                          color: AppColors.primary.withOpacity(0.35),
                          width: 1.2.w,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                      ),
                      child: Text(
                        currentStep == 0 ? "Back" : "Previous",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: provider.isLoading ? null : _handleContinue,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: AppColors.primary.withOpacity(0.65),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                      ),
                      child: provider.isLoading
                          ? SizedBox(
                        height: 20.r,
                        width: 20.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2.w,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _buttonText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Steps Indicator تعريف
class DoctorRegisterStepsIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const DoctorRegisterStepsIndicator({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final steps = [
      const _StepData(title: "Personal", icon: Icons.person_outline),
      const _StepData(title: "Clinic", icon: Icons.medical_services_outlined),
      const _StepData(title: "Verify", icon: Icons.verified_user_outlined),
      const _StepData(title: "Password", icon: Icons.lock_outline),
    ];

    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentStep;
        final isDone = index < currentStep;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isActive || isDone
                        ? AppColors.primary.withOpacity(0.08)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(
                      color: isActive || isDone
                          ? AppColors.primary.withOpacity(0.22)
                          : AppColors.border.withOpacity(0.8),
                    ),
                  ),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        height: 30.h,
                        width: 30.w,
                        decoration: BoxDecoration(
                          color: isDone || isActive ? AppColors.primary : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: isDone || isActive ? AppColors.primary : AppColors.border),
                        ),
                        child: Icon(
                          isDone ? Icons.check_rounded : steps[index].icon,
                          size: 16.sp,
                          color: isDone || isActive ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 7.h),
                      Text(
                        steps[index].title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          height: 1,
                          color: isActive || isDone ? AppColors.primary : AppColors.textSecondary,
                          fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (index != totalSteps - 1)
                Container(
                  width: 8.w,
                  height: 2.h,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: index < currentStep
                        ? AppColors.primary
                        : AppColors.border.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _StepData {
  final String title;
  final IconData icon;
  const _StepData({required this.title, required this.icon});
}
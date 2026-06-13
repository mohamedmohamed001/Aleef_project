import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/services/auth_api_service.dart';
import '../providers/verify_provider.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_field_label.dart';
import '../widgets/auth_otp_boxes.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_snackbar.dart';
import '../widgets/auth_trust_note.dart';
import '../../data/services/doctor_auth_api_service.dart';

class VerificationOtpScreen extends StatefulWidget {
  const VerificationOtpScreen({super.key});

  @override
  State<VerificationOtpScreen> createState() => _VerificationOtpScreenState();
}

class _VerificationOtpScreenState extends State<VerificationOtpScreen> {
  final List<TextEditingController> otpControllers = List.generate(
    6,
        (_) => TextEditingController(),
  );

  final List<FocusNode> otpFocusNodes = List.generate(
    6,
        (_) => FocusNode(),
  );

  bool isLoading = false;
  bool isResending = false;

  @override
  void dispose() {
    for (final controller in otpControllers) {
      controller.dispose();
    }

    for (final node in otpFocusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  String get _otpCode {
    return otpControllers.map((controller) => controller.text.trim()).join();
  }

  Future<void> _handleVerify() async {
    if (isLoading) return;

    FocusScope.of(context).unfocus();

    final code = _otpCode;

    final verifyProvider =
    context.read<VerifyProvider>();

    final email = verifyProvider.email;
    final isDoctor = verifyProvider.isDoctor;

    if (email == null || email.isEmpty) {
      showAuthSnackBar(
        context,
        message: "Email not found, please register again",
      );
      return;
    }

    if (code.length != 6) {
      showAuthSnackBar(
        context,
        message: "Please enter the 6-digit code",
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      bool success = false;

      if (isDoctor) {
        success = await DoctorAuthApiService()
            .verifyEmail(
          email: email,
          otp: code,
        );
      } else {
        success = await AuthApiService()
            .verifyOtp(
          code,
          email,
        );
      }

      if (!mounted) return;

      if (success) {
        if (isDoctor) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.doctorPendingReview,
                (route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.mainLayout,
                (route) => false,
          );
        }
      } else {
        showAuthSnackBar(
          context,
          message: "Verification failed",
        );
      }
    } catch (e) {
      showAuthSnackBar(
        context,
        message: e.toString(),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _handleResend() async {
    if (isResending) return;

    final email = context.read<VerifyProvider>().email;

    if (email == null || email.isEmpty) {
      showAuthSnackBar(
        context,
        message: "Email not found, please register again",
      );
      return;
    }

    setState(() {
      isResending = true;
    });

    await AuthApiService().reSendOtp(email);

    if (!mounted) return;

    setState(() {
      isResending = false;
    });

    showAuthSnackBar(
      context,
      message: "Verification code sent again",
      type: AuthSnackBarType.success,
    );
  }

  void _onOtpChanged({
    required String value,
    required int index,
  }) {
    if (value.length > 1) {
      _handlePaste(value);
      return;
    }

    if (value.isNotEmpty) {
      if (index < 5) {
        otpFocusNodes[index + 1].requestFocus();
      } else {
        FocusScope.of(context).unfocus();
      }
    }

    setState(() {});
  }

  void _onOtpKeyEvent({
    required KeyEvent event,
    required int index,
  }) {
    if (event is! KeyDownEvent) return;

    final isBackspace = event.logicalKey == LogicalKeyboardKey.backspace;

    if (isBackspace && otpControllers[index].text.isEmpty && index > 0) {
      otpFocusNodes[index - 1].requestFocus();
      otpControllers[index - 1].clear();
      setState(() {});
    }
  }

  void _handlePaste(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty) return;

    for (int i = 0; i < otpControllers.length; i++) {
      otpControllers[i].text = i < digits.length ? digits[i] : '';
    }

    final nextIndex = digits.length >= 6 ? 5 : digits.length;
    otpFocusNodes[nextIndex.clamp(0, 5)].requestFocus();

    if (digits.length >= 6) {
      FocusScope.of(context).unfocus();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final email = context.watch<VerifyProvider>().email;
    final shownEmail = (email == null || email.isEmpty) ? "your email" : email;

    return AuthScaffold(
      title: "Verify Email",
      subtitle: "Enter the code we sent to your email.",
      backgroundHeight: 300,
      backgroundIcon: Icons.mark_email_read_rounded,
      accentIcon: Icons.verified_rounded,
      spacingAfterHero: 24,
      child: AuthCard(
        title: "Verification",
        subtitle: "We sent a verification code to:",
        children: [
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.08),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.email_rounded,
                  size: 18.sp,
                  color: AppColors.primary,
                ),
                SizedBox(width: 9.w),
                Expanded(
                  child: Text(
                    shownEmail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.label14Medium.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          const AuthFieldLabel(
            title: "Verification Code",
            icon: Icons.security_rounded,
          ),
          SizedBox(height: 12.h),
          AuthOtpBoxes(
            controllers: otpControllers,
            focusNodes: otpFocusNodes,
            onChanged: _onOtpChanged,
            onKeyEvent: _onOtpKeyEvent,
          ),
          SizedBox(height: 24.h),
          AuthPrimaryButton(
            text: "Verify",
            isLoading: isLoading,
            onPressed: _handleVerify,
          ),
          SizedBox(height: 18.h),
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: AppTextStyles.body14Regular.copyWith(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                ),
                children: [
                  const TextSpan(text: "Didn’t receive the code? "),
                  TextSpan(
                    text: isResending ? "Sending..." : "Resend",
                    style: AppTextStyles.label14Medium.copyWith(
                      color: AppColors.primary,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = isResending ? null : _handleResend,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          const AuthTrustNote(
            text: "Check your inbox or spam folder.",
            icon: Icons.info_outline_rounded,
            isNeutral: true,
          ),
        ],
      ),
    );
  }
}

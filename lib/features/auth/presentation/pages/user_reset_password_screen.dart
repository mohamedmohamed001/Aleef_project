import 'package:aleef/core/routing/app_routes.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/widgets/app_snack_bar.dart';
import 'package:aleef/features/auth/data/services/auth_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserResetPasswordScreen extends StatefulWidget {
  final String email;

  const UserResetPasswordScreen({
    super.key,
    required this.email,
  });

  @override
  State<UserResetPasswordScreen> createState() =>
      _UserResetPasswordScreenState();
}

class _UserResetPasswordScreenState extends State<UserResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _isLoading = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final result = await AuthApiService().resetPassword(
      otp: _otpController.text.trim(),
      newPassword: _newPasswordController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result.success) {
      AppSnackBar.success(
        context,
        message: result.message,
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
            (route) => false,
      );

      return;
    }

    AppSnackBar.error(
      context,
      message: result.message,
    );
  }

  Future<void> _resendOtp() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final result = await AuthApiService().forgetPassword(
      email: widget.email,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result.success) {
      AppSnackBar.success(
        context,
        message: result.message,
      );
      return;
    }

    AppSnackBar.error(
      context,
      message: result.message,
    );
  }

  String? _validateOtp(String? value) {
    final otp = value?.trim() ?? '';

    if (otp.isEmpty) {
      return 'OTP is required';
    }

    if (otp.length < 4) {
      return 'Enter a valid OTP';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final password = value?.trim() ?? '';

    if (password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final confirmPassword = value?.trim() ?? '';
    final newPassword = _newPasswordController.text.trim();

    if (confirmPassword.isEmpty) {
      return 'Confirm password is required';
    }

    if (confirmPassword != newPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8FAFA),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: const Color(0xff1F2A2E),
            size: 20.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 18.h),

                Container(
                  width: 92.r,
                  height: 92.r,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.verified_user_rounded,
                    color: AppColors.primary,
                    size: 43.sp,
                  ),
                ),

                SizedBox(height: 24.h),

                Text(
                  'Reset Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xff1F2A2E),
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),

                SizedBox(height: 12.h),

                Text(
                  'Enter the OTP sent to ${widget.email} and choose your new password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xff6B7A80),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                  ),
                ),

                SizedBox(height: 32.h),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26.r),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.04),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.035),
                        blurRadius: 18.r,
                        offset: Offset(0, 10.h),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _ResetField(
                        controller: _otpController,
                        title: 'OTP Code',
                        hint: 'Enter OTP',
                        icon: Icons.pin_rounded,
                        enabled: !_isLoading,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: _validateOtp,
                      ),

                      SizedBox(height: 16.h),

                      _ResetField(
                        controller: _newPasswordController,
                        title: 'New Password',
                        hint: 'Enter new password',
                        icon: Icons.lock_outline_rounded,
                        enabled: !_isLoading,
                        obscureText: !_showNewPassword,
                        textInputAction: TextInputAction.next,
                        validator: _validatePassword,
                        suffixIcon: IconButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                            setState(() {
                              _showNewPassword = !_showNewPassword;
                            });
                          },
                          icon: Icon(
                            _showNewPassword
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                            color: const Color(0xff8A969A),
                            size: 21.sp,
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      _ResetField(
                        controller: _confirmPasswordController,
                        title: 'Confirm Password',
                        hint: 'Re-enter new password',
                        icon: Icons.lock_outline_rounded,
                        enabled: !_isLoading,
                        obscureText: !_showConfirmPassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _resetPassword(),
                        validator: _validateConfirmPassword,
                        suffixIcon: IconButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                            setState(() {
                              _showConfirmPassword =
                              !_showConfirmPassword;
                            });
                          },
                          icon: Icon(
                            _showConfirmPassword
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                            color: const Color(0xff8A969A),
                            size: 21.sp,
                          ),
                        ),
                      ),

                      SizedBox(height: 22.h),

                      SizedBox(
                        width: double.infinity,
                        height: 54.h,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _resetPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            disabledBackgroundColor:
                            AppColors.primary.withOpacity(0.55),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17.r),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                            width: 22.r,
                            height: 22.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: Colors.white,
                            ),
                          )
                              : Text(
                            'Reset Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                TextButton(
                  onPressed: _isLoading ? null : _resendOtp,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                  child: Text(
                    'Resend OTP',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResetField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String hint;
  final IconData icon;
  final bool enabled;
  final bool obscureText;
  final TextInputAction textInputAction;
  final TextInputType? keyboardType;
  final String? Function(String?) validator;
  final Widget? suffixIcon;
  final ValueChanged<String>? onFieldSubmitted;

  const _ResetField({
    required this.controller,
    required this.title,
    required this.hint,
    required this.icon,
    required this.enabled,
    required this.textInputAction,
    required this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: const Color(0xff1F2A2E),
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
          ),
        ),

        SizedBox(height: 10.h),

        TextFormField(
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          cursorColor: AppColors.primary,
          style: TextStyle(
            color: const Color(0xff1F2A2E),
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: const Color(0xff9AA6AA),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(
              icon,
              color: AppColors.primary,
              size: 21.sp,
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: const Color(0xffF8FAFA),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: Colors.black.withOpacity(0.04),
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: Colors.black.withOpacity(0.04),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 1.4.w,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: Colors.redAccent,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: Colors.redAccent,
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
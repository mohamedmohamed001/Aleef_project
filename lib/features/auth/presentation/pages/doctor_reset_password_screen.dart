import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/auth/data/services/doctor_auth_api_service.dart';
import 'package:aleef/features/auth/presentation/pages/doctor_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorResetPasswordScreen extends StatefulWidget {
  const DoctorResetPasswordScreen({super.key});

  @override
  State<DoctorResetPasswordScreen> createState() =>
      _DoctorResetPasswordScreenState();
}

class _DoctorResetPasswordScreenState extends State<DoctorResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final DoctorAuthApiService _authApiService = DoctorAuthApiService();

  bool _isLoading = false;
  bool _hideNewPassword = true;
  bool _hideConfirmPassword = true;

  @override
  void dispose() {
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateOtp(String? value) {
    final otp = value?.trim() ?? '';

    if (otp.isEmpty) {
      return 'OTP is required';
    }

    if (otp.length != 6) {
      return 'OTP must be 6 digits';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(otp)) {
      return 'OTP must contain numbers only';
    }

    return null;
  }

  String? _validateNewPassword(String? value) {
    final password = value?.trim() ?? '';

    if (password.isEmpty) {
      return 'New password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must contain at least one number';
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=/\\[\]~`]').hasMatch(password)) {
      return 'Password must contain at least one special character';
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

  Future<void> _resetPassword() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final errorMessage = await _authApiService.doctorResetPassword(
      otp: _otpController.text.trim(),
      newPassword: _newPasswordController.text.trim(),
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset successfully. Please login again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const DoctorLoginScreen(),
        ),
            (route) => false,
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F8F8),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'Reset Password',
          style: TextStyle(
            color: const Color(0xFF1F2A2E),
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: const Color(0xFF1F2A2E),
            size: 20.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 24.h),
          child: Column(
            children: [
              const _ResetPasswordHeader(),
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26.r),
                  border: Border.all(
                    color: const Color(0xFFE8EEEE),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.035),
                      blurRadius: 18.r,
                      offset: Offset(0, 8.h),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel(title: 'OTP Code'),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _otpController,
                        enabled: !_isLoading,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        maxLength: 6,
                        validator: _validateOtp,
                        cursorColor: AppColors.primary,
                        style: TextStyle(
                          color: const Color(0xFF1F2A2E),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: 'Enter 6-digit OTP',
                          hintStyle: TextStyle(
                            color: const Color(0xFF9AA7A7),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFA),
                          prefixIcon: Icon(
                            Icons.pin_outlined,
                            color: AppColors.primary,
                            size: 21.sp,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 15.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(17.r),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(17.r),
                            borderSide: const BorderSide(
                              color: Color(0xFFE4ECEC),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(17.r),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 1.3.w,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(17.r),
                            borderSide: BorderSide(
                              color: Colors.red.withOpacity(0.7),
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(17.r),
                            borderSide: BorderSide(
                              color: Colors.red.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _FieldLabel(title: 'New Password'),
                      SizedBox(height: 8.h),
                      _PasswordField(
                        controller: _newPasswordController,
                        hint: 'Enter new password',
                        obscureText: _hideNewPassword,
                        enabled: !_isLoading,
                        validator: _validateNewPassword,
                        onToggle: () {
                          setState(() {
                            _hideNewPassword = !_hideNewPassword;
                          });
                        },
                      ),
                      SizedBox(height: 16.h),
                      _FieldLabel(title: 'Confirm Password'),
                      SizedBox(height: 8.h),
                      _PasswordField(
                        controller: _confirmPasswordController,
                        hint: 'Confirm new password',
                        obscureText: _hideConfirmPassword,
                        enabled: !_isLoading,
                        validator: _validateConfirmPassword,
                        onToggle: () {
                          setState(() {
                            _hideConfirmPassword = !_hideConfirmPassword;
                          });
                        },
                      ),
                      SizedBox(height: 22.h),
                      const _PasswordNote(),
                      SizedBox(height: 24.h),
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
                              borderRadius: BorderRadius.circular(18.r),
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
                              fontWeight: FontWeight.w800,
                            ),
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
      ),
    );
  }
}

class _ResetPasswordHeader extends StatelessWidget {
  const _ResetPasswordHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.82),
          ],
        ),
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.18),
            blurRadius: 18.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58.r,
            height: 58.r,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.22),
              ),
            ),
            child: Icon(
              Icons.verified_user_outlined,
              color: Colors.white,
              size: 30.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create new password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'Enter the OTP sent to your email and choose a strong password.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.86),
                    fontSize: 12.sp,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String title;

  const _FieldLabel({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: const Color(0xFF1F2A2E),
        fontSize: 13.sp,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final bool enabled;
  final VoidCallback onToggle;
  final String? Function(String?) validator;

  const _PasswordField({
    required this.controller,
    required this.hint,
    required this.obscureText,
    required this.enabled,
    required this.onToggle,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      validator: validator,
      cursorColor: AppColors.primary,
      textInputAction: TextInputAction.next,
      style: TextStyle(
        color: const Color(0xFF1F2A2E),
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: const Color(0xFF9AA7A7),
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFA),
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          color: AppColors.primary,
          size: 21.sp,
        ),
        suffixIcon: IconButton(
          onPressed: enabled ? onToggle : null,
          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: const Color(0xFF8A9797),
            size: 21.sp,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 15.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17.r),
          borderSide: const BorderSide(
            color: Color(0xFFE4ECEC),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17.r),
          borderSide: const BorderSide(
            color: Color(0xFFE4ECEC),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17.r),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 1.3.w,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17.r),
          borderSide: BorderSide(
            color: Colors.red.withOpacity(0.7),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17.r),
          borderSide: BorderSide(
            color: Colors.red.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}

class _PasswordNote extends StatelessWidget {
  const _PasswordNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.10),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: 20.sp,
          ),
          SizedBox(width: 9.w),
          Expanded(
            child: Text(
              'Password must be at least 8 characters and include uppercase, lowercase, number, and special character.',
              style: TextStyle(
                color: const Color(0xFF3B4444),
                fontSize: 11.5.sp,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
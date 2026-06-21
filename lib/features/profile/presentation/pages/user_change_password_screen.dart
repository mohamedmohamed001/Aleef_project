import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/widgets/app_snack_bar.dart';
import 'package:aleef/features/auth/data/services/auth_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserChangePasswordScreen extends StatefulWidget {
  const UserChangePasswordScreen({super.key});

  @override
  State<UserChangePasswordScreen> createState() =>
      _UserChangePasswordScreenState();
}

class _UserChangePasswordScreenState extends State<UserChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController =
  TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _isLoading = false;
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final result = await AuthApiService().changePassword(
      currentPassword: _currentPasswordController.text.trim(),
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

      Navigator.pop(context);
      return;
    }

    AppSnackBar.error(
      context,
      message: result.message,
    );
  }

  String? _passwordValidator(String? value) {
    final password = value?.trim() ?? '';

    if (password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }

  String? _newPasswordValidator(String? value) {
    final newPassword = value?.trim() ?? '';
    final currentPassword = _currentPasswordController.text.trim();

    final baseValidation = _passwordValidator(value);
    if (baseValidation != null) return baseValidation;

    if (newPassword == currentPassword) {
      return 'New password must be different';
    }

    return null;
  }

  String? _confirmPasswordValidator(String? value) {
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
        centerTitle: false,
        leading: IconButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20.sp,
            color: const Color(0xff1F2A2E),
          ),
        ),
        title: Text(
          'Change Password',
          style: TextStyle(
            color: const Color(0xff1F2A2E),
            fontSize: 22.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const _HeaderCard(),

                SizedBox(height: 18.h),

                _PasswordCard(
                  children: [
                    _PasswordField(
                      controller: _currentPasswordController,
                      title: 'Current Password',
                      hint: 'Enter your current password',
                      obscureText: !_showCurrentPassword,
                      enabled: !_isLoading,
                      textInputAction: TextInputAction.next,
                      onToggleVisibility: () {
                        setState(() {
                          _showCurrentPassword = !_showCurrentPassword;
                        });
                      },
                      validator: _passwordValidator,
                    ),

                    SizedBox(height: 16.h),

                    _PasswordField(
                      controller: _newPasswordController,
                      title: 'New Password',
                      hint: 'Enter your new password',
                      obscureText: !_showNewPassword,
                      enabled: !_isLoading,
                      textInputAction: TextInputAction.next,
                      onToggleVisibility: () {
                        setState(() {
                          _showNewPassword = !_showNewPassword;
                        });
                      },
                      validator: _newPasswordValidator,
                    ),

                    SizedBox(height: 16.h),

                    _PasswordField(
                      controller: _confirmPasswordController,
                      title: 'Confirm New Password',
                      hint: 'Re-enter your new password',
                      obscureText: !_showConfirmPassword,
                      enabled: !_isLoading,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _changePassword(),
                      onToggleVisibility: () {
                        setState(() {
                          _showConfirmPassword = !_showConfirmPassword;
                        });
                      },
                      validator: _confirmPasswordValidator,
                    ),
                  ],
                ),

                SizedBox(height: 22.h),

                SizedBox(
                  width: double.infinity,
                  height: 54.h,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _changePassword,
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
                      'Update Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 18.h),

                const _SecurityNote(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.18),
            blurRadius: 20.r,
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
              color: Colors.white.withOpacity(0.16),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.22),
              ),
            ),
            child: Icon(
              Icons.lock_reset_rounded,
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
                  "Keep your account safe",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "Use a strong password that you don't use elsewhere.",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.82),
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
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

class _PasswordCard extends StatelessWidget {
  final List<Widget> children;

  const _PasswordCard({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.black.withOpacity(0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String hint;
  final bool obscureText;
  final bool enabled;
  final TextInputAction textInputAction;
  final VoidCallback onToggleVisibility;
  final String? Function(String?) validator;
  final ValueChanged<String>? onFieldSubmitted;

  const _PasswordField({
    required this.controller,
    required this.title,
    required this.hint,
    required this.obscureText,
    required this.enabled,
    required this.textInputAction,
    required this.onToggleVisibility,
    required this.validator,
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
            fontSize: 13.sp,
            fontWeight: FontWeight.w800,
          ),
        ),

        SizedBox(height: 8.h),

        TextFormField(
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          validator: validator,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          style: TextStyle(
            color: const Color(0xff1F2A2E),
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: const Color(0xff8A969A),
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: const Color(0xffF8FAFA),
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              color: AppColors.primary,
              size: 21.sp,
            ),
            suffixIcon: IconButton(
              onPressed: enabled ? onToggleVisibility : null,
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: const Color(0xff8A969A),
                size: 21.sp,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 15.h,
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
              borderSide: BorderSide(
                color: Colors.red.withOpacity(0.75),
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: Colors.red.withOpacity(0.75),
                width: 1.4.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SecurityNote extends StatelessWidget {
  const _SecurityNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.info.withOpacity(0.12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: AppColors.info,
            size: 21.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'For better security, choose a password with letters, numbers, and symbols.',
              style: TextStyle(
                color: const Color(0xff4E5A5E),
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/doctor/home/presentation/manager/doctor_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DoctorChangePasswordScreen extends StatefulWidget {
  const DoctorChangePasswordScreen({super.key});

  @override
  State<DoctorChangePasswordScreen> createState() =>
      _DoctorChangePasswordScreenState();
}

class _DoctorChangePasswordScreenState
    extends State<DoctorChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _hideCurrentPassword = true;
  bool _hideNewPassword = true;
  bool _hideConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateCurrentPassword(String? value) {
    final password = value?.trim() ?? '';

    if (password.isEmpty) {
      return 'Current password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }

  String? _validateNewPassword(String? value) {
    final password = value?.trim() ?? '';
    final currentPassword = _currentPasswordController.text.trim();

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

    if (password == currentPassword) {
      return 'New password must be different from current password';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final password = value?.trim() ?? '';
    final newPassword = _newPasswordController.text.trim();

    if (password.isEmpty) {
      return 'Confirm password is required';
    }

    if (password != newPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<DoctorProfileProvider>();

    final success = await provider.changePassword(
      currentPassword: _currentPasswordController.text.trim(),
      newPassword: _newPasswordController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated successfully.'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context, true);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(provider.errorMessage ?? 'Password update failed.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorProfileProvider>(
      builder: (context, provider, child) {
        final isLoading = provider.isChangingPassword;

        return Scaffold(
          backgroundColor: const Color(0xFFF6F8F8),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF6F8F8),
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            title: Text(
              'Change Password',
              style: TextStyle(
                color: const Color(0xFF1F2A2E),
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            leading: IconButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
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
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
              child: Column(
                children: [
                  const _SecurityHeader(),
                  SizedBox(height: 18.h),
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
                          const _FieldLabel(
                            title: 'Current Password',
                          ),
                          SizedBox(height: 8.h),
                          _PasswordField(
                            controller: _currentPasswordController,
                            hint: 'Enter current password',
                            obscureText: _hideCurrentPassword,
                            enabled: !isLoading,
                            validator: _validateCurrentPassword,
                            onToggle: () {
                              setState(() {
                                _hideCurrentPassword = !_hideCurrentPassword;
                              });
                            },
                          ),
                          SizedBox(height: 16.h),
                          const _FieldLabel(
                            title: 'New Password',
                          ),
                          SizedBox(height: 8.h),
                          _PasswordField(
                            controller: _newPasswordController,
                            hint: 'Enter new password',
                            obscureText: _hideNewPassword,
                            enabled: !isLoading,
                            validator: _validateNewPassword,
                            onToggle: () {
                              setState(() {
                                _hideNewPassword = !_hideNewPassword;
                              });
                            },
                          ),
                          SizedBox(height: 16.h),
                          const _FieldLabel(
                            title: 'Confirm Password',
                          ),
                          SizedBox(height: 8.h),
                          _PasswordField(
                            controller: _confirmPasswordController,
                            hint: 'Confirm new password',
                            obscureText: _hideConfirmPassword,
                            enabled: !isLoading,
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
                              onPressed: isLoading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                disabledBackgroundColor:
                                AppColors.primary.withOpacity(0.55),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.r),
                                ),
                              ),
                              child: isLoading
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
      },
    );
  }
}

class _SecurityHeader extends StatelessWidget {
  const _SecurityHeader();

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
                  'Keep your account safe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'Use a strong password that you have not used before.',
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
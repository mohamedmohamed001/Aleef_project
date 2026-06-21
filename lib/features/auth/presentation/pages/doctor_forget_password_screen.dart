import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/widgets/app_snack_bar.dart';
import 'package:aleef/features/auth/data/services/doctor_auth_api_service.dart';
import 'package:aleef/features/auth/presentation/pages/doctor_reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorForgetPasswordScreen extends StatefulWidget {
  const DoctorForgetPasswordScreen({super.key});

  @override
  State<DoctorForgetPasswordScreen> createState() =>
      _DoctorForgetPasswordScreenState();
}

class _DoctorForgetPasswordScreenState
    extends State<DoctorForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  final DoctorAuthApiService _authApiService = DoctorAuthApiService();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  Future<void> _sendResetRequest() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final errorMessage = await _authApiService.doctorForgetPassword(
      email: _emailController.text.trim(),
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (errorMessage == null) {
      AppSnackBar.success(
        context,
        message: 'OTP has been sent to your email.',
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const DoctorResetPasswordScreen(),
        ),
      );

      return;
    }

    AppSnackBar.error(
      context,
      message: errorMessage,
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
          'Forget Password',
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
              const _ForgetPasswordHeader(),

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
                      Text(
                        'Doctor Email',
                        style: TextStyle(
                          color: const Color(0xFF1F2A2E),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      TextFormField(
                        controller: _emailController,
                        enabled: !_isLoading,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        validator: _validateEmail,
                        cursorColor: AppColors.primary,
                        onFieldSubmitted: (_) => _sendResetRequest(),
                        style: TextStyle(
                          color: const Color(0xFF1F2A2E),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your email address',
                          hintStyle: TextStyle(
                            color: const Color(0xFF9AA7A7),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFA),
                          prefixIcon: Icon(
                            Icons.email_outlined,
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
                      ),

                      SizedBox(height: 18.h),

                      Container(
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
                                'We will send an OTP to your registered doctor email.',
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
                      ),

                      SizedBox(height: 24.h),

                      SizedBox(
                        width: double.infinity,
                        height: 54.h,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _sendResetRequest,
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
                            'Send OTP',
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

              SizedBox(height: 24.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Remember password?',
                    style: TextStyle(
                      color: const Color(0xFF6B7A80),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      minimumSize: Size(0, 36.h),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ForgetPasswordHeader extends StatelessWidget {
  const _ForgetPasswordHeader();

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
                  'Reset your password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'Enter your email and we will send you a reset OTP.',
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
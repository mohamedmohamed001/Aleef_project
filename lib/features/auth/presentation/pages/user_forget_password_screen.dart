import 'package:aleef/core/routing/app_routes.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/widgets/app_snack_bar.dart';
import 'package:aleef/features/auth/data/services/auth_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserForgetPasswordScreen extends StatefulWidget {
  const UserForgetPasswordScreen({super.key});

  @override
  State<UserForgetPasswordScreen> createState() =>
      _UserForgetPasswordScreenState();
}

class _UserForgetPasswordScreenState extends State<UserForgetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();

    final result = await AuthApiService().forgetPassword(
      email: email,
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

      Navigator.pushNamed(
        context,
        AppRoutes.userResetPassword,
        arguments: email,
      );

      return;
    }

    AppSnackBar.error(
      context,
      message: result.message,
    );
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email';
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
                SizedBox(height: 22.h),

                Container(
                  width: 92.r,
                  height: 92.r,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_reset_rounded,
                    color: AppColors.primary,
                    size: 44.sp,
                  ),
                ),

                SizedBox(height: 24.h),

                Text(
                  'Forget Password?',
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
                  'Enter your email address and we will send you an OTP to reset your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xff6B7A80),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                  ),
                ),

                SizedBox(height: 34.h),

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email Address',
                        style: TextStyle(
                          color: const Color(0xff1F2A2E),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      SizedBox(height: 10.h),

                      TextFormField(
                        controller: _emailController,
                        enabled: !_isLoading,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _sendOtp(),
                        cursorColor: AppColors.primary,
                        style: TextStyle(
                          color: const Color(0xff1F2A2E),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(
                            color: const Color(0xff9AA6AA),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: AppColors.primary,
                            size: 21.sp,
                          ),
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

                      SizedBox(height: 22.h),

                      SizedBox(
                        width: double.infinity,
                        height: 54.h,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _sendOtp,
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
                            'Send OTP',
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

                SizedBox(height: 24.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Remember password?',
                      style: TextStyle(
                        color: const Color(0xff6B7A80),
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
      ),
    );
  }
}
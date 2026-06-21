import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AuthHeroBackground extends StatelessWidget {
  final double height;
  final IconData backgroundIcon;
  final IconData accentIcon;

  const AuthHeroBackground({
    super.key,
    required this.height,
    required this.backgroundIcon,
    required this.accentIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height.h,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2D928B),
                AppColors.primary,
                Color(0xFF13524D),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(42.r),
              bottomRight: Radius.circular(42.r),
            ),
          ),
        ),
        Positioned(
          top: -70.h,
          right: -55.w,
          child: _SoftCircle(
            size: 180,
            color: Colors.white.withOpacity(0.14),
          ),
        ),
        Positioned(
          top: 108.h,
          left: -72.w,
          child: _SoftCircle(
            size: 150,
            color: Colors.white.withOpacity(0.10),
          ),
        ),
        Positioned(
          top: 82.h,
          right: 30.w,
          child: Icon(
            backgroundIcon,
            size: 86.sp,
            color: Colors.white.withOpacity(0.08),
          ),
        ),
        Positioned(
          top: 200.h,
          left: 32.w,
          child: Icon(
            accentIcon,
            size: 42.sp,
            color: Colors.white.withOpacity(0.07),
          ),
        ),
      ],
    );
  }
}

class AuthHeroContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final String chipText;
  final String logoPath;

  const AuthHeroContent({
    super.key,
    required this.title,
    required this.subtitle,
    this.chipText = "Secure ALEEF Account",
    this.logoPath = "assets/images/logo.png",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8.h),
        Container(
          height: 78.h,
          width: 78.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.24),
                Colors.white.withOpacity(0.10),
              ],
            ),
            borderRadius: BorderRadius.circular(26.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.32),
              width: 1.2.w,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.14),
                blurRadius: 24.r,
                offset: Offset(0, 12.h),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(13.r),
            child: Image.asset(
              logoPath,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) {
                return Icon(
                  Icons.pets_rounded,
                  color: Colors.white,
                  size: 40.sp,
                );
              },
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.userNameAppbar.copyWith(
            fontSize: 28.sp,
            height: 1.1,
            letterSpacing: -0.5.w,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.hint14Regular.copyWith(
            color: Colors.white.withOpacity(0.84),
            fontSize: 14.sp,
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 18.h),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 8.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.20),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.verified_user_rounded,
                color: Colors.white.withOpacity(0.95),
                size: 15.sp,
              ),
              SizedBox(width: 7.w),
              Text(
                chipText,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.94),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SoftCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _SoftCircle({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.r,
      width: size.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

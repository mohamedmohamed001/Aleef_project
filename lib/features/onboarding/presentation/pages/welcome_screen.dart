import 'package:aleef/core/routing/app_routes.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _goToChooseRole(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.chooseRole);
  }

  void _goToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFA),
      body: Stack(
        children: [
          const _WelcomeHeader(),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: Column(
                children: [
                  SizedBox(height: 18.h),

                  const _AleefLogo(),

                  SizedBox(height: 42.h),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Your pet care,\nall in one place',
                      style: AppTextStyles.titleLarge.copyWith(
                        color: Colors.white,
                        fontSize: 38.sp,
                        fontWeight: FontWeight.w900,
                        height: 1.08,
                        letterSpacing: -1.1,
                      ),
                    ),
                  ),

                  SizedBox(height: 14.h),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Book appointments, manage records,\nshop essentials, and get instant help.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.88),
                        fontSize: 14.5.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.55,
                      ),
                    ),
                  ),

                  SizedBox(height: 34.h),

                  const _HeroCard(),

                  const Spacer(),

                  Row(
                    children: [
                      Expanded(
                        child: _FeatureMiniCard(
                          icon: Icons.calendar_month_rounded,
                          title: 'Appointments',
                          subtitle: 'Book vets',
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _FeatureMiniCard(
                          icon: Icons.health_and_safety_rounded,
                          title: 'Records',
                          subtitle: 'Track health',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  Row(
                    children: [
                      Expanded(
                        child: _FeatureMiniCard(
                          icon: Icons.shopping_bag_rounded,
                          title: 'Shop',
                          subtitle: 'Pet essentials',
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _FeatureMiniCard(
                          icon: Icons.chat_bubble_rounded,
                          title: 'Chat',
                          subtitle: 'Ask for help',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 26.h),

                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () => _goToChooseRole(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                      ),
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  GestureDetector(
                    onTap: () => _goToLogin(context),
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: const Color(0xFF6B7A78),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 22.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 430.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(42.r),
          bottomRight: Radius.circular(42.r),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -70.h,
            right: -70.w,
            child: _HeaderCircle(size: 210.w, opacity: 0.10),
          ),
          Positioned(
            top: 170.h,
            left: -90.w,
            child: _HeaderCircle(size: 190.w, opacity: 0.08),
          ),
          Positioned(
            bottom: 55.h,
            right: 38.w,
            child: _HeaderCircle(size: 44.w, opacity: 0.14),
          ),
        ],
      ),
    );
  }
}

class _AleefLogo extends StatelessWidget {
  const _AleefLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.pets_rounded,
              color: AppColors.primary,
              size: 19.sp,
            ),
          ),
          SizedBox(width: 9.w),
          Text(
            'ALEEF',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 28,
            offset: Offset(0, 14.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 76.w,
            height: 76.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Icon(
              Icons.pets_rounded,
              color: AppColors.primary,
              size: 38.sp,
            ),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Built for happy pets',
                  style: TextStyle(
                    color: const Color(0xFF102322),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Everything your pet needs from care to support.',
                  style: TextStyle(
                    color: const Color(0xFF6B7A78),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
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

class _FeatureMiniCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureMiniCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 18,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 22.sp,
            ),
          ),

          SizedBox(height: 14.h),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF102322),
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
            ),
          ),

          SizedBox(height: 4.h),

          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF7A8987),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _HeaderCircle({
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}
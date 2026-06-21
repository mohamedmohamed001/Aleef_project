import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:aleef/core/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutAleefScreen extends StatelessWidget {
  const AboutAleefScreen({super.key});

  static const List<String> _teamMembers = [
    "Mohamed Mahmoud",
    "Mahmoud Tamer",
    "Mohamed Ahmed",
    "Mowafak Maged",
    "Omar Ayman",
    "Toqa Gamal",
    "Shahd Tamer",
    "Magy Ashraf",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: const Color(0xFF111827),
            size: 20.sp,
          ),
        ),
        title: Text(
          "About ALEEF",
          style: AppTextStyles.black16Bold.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24.r),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 28.h),
        child: Column(
          children: [
            const _AleefHeroCard(),

            SizedBox(height: 18.h),

            _InfoCard(
              title: "About the App",
              icon: Icons.info_outline_rounded,
              child: Text(
                "ALEEF is an all-in-one pet healthcare platform that helps pet owners manage their pets, book veterinary appointments, explore pet supplies, receive notifications, and stay connected with care services in one simple experience.",
                style: TextStyle(
                  fontSize: 13.5.sp,
                  height: 1.6,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(height: 18.h),

            _InfoCard(
              title: "Our Team",
              icon: Icons.groups_2_rounded,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "The people behind ALEEF.",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 14.h),

                  GridView.builder(
                    itemCount: _teamMembers.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,

                      // مهم: ده كان سبب الـ overflow
                      // قللنا الرقم عشان نزود ارتفاع الكارت
                      childAspectRatio: 1.18,
                    ),
                    itemBuilder: (context, index) {
                      return _TeamMemberCard(
                        name: _teamMembers[index],
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 18.h),

            _InfoCard(
              title: "App Information",
              icon: Icons.verified_rounded,
              child: const Column(
                children: [
                  _AppInfoRow(
                    title: "Version",
                    value: "1.0.0",
                  ),
                  _CardDivider(),
                  _AppInfoRow(
                    title: "Platform",
                    value: "Pet Healthcare",
                  ),
                  _CardDivider(),
                  _AppInfoRow(
                    title: "Developed by",
                    value: "ALEEF Team",
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            Text(
              "Made with love by ALEEF Team",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black45,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AleefHeroCard extends StatelessWidget {
  const _AleefHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2D928B),
            AppColors.primary,
            Color(0xFF14504B),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: 24.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Stack(
        children: [
          /// Top right bubble - لازقة في حدود الكارت
          Positioned(
            right: -45.w,
            top: 24.h,
            child: _GlowCircle(
              size: 120.r,
              opacity: 0.13,
            ),
          ),

          /// Bottom left bubble - لازقة في حدود الكارت
          Positioned(
            left: -52.w,
            bottom: -22.h,
            child: _GlowCircle(
              size: 118.r,
              opacity: 0.11,
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(22.w, 26.h, 22.w, 24.h),
            child: Column(
              children: [
                const _AboutLogoBox(),

                SizedBox(height: 18.h),

                Text(
                  "ALEEF",
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2.2,
                  ),
                ),

                SizedBox(height: 5.h),

                Text(
                  "Pet Healthcare Platform",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.84),
                  ),
                ),

                SizedBox(height: 12.h),

                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _HeroBadge(
                          icon: Icons.favorite_rounded,
                          text: "Care",
                        ),
                        SizedBox(width: 8.w),
                        _HeroBadge(
                          icon: Icons.verified_rounded,
                          text: "Trusted",
                        ),
                        SizedBox(width: 8.w),
                        _HeroBadge(
                          icon: Icons.pets_rounded,
                          text: "Pets",
                        ),
                      ],
                    ),
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
class _AboutLogoBox extends StatelessWidget {
  const _AboutLogoBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86.r,
      width: 86.r,
      padding: EdgeInsets.all(13.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.24),
            Colors.white.withValues(alpha: 0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.32),
          width: 1.2.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 24.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Image.asset(
        AppAssets.logo,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) {
          return Icon(
            Icons.pets_rounded,
            color: Colors.white,
            size: 40.sp,
          );
        },
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  const _HeroBadge({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.16),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 13.sp,
            color: Colors.white,
          ),
          SizedBox(width: 5.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.black16Bold.copyWith(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }
}

class _TeamMemberCard extends StatelessWidget {
  final String name;

  const _TeamMemberCard({
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(name);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFA),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.07),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.95),
                  const Color(0xFF14504B),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.16),
                  blurRadius: 9.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Center(
              child: Text(
                initials,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),

          SizedBox(height: 7.h),

          Flexible(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF111827),
                fontSize: 12.3.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          SizedBox(height: 2.h),

          Text(
            "Team Member",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 10.4.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.isEmpty || parts.first.isEmpty) return "A";

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return "${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}"
        .toUpperCase();
  }
}

class _AppInfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _AppInfoRow({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 11.h),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: const Color(0xFF111827),
              fontSize: 13.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1.h,
      thickness: 1,
      color: AppColors.border.withValues(alpha: 0.65),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _GlowCircle({
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}
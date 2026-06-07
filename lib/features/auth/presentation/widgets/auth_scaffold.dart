import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import 'auth_hero_header.dart';

class AuthScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? footer;
  final double backgroundHeight;
  final double spacingAfterHero;
  final IconData backgroundIcon;
  final IconData accentIcon;

  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.footer,
    this.backgroundHeight = 300,
    this.spacingAfterHero = 24,
    this.backgroundIcon = Icons.pets_rounded,
    this.accentIcon = Icons.favorite_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Stack(
        children: [
          AuthHeroBackground(
            height: backgroundHeight,
            backgroundIcon: backgroundIcon,
            accentIcon: accentIcon,
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(22.w, 18.h, 22.w, 24.h),
              child: Column(
                children: [
                  AuthHeroContent(
                    title: title,
                    subtitle: subtitle,
                  ),
                  SizedBox(height: spacingAfterHero.h),
                  child,
                  if (footer != null) ...[
                    SizedBox(height: 18.h),
                    footer!,
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

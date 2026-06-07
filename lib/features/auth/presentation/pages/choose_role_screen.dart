import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/role_card.dart';

class ChooseRoleScreen extends StatefulWidget {
  const ChooseRoleScreen({super.key});

  @override
  State<ChooseRoleScreen> createState() => _ChooseRoleScreenState();
}

class _ChooseRoleScreenState extends State<ChooseRoleScreen> {
  String selectedRole = '';

  bool get hasSelectedRole => selectedRole.isNotEmpty;

  String get buttonText {
    if (selectedRole == 'doctor') return 'Continue as Veterinarian';
    if (selectedRole == 'owner') return 'Continue as Pet Owner';
    return 'Choose a role first';
  }

  void _handleContinue() {
    if (!hasSelectedRole) return;

    if (selectedRole == 'owner') {
      Navigator.pushNamed(
        context,
        AppRoutes.login,
      );
      return;
    }

    if (selectedRole == 'doctor') {
      Navigator.pushNamed(
        context,
        AppRoutes.doctorLogin,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: "Welcome to ALEEF",
      subtitle: "Choose your role to personalize your pet care journey.",
      backgroundHeight: 315,
      backgroundIcon: Icons.pets_rounded,
      accentIcon: Icons.favorite_rounded,
      spacingAfterHero: 24,
      child: AuthCard(
        title: "Who are you?",
        subtitle: "Select the role that matches how you’ll use ALEEF.",
        children: [
          SizedBox(height: 24.h),

          _RoleHint(
            icon: Icons.auto_awesome_rounded,
            text: "We’ll customize the app experience based on your role.",
          ),

          SizedBox(height: 22.h),

          RoleCard(
            role: 'Pet Owner',
            roleDescription:
            'I want to care for my pet, book appointments, and shop.',
            icon: LucideIcons.pawPrint,
            isSelected: selectedRole == "owner",
            onTap: () {
              setState(() {
                selectedRole = "owner";
              });
            },
          ),

          SizedBox(height: 18.h),

          RoleCard(
            role: 'Veterinarian',
            roleDescription:
            'I\'m a vet professional managing appointments and clients.',
            icon: LucideIcons.stethoscope,
            isSelected: selectedRole == "doctor",
            onTap: () {
              setState(() {
                selectedRole = "doctor";
              });
            },
          ),

          SizedBox(height: 24.h),

          AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: hasSelectedRole ? 1 : .45,
            child: AuthPrimaryButton(
              text: buttonText,
              isLoading: false,
              onPressed: hasSelectedRole ? _handleContinue : null,
            ),
          ),

          SizedBox(height: 14.h),

          Center(
            child: Text(
              "You can continue after selecting one option.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5.sp,
                height: 1.35,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleHint extends StatelessWidget {
  final IconData icon;
  final String text;

  const _RoleHint({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 11.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 30.w,
            width: 30.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 17.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.5.sp,
                height: 1.3,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
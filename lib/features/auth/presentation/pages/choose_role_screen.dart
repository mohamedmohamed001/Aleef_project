import 'package:aleef/features/auth/presentation/widgets/auth_header.dart';
import 'package:aleef/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:aleef/features/auth/presentation/widgets/role_card.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';

class ChooseRoleScreen extends StatefulWidget {
  const ChooseRoleScreen({super.key});

  @override
  State<ChooseRoleScreen> createState() => _ChooseRoleScreenState();
}

class _ChooseRoleScreenState extends State<ChooseRoleScreen> {
  String selectedRole = '';

  bool get hasSelectedRole => selectedRole.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final String buttonText = selectedRole == 'doctor'
        ? 'Continue as Veterinarian'
        : selectedRole == 'owner'
        ? 'Continue as Pet Owner'
        : 'Choose a role first';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const AuthHeader(),

              const Text(
                "Who are you?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.4,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Select your role to personalize your experience",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 28),

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

              const SizedBox(height: 22),

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

              const Spacer(),

              Opacity(
                opacity: hasSelectedRole ? 1 : .45,
                child: AuthPrimaryButton(
                  text: buttonText,
                  isLoading: false,
                  onPressed: hasSelectedRole
                      ? () {
                    if (selectedRole == 'owner') {
                      Navigator.pushNamed(context, AppRoutes.register);
                    } else if (selectedRole == 'doctor') {
                      // Navigator.pushNamed(context, AppRoutes.doctorRegister);
                    }
                  }
                      : null,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
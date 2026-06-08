import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/doctor/main_layout/doctor_main_layout.dart';
import 'package:flutter/material.dart';
import 'package:aleef/core/services/secure_storage_service.dart';
import 'package:aleef/core/services/service_locator.dart';

import 'features/main_layout/presentation/pages/main_layout.dart';
import 'features/onboarding/presentation/pages/onboarding_screen.dart';

class AppStartupScreen extends StatefulWidget {
  const AppStartupScreen({super.key});

  @override
  State<AppStartupScreen> createState() => _AppStartupScreenState();
}

class _AppStartupScreenState extends State<AppStartupScreen> {
  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    final secureStorage = getIt<SecureStorageService>();

    final userToken = await secureStorage.getToken();
    final user = await secureStorage.getUser();

    final doctorToken =
    await secureStorage.getDoctorToken();
    final doctor = await secureStorage.getDoctor();

    final hasUser =
        userToken != null &&
            userToken.isNotEmpty &&
            user != null;

    final hasDoctor =
        doctorToken != null &&
            doctorToken.isNotEmpty &&
            doctor != null;

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) {
          if (hasDoctor) {
            return const DoctorMainLayout();
          }

          if (hasUser) {
            return const MainLayout();
          }

          return const OnboardingScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}

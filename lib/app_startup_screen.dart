import 'package:aleef/core/services/session_service.dart';
import 'package:aleef/core/services/socket_service.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/doctor/main_layout/doctor_main_layout.dart';
import 'package:aleef/features/notifications/presentation/provider/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:aleef/core/services/secure_storage_service.dart';
import 'package:aleef/core/services/service_locator.dart';
import 'package:provider/provider.dart';

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
    _checkSession();
  }

  Future<void> _checkSession() async {
    final secureStorage = getIt<SecureStorageService>();

    final userToken = await secureStorage.getToken();
    final user = await secureStorage.getUser();

    final doctorToken = await secureStorage.getDoctorToken();
    final doctor = await secureStorage.getDoctor();

    final bool hasDoctor =
        doctorToken != null &&
            doctorToken.trim().isNotEmpty &&
            doctor != null;

    final bool hasUser =
        userToken != null &&
            userToken.trim().isNotEmpty &&
            user != null;

    debugPrint('========== APP STARTUP ==========');
    debugPrint('HAS DOCTOR: $hasDoctor');
    debugPrint('HAS USER: $hasUser');
    debugPrint(
      'DOCTOR TOKEN EXISTS: ${doctorToken != null && doctorToken.trim().isNotEmpty}',
    );
    debugPrint(
      'USER TOKEN EXISTS: ${userToken != null && userToken.trim().isNotEmpty}',
    );
    debugPrint('=================================');

    if (!mounted) return;

    final sessionService = context.read<SessionService>();

    Widget nextScreen;

    if (hasDoctor) {
      sessionService.setDoctorSession(
        doctor: doctor,
        doctorTokenValue: doctorToken,
      );

      await SocketService().connectCurrentSession();

      if (mounted) {
        context.read<NotificationProvider>().initSocketNotifications(context);
      }

      nextScreen = const DoctorMainLayout();
    } else if (hasUser) {
      sessionService.setSession(
        user: user,
        tokenValue: userToken,
      );

      await SocketService().connectCurrentSession();

      if (mounted) {
        context.read<NotificationProvider>().initSocketNotifications(context);
      }

      nextScreen = const MainLayout();
    } else {
      sessionService.clearAllSessions();
      SocketService().disconnect();

      nextScreen = const OnboardingScreen();
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => nextScreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}
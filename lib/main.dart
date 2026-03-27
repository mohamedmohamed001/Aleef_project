import 'package:aleef/core/routing/app_routes.dart';
import 'package:aleef/features/auth/presentation/pages/register_screen.dart';
import 'package:aleef/features/auth/presentation/pages/verfication_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/presentation/providers/verify_provider.dart';
import 'features/home/presentation/pages/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VerifyProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: LoginScreen(),
      routes: {
        AppRoutes.register: (context) => RegisterScreen(),
        AppRoutes.login: (context) => LoginScreen(),
        AppRoutes.verificationOtp: (context) => VerificationOtpScreen(),
        AppRoutes.home: (context) => HomeScreen(),
      },
    );
  }
}

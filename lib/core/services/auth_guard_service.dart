import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../exceptions/session_expired_exception.dart';
import '../routing/app_routes.dart';
import 'secure_storage_service.dart';
import 'service_locator.dart';
import 'session_service.dart';

class AuthGuardService {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static bool _isLoggingOut = false;

  static bool isSessionExpiredResponse({
    required int statusCode,
    String? body,
  }) {
    final lowerBody = body?.toLowerCase() ?? '';

    return statusCode == 401 ||
        lowerBody.contains('session expired') ||
        lowerBody.contains('unauthorized') ||
        lowerBody.contains('invalid token') ||
        lowerBody.contains('jwt expired');
  }

  static Future<void> forceLogout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    final storage = getIt<SecureStorageService>();

    final doctorToken = await storage.getDoctorToken();
    final userToken = await storage.getToken();

    final bool isDoctorSession =
        doctorToken != null && doctorToken.trim().isNotEmpty;

    final bool isUserSession = userToken != null && userToken.trim().isNotEmpty;

    if (isDoctorSession) {
      await storage.deleteDoctor();
      await storage.deleteDoctorToken();
    } else if (isUserSession) {
      await storage.deleteUser();
      await storage.deleteToken();
    } else {
      await storage.clearAll();
    }

    final context = navigatorKey.currentContext;

    if (context != null && context.mounted) {
      if (isDoctorSession) {
        context.read<SessionService>().clearDoctorSession();

        Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
          AppRoutes.doctorLogin,
              (route) => false,
        );
      } else {
        context.read<SessionService>().clearUserSession();

        Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
          AppRoutes.login,
              (route) => false,
        );
      }
    }

    _isLoggingOut = false;
  }

  static Future<void> forceUserLogout(BuildContext context) async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    final storage = getIt<SecureStorageService>();

    await storage.deleteUser();
    await storage.deleteToken();

    if (context.mounted) {
      context.read<SessionService>().clearUserSession();

      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        AppRoutes.login,
            (route) => false,
      );
    }

    _isLoggingOut = false;
  }

  static Future<void> forceDoctorLogout(BuildContext context) async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    final storage = getIt<SecureStorageService>();

    await storage.deleteDoctor();
    await storage.deleteDoctorToken();

    if (context.mounted) {
      context.read<SessionService>().clearDoctorSession();

      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        AppRoutes.doctorLogin,
            (route) => false,
      );
    }

    _isLoggingOut = false;
  }

  static Future<void> forceDoctorLogoutWithoutContext() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    final storage = getIt<SecureStorageService>();

    await storage.deleteDoctor();
    await storage.deleteDoctorToken();

    final context = navigatorKey.currentContext;

    if (context != null && context.mounted) {
      context.read<SessionService>().clearDoctorSession();

      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        AppRoutes.doctorLogin,
            (route) => false,
      );
    }

    _isLoggingOut = false;
  }

  static Future<T> runWithAutoLogout<T>(
      Future<T> Function() request,
      ) async {
    try {
      return await request();
    } on SessionExpiredException {
      await forceLogout();
      rethrow;
    }
  }

  static Future<T> runWithDoctorAutoLogout<T>(
      Future<T> Function() request,
      ) async {
    try {
      return await request();
    } on SessionExpiredException {
      await forceDoctorLogoutWithoutContext();
      rethrow;
    }
  }
}
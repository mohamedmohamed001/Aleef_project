import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routing/app_routes.dart';
import 'secure_storage_service.dart';
import 'service_locator.dart';
import 'session_service.dart';

class AuthGuardService {
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

  static Future<void> forceUserLogout(BuildContext context) async {
    final storage = getIt<SecureStorageService>();

    await storage.clearAll();

    if (!context.mounted) return;

    context.read<SessionService>().clearSession();

    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
          (route) => false,
    );
  }
}
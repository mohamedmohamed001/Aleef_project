import 'package:aleef/core/services/auth_guard_service.dart';
import 'package:flutter/material.dart';

import 'in_app_notification_banner.dart';

class InAppNotificationOverlay {
  static OverlayEntry? _currentEntry;

  static void show({
    required String title,
    required String body,
    VoidCallback? onTap,
  }) {
    debugPrint('🚀 Trying to show in-app notification');

    _currentEntry?.remove();
    _currentEntry = null;

    final overlay = AuthGuardService.navigatorKey.currentState?.overlay;

    if (overlay == null) {
      debugPrint('❌ Overlay failed: navigator overlay is null');
      return;
    }

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) {
        return Positioned(
          top: 12,
          left: 0,
          right: 0,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 280),
            tween: Tween(begin: -140, end: 0),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, value),
                child: child,
              );
            },
            child: InAppNotificationBanner(
              title: title,
              body: body,
              onTap: () {
                if (_currentEntry == entry) {
                  entry.remove();
                  _currentEntry = null;
                }
                onTap?.call();
              },
              onClose: () {
                if (_currentEntry == entry) {
                  entry.remove();
                  _currentEntry = null;
                }
              },
            ),
          ),
        );
      },
    );

    _currentEntry = entry;
    overlay.insert(entry);

    debugPrint('✅ In-app notification inserted');

    Future.delayed(const Duration(seconds: 4), () {
      if (_currentEntry == entry) {
        entry.remove();
        _currentEntry = null;
      }
    });
  }
}
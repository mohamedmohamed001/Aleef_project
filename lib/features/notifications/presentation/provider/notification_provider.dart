import 'package:flutter/material.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/services/auth_guard_service.dart';
import '../../../../core/services/socket_service.dart';
import '../../data/models/app_notification_model.dart';
import '../../data/notification_api_service.dart';
import '../widget/in_app_notification_overlay.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationApiService _apiService = NotificationApiService();

  final List<AppNotificationModel> _notifications = [];

  List<AppNotificationModel> get notifications => _notifications;

  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  bool _isLoadingCount = false;
  bool get isLoadingCount => _isLoadingCount;

  bool _isLoadingNotifications = false;
  bool get isLoadingNotifications => _isLoadingNotifications;

  bool _isListening = false;

  Future<void> getUnreadNotificationsCount() async {
    try {
      _isLoadingCount = true;
      notifyListeners();

      final count = await _apiService.getUnreadNotificationsCount();
      _unreadCount = count;
    } catch (e) {
      debugPrint("❌ Failed to get unread notifications count: $e");
      _unreadCount = 0;
    } finally {
      _isLoadingCount = false;
      notifyListeners();
    }
  }

  Future<void> getNotifications() async {
    try {
      _isLoadingNotifications = true;
      notifyListeners();

      final result = await _apiService.getNotifications();

      _notifications
        ..clear()
        ..addAll(result);

      _unreadCount = result.where((e) => !e.isRead).length;
    } catch (e) {
      debugPrint("❌ Failed to get notifications: $e");
    } finally {
      _isLoadingNotifications = false;
      notifyListeners();
    }
  }

  void initSocketNotifications(BuildContext context) {
    debugPrint("🟢 initSocketNotifications called");

    if (_isListening) {
      debugPrint("⚠️ Notification listener already active");
      return;
    }

    _isListening = true;

    SocketService().listenNotifications(
      onNotification: (data) {
        debugPrint("🔥 NotificationProvider received: $data");

        final notification = AppNotificationModel.fromSocket(data);

        _notifications.insert(0, notification);

        if (!notification.isRead) {
          _unreadCount++;
        }

        notifyListeners();

        InAppNotificationOverlay.show(
          title: notification.title,
          body: notification.body,
          onTap: () {
            final appointmentId =
                notification.data?['appointmentId'] ??
                    notification.data?['appointment_id'] ??
                    notification.data?['id'];

            if (appointmentId == null) return;

            final currentContext = AuthGuardService.navigatorKey.currentContext;
            if (currentContext == null) return;

            Navigator.pushNamed(
              currentContext,
              AppRoutes.appointmentUserDetails,
              arguments: {
                'appointmentId': appointmentId,
                'showActions': false,
              },
            );
          },
        );
      },
    );
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((e) => e.id == id);
    if (index == -1) return;

    final old = _notifications[index];

    if (!old.isRead && _unreadCount > 0) {
      _unreadCount--;
    }

    _notifications[index] = AppNotificationModel(
      id: old.id,
      type: old.type,
      title: old.title,
      body: old.body,
      isRead: true,
      createdAt: old.createdAt,
      data: old.data,
    );

    notifyListeners();
  }

  Future<void> markAllAsRead() async {
    try {
      await _apiService.markAllNotificationsAsRead();

      for (int i = 0; i < _notifications.length; i++) {
        final old = _notifications[i];

        _notifications[i] = AppNotificationModel(
          id: old.id,
          type: old.type,
          title: old.title,
          body: old.body,
          isRead: true,
          createdAt: old.createdAt,
          data: old.data,
        );
      }

      _unreadCount = 0;
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Failed to mark all notifications as read: $e");
    }
  }
  void clearUnreadCount() {
    _unreadCount = 0;
    notifyListeners();
  }

  void clear() {
    _notifications.clear();
    _unreadCount = 0;
    _isListening = false;
    notifyListeners();
  }


}
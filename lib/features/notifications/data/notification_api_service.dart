import 'dart:convert';

import 'package:aleef/core/constants/api_constant.dart';
import 'package:aleef/core/services/secure_storage_service.dart';
import 'package:aleef/core/services/service_locator.dart';
import 'package:http/http.dart' as http;

import 'models/app_notification_model.dart';

class NotificationApiService {
  Future<int> getUnreadNotificationsCount() async {
    final storage = getIt<SecureStorageService>();
    final token = await storage.getToken();

    final url = Uri.parse(
      '${ApiConstant.baseUrl}/users/get-unread-notifications-count',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['status'] == 'success') {
      return data['count'] ?? 0;
    }

    throw Exception('Failed to get unread notifications count');
  }

  Future<List<AppNotificationModel>> getNotifications() async {
    final storage = getIt<SecureStorageService>();
    final token = await storage.getToken();

    final url = Uri.parse(
      '${ApiConstant.baseUrl}/users/get-notifications',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['status'] == 'success') {
      final List notificationsJson = data['notifications'] ?? [];

      return notificationsJson
          .map((json) => AppNotificationModel.fromApi(json))
          .toList();
    }

    throw Exception('Failed to get notifications');
  }

  Future<void> markAllNotificationsAsRead() async {
    final storage = getIt<SecureStorageService>();
    final token = await storage.getToken();

    final url = Uri.parse(
      '${ApiConstant.baseUrl}/users/mark-all-notifications-as-read',
    );

    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['status'] == 'success') {
      return;
    }

    throw Exception('Failed to mark all notifications as read');
  }
}
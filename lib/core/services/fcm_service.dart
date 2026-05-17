import 'package:firebase_messaging/firebase_messaging.dart';

class FcmService {
  static final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  static Future<String?> initAndGetToken() async {
    try {
      // طلب permission
      await _messaging.requestPermission();

      // جلب التوكن
      final token = await _messaging.getToken();

      print("🔥 FCM Token: $token");

      return token;
    } catch (e) {
      print("❌ FCM Error: $e");
      return null;
    }
  }

  static void listenToTokenRefresh(Function(String) onRefresh) {
    _messaging.onTokenRefresh.listen((newToken) {
      print("🔄 New Token: $newToken");
      onRefresh(newToken);
    });
  }
}
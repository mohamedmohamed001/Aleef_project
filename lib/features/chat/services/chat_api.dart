import 'package:dio/dio.dart';

import '../../../core/constants/api_constant.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../../core/services/service_locator.dart';

final dio = Dio();
class ChatApi {
  final String baseUrl = ApiConstant.baseUrl;
  final storage = getIt<SecureStorageService>();
  Future<Map<String, dynamic>> getChats() async {
    final token = await storage.getToken();
    final response = await dio.get(
      '$baseUrl/chats',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
    final data = response.data["chats"];
    print(data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {"status": "success", "data": data};
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return {"status": "unauthorized"};
    } else {
      return {"status": "error"};
    }
  }
  Future<Map<String, dynamic>> getChatMessages(String chatId) async {
    final token = await storage.getToken();
    final response = await dio.get(
      '$baseUrl/chats/$chatId/messages',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
    final data = response.data;
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {"status": "success", "messages": data["messages"], "user": data["user"]};
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return {"status": "unauthorized"};
    } else {
      return {"status": "error"};
    }
  }

  Future<Map<String, dynamic>> getChatbotMessages() async {
    final token = await storage.getToken();
    final response = await dio.get(
      '$baseUrl/chats/chatbot',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
    final data = response.data;
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {"status": "success", "messages": data["messages"]};
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return {"status": "unauthorized"};
    } else {
      return {"status": "error"};
    }
  }
}
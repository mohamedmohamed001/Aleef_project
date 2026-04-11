import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_constant.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../../core/services/service_locator.dart';

class AppointmentApi {
  Future<int> getAvailableDoctor() async {
    print("getAvailableDoctor");
    final url = Uri.parse(
      "${ApiConstant.baseUrl}/doctors/get-available-doctors",
    );
    final storage = getIt<SecureStorageService>();
    final token = await storage.getToken();
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      final data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200) {
        return 200;
      } else if(response.statusCode == 401){
        return 401;
      }
    } catch (error) {
      return 500;
    }
    return 500;
  }
}

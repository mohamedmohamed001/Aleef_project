import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constant.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/session_service.dart';
import '../models/user_model.dart';

class AuthApiService {
  Future<bool?> login(String email, String password) async {
    final url = Uri.parse("${ApiConstant.baseUrl}/users/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final storage = getIt<SecureStorageService>();
        final session = getIt<SessionService>();

        await storage.saveToken(data['token']);

        final user = UserModel.fromJson(
          Map<String, dynamic>.from(data['user']),
        );

        await storage.saveUser(user);

        session.setSession(
          user: user,
          tokenValue: data['token'],
        );

        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool?> register(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    final url = Uri.parse(
      "${ApiConstant.baseUrl}/users/register",
    );

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
          "name": name,
          "phone": phone,
        }),
      );


      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> verifyOtp(String otp, String email) async {

    final url = Uri.parse(
      "${ApiConstant.baseUrl}/users/verify-email",
    );

    try {

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "otp": otp}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final storage = getIt<SecureStorageService>();
        final session = getIt<SessionService>();

        await storage.saveToken(data['token']);

        final user = UserModel.fromJson(
          Map<String, dynamic>.from(data['user']),
        );

        await storage.saveUser(user);

        session.setSession(
          user: user,
          tokenValue: data['token'],
        );
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool?> reSendOtp(String email) async {
    final url = Uri.parse(
      "${ApiConstant.baseUrl}/users/resend-otp",
    );
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );
      final data = jsonDecode(response.body);
    } catch (error) {
      return false;
    }
  }
  Future<bool?> logOut() async {
    final url = Uri.parse(
      "${ApiConstant.baseUrl}/users/logout",
    );
    try {
      final storage = getIt<SecureStorageService>();
      final token = await storage.getToken();
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },

      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        await storage.deleteUser();
        await storage.deleteToken();
        return true;
      } else {
        return false;
      }

    }
    catch (error) {
      return false;
    }
    return null;

  }

}

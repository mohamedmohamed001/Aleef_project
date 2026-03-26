import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthApiService {
  Future<bool?> login(String email, String password) async {
    final url = Uri.parse("https://aleef-server.vercel.app/api/v1/users/login");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      final data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.statusCode);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print(error);
    }
  }

  Future<bool?> register(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    final url = Uri.parse(
      "https://aleef-server.vercel.app/api/v1/users/register",
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
      final data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200) {
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
      "https://aleef-server.vercel.app/api/v1/users/verify-email",
    );

    try {
      print(email);
      print(otp);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "otp": otp}),
      );
      final data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}

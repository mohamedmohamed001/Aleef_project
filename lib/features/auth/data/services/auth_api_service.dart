import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/constants/api_constant.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/session_service.dart';
import '../../../../core/services/socket_service.dart';
import '../models/user_model.dart';

class AuthApiService {
  Future<bool?> login(String email, String password) async {
    final url = Uri.parse("${ApiConstant.baseUrl}/users/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final storage = getIt<SecureStorageService>();
        final session = getIt<SessionService>();

        final token = data['token'] as String;

        final user = UserModel.fromJson(
          Map<String, dynamic>.from(data['user']),
        );

        await storage.saveToken(token);
        await storage.saveUser(user);

        // مهم: لو كان فيه دكتور محفوظ قبل كده نمسحه
        await storage.clearDoctorAuthData();

        session.clearDoctorSession();
        session.setSession(
          user: user,
          tokenValue: token,
        );

        return true;
      } else {
        return false;
      }
    } catch (error) {
      debugPrint("User login error: $error");
      return false;
    }
  }

  Future<RegisterResult> register(
      String email,
      String password,
      String name,
      String phone,
      ) async {
    final url = Uri.parse("${ApiConstant.baseUrl}/users/register");

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

      final Map<String, dynamic> data = jsonDecode(response.body);

      final String message =
          data["message"]?.toString() ?? "Something went wrong";

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterResult(
          success: true,
          message: message,
        );
      } else {
        return RegisterResult(
          success: false,
          message: message,
        );
      }
    } catch (error) {
      debugPrint("User register error: $error");
      return RegisterResult(
        success: false,
        message: "Connection error, please try again",
      );
    }
  }

  Future<bool> verifyOtp(String otp, String email) async {
    final url = Uri.parse("${ApiConstant.baseUrl}/users/verify-email");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "otp": otp,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final storage = getIt<SecureStorageService>();
        final session = getIt<SessionService>();

        final token = data['token'] as String;

        final user = UserModel.fromJson(
          Map<String, dynamic>.from(data['user']),
        );

        await storage.saveToken(token);
        await storage.saveUser(user);

        await storage.clearDoctorAuthData();

        session.clearDoctorSession();
        session.setSession(
          user: user,
          tokenValue: token,
        );

        return true;
      } else {
        return false;
      }
    } catch (error) {
      debugPrint("Verify OTP error: $error");
      return false;
    }
  }

  Future<bool?> reSendOtp(String email) async {
    final url = Uri.parse("${ApiConstant.baseUrl}/users/resend-otp");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (error) {
      debugPrint("Resend OTP error: $error");
      return false;
    }
  }

  Future<bool?> logOut() async {
    final url = Uri.parse("${ApiConstant.baseUrl}/users/logout");

    try {
      final storage = getIt<SecureStorageService>();
      final session = getIt<SessionService>();

      final token = await storage.getToken();

      try {
        if (token != null && token.trim().isNotEmpty) {
          await http.post(
            url,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
          );
        }
      } catch (error) {
        debugPrint("User logout API error: $error");
      }

      // الأهم: local logout يحصل في كل الأحوال
      SocketService().disconnect();

      await storage.clearUserAuthData();

      session.clearUserSession();

      return true;
    } catch (error) {
      debugPrint("User local logout error: $error");
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    final url = Uri.parse("${ApiConstant.baseUrl}/users/google");

    try {
      final googleSignIn = GoogleSignIn(
        clientId:
        "927616168656-8jqe5h7bg6c7h4evc15di5vqndhnuu0b.apps.googleusercontent.com",
        serverClientId:
        "927616168656-skc6ratb3f46i3tfan3a2s1megpch5oc.apps.googleusercontent.com",
        forceCodeForRefreshToken: true,
        scopes: ['email', 'profile'],
      );

      await googleSignIn.signOut();

      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        debugPrint("Google user is null");
        return false;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        debugPrint("Google idToken is null");
        return false;
      }

      debugPrint("Google idToken received");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "idToken": idToken,
          "device": "mobile",
        }),
      );

      debugPrint("Google status code: ${response.statusCode}");
      debugPrint("Google response body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final storage = getIt<SecureStorageService>();
        final session = getIt<SessionService>();

        final token = data['token'] as String;

        final user = UserModel.fromJson(
          Map<String, dynamic>.from(data['user']),
        );

        await storage.saveToken(token);
        await storage.saveUser(user);

        await storage.clearDoctorAuthData();

        session.clearDoctorSession();
        session.setSession(
          user: user,
          tokenValue: token,
        );

        return true;
      } else {
        debugPrint("Google login failed: ${response.body}");
        return false;
      }
    } catch (error) {
      debugPrint("Google login error: $error");
      return false;
    }
  }


  Future<bool> addFcmToken(String fcmToken) async {
    final url = Uri.parse("${ApiConstant.baseUrl}/users/add-fcmToken");

    try {
      final storage = getIt<SecureStorageService>();
      final token = await storage.getToken();

      if (token == null || token.trim().isEmpty) {
        debugPrint("FCM Token error: user token missing");
        return false;
      }

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "fcmToken": fcmToken,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (error) {
      debugPrint("FCM Token error: $error");
      return false;
    }
  }

  Future<AuthActionResult> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse("${ApiConstant.baseUrl}/users/change-password");

    try {
      final storage = getIt<SecureStorageService>();
      final token = await storage.getToken();

      if (token == null || token.trim().isEmpty) {
        return AuthActionResult(
          success: false,
          message: "Session expired. Please login again",
        );
      }

      final response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "currentPassword": currentPassword,
          "newPassword": newPassword,
        }),
      );

      final data = _decodeResponse(response.body);

      final message = _extractMessage(
        data,
        fallback: response.statusCode == 200 || response.statusCode == 201
            ? "Password changed successfully"
            : "Failed to change password",
      );

      return AuthActionResult(
        success: response.statusCode == 200 || response.statusCode == 201,
        message: message,
      );
    } catch (error) {
      debugPrint("User change password error: $error");
      return AuthActionResult(
        success: false,
        message: "Connection error, please try again",
      );
    }
  }

  Future<AuthActionResult> forgetPassword({
    required String email,
  }) async {
    final url = Uri.parse("${ApiConstant.baseUrl}/users/forget-password");

    try {
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
        }),
      );

      final data = _decodeResponse(response.body);

      final message = _extractMessage(
        data,
        fallback: response.statusCode == 200 || response.statusCode == 201
            ? "OTP sent successfully"
            : "Failed to send OTP",
      );

      return AuthActionResult(
        success: response.statusCode == 200 || response.statusCode == 201,
        message: message,
      );
    } catch (error) {
      debugPrint("User forget password error: $error");
      return AuthActionResult(
        success: false,
        message: "Connection error, please try again",
      );
    }
  }

  Future<AuthActionResult> resetPassword({
    required String otp,
    required String newPassword,
  }) async {
    final url = Uri.parse("${ApiConstant.baseUrl}/users/reset-password");

    try {
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "otp": otp,
          "newPassword": newPassword,
        }),
      );

      final data = _decodeResponse(response.body);

      final message = _extractMessage(
        data,
        fallback: response.statusCode == 200 || response.statusCode == 201
            ? "Password reset successfully"
            : "Failed to reset password",
      );

      return AuthActionResult(
        success: response.statusCode == 200 || response.statusCode == 201,
        message: message,
      );
    } catch (error) {
      debugPrint("User reset password error: $error");
      return AuthActionResult(
        success: false,
        message: "Connection error, please try again",
      );
    }
  }

  dynamic _decodeResponse(String body) {
    try {
      if (body.trim().isEmpty) return null;
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }

  String _extractMessage(
      dynamic data, {
        required String fallback,
      }) {
    if (data == null) return fallback;

    if (data is Map<String, dynamic>) {
      if (data["message"] != null) return data["message"].toString();
      if (data["error"] != null) return data["error"].toString();
    }

    if (data is Map) {
      if (data["message"] != null) return data["message"].toString();
      if (data["error"] != null) return data["error"].toString();
    }

    if (data is String && data.trim().isNotEmpty) {
      return data;
    }

    return fallback;
  }

}

class RegisterResult {
  final bool success;
  final String message;

  RegisterResult({
    required this.success,
    required this.message,
  });
}

class AuthActionResult {
  final bool success;
  final String message;

  AuthActionResult({
    required this.success,
    required this.message,
  });
}
import 'dart:convert';
import 'dart:io';

import 'package:aleef/core/constants/api_constant.dart';
import 'package:aleef/features/appointments/data/models/doctor_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/session_service.dart';

class DoctorAuthApiService {
  final Dio _dio;
  final baseUrl = ApiConstant.baseUrl;

  DoctorAuthApiService([Dio? dio]) : _dio = dio ?? Dio();

  String _extractErrorMessage(dynamic data) {
    try {
      if (data is Map<String, dynamic>) {
        return data['message']?.toString() ??
            data['error']?.toString() ??
            data['msg']?.toString() ??
            'Something went wrong.';
      }

      return 'Something went wrong.';
    } catch (_) {
      return 'Something went wrong.';
    }
  }

  Future<bool> registerDoctor({
    required String name,
    required String email,
    required String phone,
    required String licenseNumber,
    required String city,
    required String password,
    required String address,
    required String specialization,
    required double appointmentFee,
    required File profilePic,
    required File NationalIdFront,
    required File NationalIdBack,
    required File IdentityVerificationImage,

    // Clinic location
    required double latitude,
    required double longitude,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'license_number': licenseNumber,
        'city': city,
        'address': address,
        'specialization': specialization,
        'appointmentFee': appointmentFee,

        // Clinic location
        'lat': latitude,
        'lng': longitude,

        'profilePic': await MultipartFile.fromFile(
          profilePic.path,
          filename: profilePic.path.split('/').last,
        ),
        'NationalIdFront': await MultipartFile.fromFile(
          NationalIdFront.path,
          filename: NationalIdFront.path.split('/').last,
        ),
        'NationalIdBack': await MultipartFile.fromFile(
          NationalIdBack.path,
          filename: NationalIdBack.path.split('/').last,
        ),
        'IdentityVerificationImage': await MultipartFile.fromFile(
          IdentityVerificationImage.path,
          filename: IdentityVerificationImage.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        '$baseUrl/doctors/register',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
          validateStatus: (_) => true,
        ),
      );

      debugPrint('Doctor registration status code: ${response.statusCode}');
      debugPrint('Doctor registration response body: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Doctor registration error: $e');
      return false;
    }
  }

  Future<bool> verifyEmail({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        '$baseUrl/doctors/verify-email',
        data: {
          'email': email,
          'otp': otp,
        },
        options: Options(
          validateStatus: (_) => true,
        ),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('Doctor verify email error: $e');
      return false;
    }
  }

  Future<bool?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/doctors/login',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          validateStatus: (_) => true,
        ),
      );

      debugPrint('Doctor login response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = Map<String, dynamic>.from(response.data);

        final storage = getIt<SecureStorageService>();
        final session = getIt<SessionService>();

        final token = data['token'] as String;

        final doctor = DoctorModel.fromJson(
          Map<String, dynamic>.from(data['doctor']),
        );

        await storage.saveDoctorToken(token);
        await storage.saveDoctor(doctor);

        session.setDoctorSession(
          doctor: doctor,
          doctorTokenValue: token,
        );

        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Doctor login error: $e');
      return null;
    }
  }

  // ================= DOCTOR FORGET PASSWORD =================

  Future<String?> doctorForgetPassword({
    required String email,
  }) async {
    try {
      final response = await _dio.patch(
        '$baseUrl/doctors/forget-password',
        data: {
          'email': email.trim(),
        },
        options: Options(
          validateStatus: (_) => true,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      debugPrint('Doctor forget password status: ${response.statusCode}');
      debugPrint('Doctor forget password response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return null;
      }

      return _extractErrorMessage(response.data);
    } catch (e) {
      debugPrint('Doctor forget password error: $e');
      return 'Something went wrong. Please try again.';
    }
  }

  // ================= DOCTOR RESET PASSWORD =================

  Future<String?> doctorResetPassword({
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.patch(
        '$baseUrl/doctors/reset-password',
        data: {
          'otp': otp.trim(),
          'newPassword': newPassword.trim(),
        },
        options: Options(
          validateStatus: (_) => true,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      debugPrint('Doctor reset password status: ${response.statusCode}');
      debugPrint('Doctor reset password response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return null;
      }

      return _extractErrorMessage(response.data);
    } catch (e) {
      debugPrint('Doctor reset password error: $e');
      return 'Something went wrong. Please try again.';
    }
  }

  Future<bool> addDoctorFcmToken(String fcmToken) async {
    final url = Uri.parse("${ApiConstant.baseUrl}/doctors/add-fcmToken");

    try {
      final storage = getIt<SecureStorageService>();
      final token = await storage.getDoctorToken();

      if (token == null || token.trim().isEmpty) {
        debugPrint("Doctor FCM Token error: doctor token missing");
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

      debugPrint("Doctor FCM Token status: ${response.statusCode}");
      debugPrint("Doctor FCM Token body: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (error) {
      debugPrint("Doctor FCM Token error: $error");
      return false;
    }
  }
}
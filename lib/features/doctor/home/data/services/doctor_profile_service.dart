import 'dart:convert';
import 'dart:io';

import 'package:aleef/core/constants/api_constant.dart';
import 'package:aleef/core/services/secure_storage_service.dart';
import 'package:aleef/core/services/service_locator.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../models/doctor_profile_model.dart';

class DoctorProfileService {
  String get _baseUrl => ApiConstant.baseUrl;

  static const Duration _timeoutDuration = Duration(seconds: 20);

  Map<String, String> _authHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  String _getErrorMessage(http.Response response) {
    try {
      if (response.body.trim().isEmpty) {
        return 'Request failed with status code ${response.statusCode}';
      }

      final data = json.decode(response.body);

      if (data is Map<String, dynamic>) {
        return data['message']?.toString() ??
            data['error']?.toString() ??
            data['msg']?.toString() ??
            'Request failed with status code ${response.statusCode}';
      }

      return 'Request failed with status code ${response.statusCode}';
    } catch (_) {
      return 'Request failed with status code ${response.statusCode}';
    }
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    if (response.body.trim().isEmpty) return {};

    final decoded = json.decode(response.body);

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    return {};
  }

  Future<void> _clearAllSessions() async {
    final storage = getIt<SecureStorageService>();

    await storage.deleteDoctor();
    await storage.deleteDoctorToken();

    // مهم عشان لو فيه user token قديم ميدخلكش على user app بالغلط
    await storage.deleteUser();
    await storage.deleteToken();
  }

  // ================= GET DOCTOR PROFILE =================

  Future<DoctorProfileModel> getDoctorProfile(String token) async {
    try {
      final url = Uri.parse('$_baseUrl/doctors/me');

      final response = await http
          .get(
        url,
        headers: _authHeaders(token),
      )
          .timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final responseData = _decodeResponse(response);

        final doctorData =
            responseData['doctor'] ?? responseData['data'] ?? responseData;

        if (doctorData is Map<String, dynamic>) {
          return DoctorProfileModel.fromJson(doctorData);
        }

        throw Exception('Invalid doctor profile response.');
      }

      throw Exception(_getErrorMessage(response));
    } on SocketException {
      throw Exception('No internet connection.');
    } on HttpException {
      throw Exception('Server connection failed.');
    } on FormatException {
      throw Exception('Invalid server response.');
    } catch (error) {
      throw Exception(error.toString().replaceFirst('Exception: ', ''));
    }
  }

  // ================= UPDATE DOCTOR PROFILE =================

  Future<DoctorProfileModel> updateDoctorProfile({
    required String token,
    required Map<String, String> bodyData,
    File? imageFile,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/doctors/me');

      final request = http.MultipartRequest('PATCH', url);

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      bodyData.forEach((key, value) {
        final trimmedValue = value.trim();

        if (trimmedValue.isNotEmpty) {
          request.fields[key] = trimmedValue;
        }
      });

      if (imageFile != null) {
        final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';

        request.files.add(
          await http.MultipartFile.fromPath(
            'profilePic',
            imageFile.path,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }

      final streamedResponse =
      await request.send().timeout(_timeoutDuration);

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = _decodeResponse(response);

        final doctorData =
            responseData['doctor'] ?? responseData['data'] ?? responseData;

        if (doctorData is Map<String, dynamic>) {
          return DoctorProfileModel.fromJson(doctorData);
        }

        throw Exception('Invalid updated profile response.');
      }

      throw Exception(_getErrorMessage(response));
    } on SocketException {
      throw Exception('No internet connection.');
    } on HttpException {
      throw Exception('Server connection failed.');
    } on FormatException {
      throw Exception('Invalid server response.');
    } catch (error) {
      throw Exception(error.toString().replaceFirst('Exception: ', ''));
    }
  }

  // ================= GET DOCTOR SCHEDULE =================

  Future<List<ScheduleItem>> getDoctorSchedule(String token) async {
    try {
      final url = Uri.parse('$_baseUrl/doctors/me/schedule');

      final response = await http
          .get(
        url,
        headers: _authHeaders(token),
      )
          .timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final responseData = _decodeResponse(response);

        final scheduleData =
            responseData['schedule'] ?? responseData['data'] ?? [];

        if (scheduleData is List) {
          return scheduleData
              .map((item) => ScheduleItem.fromJson(item))
              .toList();
        }

        return [];
      }

      throw Exception(_getErrorMessage(response));
    } on SocketException {
      throw Exception('No internet connection.');
    } on HttpException {
      throw Exception('Server connection failed.');
    } on FormatException {
      throw Exception('Invalid server response.');
    } catch (error) {
      throw Exception(error.toString().replaceFirst('Exception: ', ''));
    }
  }

  // ================= UPDATE DOCTOR SCHEDULE =================

  Future<List<ScheduleItem>> updateDoctorSchedule({
    required String token,
    required List<ScheduleItem> updatedSchedule,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/doctors/me/schedule');

      final response = await http
          .patch(
        url,
        headers: _authHeaders(token),
        body: json.encode({
          'schedule': updatedSchedule.map((item) => item.toJson()).toList(),
        }),
      )
          .timeout(_timeoutDuration);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = _decodeResponse(response);

        final scheduleData =
            responseData['schedule'] ?? responseData['data'] ?? [];

        if (scheduleData is List) {
          return scheduleData
              .map((item) => ScheduleItem.fromJson(item))
              .toList();
        }

        return updatedSchedule;
      }

      throw Exception(_getErrorMessage(response));
    } on SocketException {
      throw Exception('No internet connection.');
    } on HttpException {
      throw Exception('Server connection failed.');
    } on FormatException {
      throw Exception('Invalid server response.');
    } catch (error) {
      throw Exception(error.toString().replaceFirst('Exception: ', ''));
    }
  }

  // ================= CHANGE DOCTOR PASSWORD =================

  Future<bool> changePassword({
    required String token,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/doctors/change-password');

      final response = await http
          .patch(
        url,
        headers: _authHeaders(token),
        body: json.encode({
          'currentPassword': currentPassword.trim(),
          'newPassword': newPassword.trim(),
        }),
      )
          .timeout(_timeoutDuration);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return true;
      }

      throw Exception(_getErrorMessage(response));
    } on SocketException {
      throw Exception('No internet connection.');
    } on HttpException {
      throw Exception('Server connection failed.');
    } on FormatException {
      throw Exception('Invalid server response.');
    } catch (error) {
      throw Exception(error.toString().replaceFirst('Exception: ', ''));
    }
  }

  // ================= DOCTOR LOGOUT =================

  Future<bool> logOut() async {
    final storage = getIt<SecureStorageService>();
    final token = await storage.getDoctorToken();

    if (token == null || token.trim().isEmpty) {
      await _clearAllSessions();
      return true;
    }

    try {
      final url = Uri.parse('$_baseUrl/doctors/logout');

      final response = await http
          .post(
        url,
        headers: _authHeaders(token),
      )
          .timeout(_timeoutDuration);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        await _clearAllSessions();
        return true;
      }

      return false;
    } catch (_) {
      return false;
    }
  }
}
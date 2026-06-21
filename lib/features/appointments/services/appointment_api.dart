import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/api_constant.dart';
import '../../../core/exceptions/session_expired_exception.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../../core/services/service_locator.dart';
import '../data/models/previous_appointment_model.dart';

class AppointmentApi {
  final String baseUrl = ApiConstant.baseUrl;
  final SecureStorageService storage = getIt<SecureStorageService>();

  final Dio _dio = Dio();

  bool _isUnauthorized(int? statusCode) {
    return statusCode == 401 || statusCode == 403;
  }

  Map<String, String> _headers(String? token) {
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  Future<Map<String, dynamic>> getAvailableDoctor({
    int page = 1,
    int limit = 8,
    String search = "",
    double? lat,
    double? lng,
  }) async {
    try {
      final token = await storage.getToken();

      final response = await _dio.get(
        '$baseUrl/doctors/get-available-doctors',
        queryParameters: {
          "page": page,
          "limit": limit,
          if (search.trim().isNotEmpty) "search": search.trim(),
          "user_lat": ?lat,
          "user_lng": ?lng,
        },
        options: Options(headers: _headers(token)),
      );

      debugPrint("GET AVAILABLE DOCTORS URI => ${response.realUri}");

      if (_isUnauthorized(response.statusCode)) {
        throw SessionExpiredException();
      }

      if (response.statusCode == 200) {
        return {
          "status": "success",
          "data": response.data["doctors"] ?? [],
          "page": response.data["page"] ?? page,
          "totalPages": response.data["totalPages"] ?? 1,
          "totalDoctors": response.data["totalDoctors"] ?? 0,
        };
      }

      return {
        "status": "error",
        "message": response.data?["message"] ?? "Something went wrong",
      };
    } on DioException catch (e) {
      if (_isUnauthorized(e.response?.statusCode)) {
        throw SessionExpiredException();
      }

      return {
        "status": "error",
        "message": e.response?.data?["message"] ?? "Something went wrong",
      };
    } catch (e) {
      if (e is SessionExpiredException) rethrow;

      return {
        "status": "error",
        "message": "Network error, please try again",
      };
    }
  }

  Future<Map<String, dynamic>> getActiveAppointment() async {
    try {
      final token = await storage.getToken();

      final response = await _dio.get(
        '$baseUrl/appointments/get-my-active-appointment',
        options: Options(headers: _headers(token)),
      );

      if (_isUnauthorized(response.statusCode)) {
        throw SessionExpiredException();
      }

      return {
        "status": "success",
        "data": response.data["appointment"],
      };
    } on DioException catch (e) {
      if (_isUnauthorized(e.response?.statusCode)) {
        throw SessionExpiredException();
      }

      return {
        "status": "error",
        "message": e.response?.data?["message"] ?? "Something went wrong",
      };
    }
  }

  Future<Map<String, dynamic>> getDoctorDetails(String doctorId) async {
    try {
      final token = await storage.getToken();

      final response = await _dio.get(
        '$baseUrl/doctors/$doctorId',
        options: Options(headers: _headers(token)),
      );

      if (_isUnauthorized(response.statusCode)) {
        throw SessionExpiredException();
      }

      final data = response.data["doctorProfile"];

      return {
        "status": "success",
        "doctor": data?["doctor"],
        "reviews": data?["reviews"] ?? [],
      };
    } on DioException catch (e) {
      if (_isUnauthorized(e.response?.statusCode)) {
        throw SessionExpiredException();
      }

      return {
        "status": "error",
        "message": e.response?.data?["message"] ?? "Something went wrong",
      };
    }
  }

  Future<Map<String, dynamic>> getAppointmentDetails(
      String appointmentId,
      ) async {
    try {
      final token = await storage.getToken();

      final response = await _dio.get(
        '$baseUrl/appointments/$appointmentId',
        options: Options(headers: _headers(token)),
      );

      if (_isUnauthorized(response.statusCode)) {
        throw SessionExpiredException();
      }

      return {
        "status": "success",
        "data": response.data["appointment"],
      };
    } on DioException catch (e) {
      if (_isUnauthorized(e.response?.statusCode)) {
        throw SessionExpiredException();
      }

      return {
        "status": "error",
        "message": e.response?.data?["message"] ?? "Something went wrong",
      };
    }
  }

  Future<Map<String, dynamic>> getDoctorSchedule(String doctorId) async {
    try {
      final token = await storage.getToken();

      final response = await _dio.get(
        '$baseUrl/doctors/$doctorId/schedual',
        options: Options(headers: _headers(token)),
      );

      if (_isUnauthorized(response.statusCode)) {
        throw SessionExpiredException();
      }

      return {
        "status": "success",
        "data": response.data,
      };
    } on DioException catch (e) {
      if (_isUnauthorized(e.response?.statusCode)) {
        throw SessionExpiredException();
      }

      return {
        "status": "error",
        "message": e.response?.data?["message"] ?? e.message,
      };
    }
  }

  Future<Map<String, dynamic>> getDoctorSlotsByDate({
    required String doctorId,
    required String date,
  }) async {
    try {
      final token = await storage.getToken();

      final response = await _dio.get(
        '$baseUrl/doctors/$doctorId/slots',
        queryParameters: {
          "date": date,
        },
        options: Options(headers: _headers(token)),
      );

      debugPrint("GET DOCTOR SLOTS RESPONSE => ${response.data}");

      if (_isUnauthorized(response.statusCode)) {
        throw SessionExpiredException();
      }

      return {
        "status": "success",
        "date": response.data["slots"]?["date"],
        "slots": List<String>.from(
          response.data["slots"]?["slots"] ?? [],
        ),
      };
    } on DioException catch (e) {
      if (_isUnauthorized(e.response?.statusCode)) {
        throw SessionExpiredException();
      }

      return {
        "status": "error",
        "message": e.response?.data?["message"] ?? "Something went wrong",
      };
    } catch (e) {
      if (e is SessionExpiredException) rethrow;

      return {
        "status": "error",
        "message": "Network error, please try again",
      };
    }
  }

  Future<Map<String, dynamic>> getPets() async {
    try {
      final token = await storage.getToken();

      final response = await _dio.get(
        '$baseUrl/pets/get-my-pets',
        options: Options(headers: _headers(token)),
      );

      if (_isUnauthorized(response.statusCode)) {
        throw SessionExpiredException();
      }

      return {
        "status": "success",
        "data": response.data["pets"] ?? [],
      };
    } on DioException catch (e) {
      if (_isUnauthorized(e.response?.statusCode)) {
        throw SessionExpiredException();
      }

      return {
        "status": "error",
        "message": e.response?.data?["message"] ?? "Something went wrong",
      };
    }
  }

  Future<Map<String, dynamic>> bookAppointment(
      String pet,
      String doctor,
      String date,
      String time,
      String reason,
      String? notes,
      ) async {
    try {
      final token = await storage.getToken();

      final response = await _dio.post(
        '$baseUrl/appointments',
        data: {
          "pet": pet,
          "doctor": doctor,
          "date": date,
          "time": time,
          "reason": reason,
          "notes": notes ?? "",
        },
        options: Options(headers: _headers(token)),
      );

      if (_isUnauthorized(response.statusCode)) {
        throw SessionExpiredException();
      }

      return {
        "status": "success",
        "data": response.data,
      };
    } on DioException catch (e) {
      if (_isUnauthorized(e.response?.statusCode)) {
        throw SessionExpiredException();
      }

      return {
        "status": "error",
        "message": e.response?.data?["message"] ?? "Something went wrong",
      };
    } catch (e) {
      if (e is SessionExpiredException) rethrow;

      return {
        "status": "error",
        "message": "Network error, please try again",
      };
    }
  }

  Future<Map<String, dynamic>> getPreviousAppointments() async {
    try {
      final token = await storage.getToken();

      final response = await _dio.get(
        '$baseUrl/appointments/get-my-previous-appointments',
        options: Options(headers: _headers(token)),
      );

      if (_isUnauthorized(response.statusCode)) {
        throw SessionExpiredException();
      }

      final List data = response.data["appointments"] ?? [];

      final appointments = data
          .map<PreviousAppointmentModel>(
            (e) => PreviousAppointmentModel.fromJson(e),
      )
          .toList();

      return {
        "status": "success",
        "data": appointments,
      };
    } on DioException catch (e) {
      if (_isUnauthorized(e.response?.statusCode)) {
        throw SessionExpiredException();
      }

      return {
        "status": "error",
        "message": e.response?.data?["message"] ?? "Something went wrong",
      };
    } catch (e) {
      if (e is SessionExpiredException) rethrow;

      return {
        "status": "error",
        "message": "Something went wrong",
      };
    }
  }

  Future<Map<String, dynamic>> cancelAppointment(
      String appointmentId,
      String reason,
      ) async {
    try {
      final token = await storage.getToken();

      final response = await _dio.patch(
        '$baseUrl/appointments/cancel-appointment-by-user/$appointmentId',
        data: {
          "reason": reason,
        },
        options: Options(headers: _headers(token)),
      );

      if (_isUnauthorized(response.statusCode)) {
        throw SessionExpiredException();
      }

      return {
        "status": "success",
        "data": response.data,
      };
    } on DioException catch (e) {
      if (_isUnauthorized(e.response?.statusCode)) {
        throw SessionExpiredException();
      }

      return {
        "status": "error",
        "message": e.response?.data?["message"] ?? "Something went wrong",
      };
    } catch (e) {
      if (e is SessionExpiredException) rethrow;

      return {
        "status": "error",
        "message": "Network error, please try again",
      };
    }
  }

  Future<Map<String, dynamic>> checkPendingReview() async {
    try {
      final token = await storage.getToken();

      final response = await _dio.get(
        '$baseUrl/appointments/check-pending-review',
        options: Options(headers: _headers(token)),
      );

      if (_isUnauthorized(response.statusCode)) {
        throw SessionExpiredException();
      }

      return {
        "status": "success",
        "data": response.data["pendingReview"],
      };
    } on DioException catch (e) {
      if (_isUnauthorized(e.response?.statusCode)) {
        throw SessionExpiredException();
      }

      return {
        "status": "error",
        "message": e.response?.data?["message"] ?? "Something went wrong",
      };
    }
  }

  Future<Map<String, dynamic>> addReview({
    required String appointmentId,
    required int rate,
    required String comment,
  }) async {
    try {
      final token = await storage.getToken();

      final response = await _dio.post(
        '$baseUrl/appointments/add-review/$appointmentId',
        data: {
          "rate": rate,
          "comment": comment,
        },
        options: Options(headers: _headers(token)),
      );

      if (_isUnauthorized(response.statusCode)) {
        throw SessionExpiredException();
      }

      return {
        "status": "success",
        "data": response.data,
      };
    } on DioException catch (e) {
      if (_isUnauthorized(e.response?.statusCode)) {
        throw SessionExpiredException();
      }

      return {
        "status": "error",
        "message": e.response?.data?["message"] ?? "Something went wrong",
      };
    }
  }

  Future<Map<String, dynamic>> skipReview({
    required String appointmentId,
  }) async {
    try {
      final token = await storage.getToken();

      final response = await _dio.post(
        '$baseUrl/appointments/skip-review/$appointmentId',
        options: Options(headers: _headers(token)),
      );

      if (_isUnauthorized(response.statusCode)) {
        throw SessionExpiredException();
      }

      return {
        "status": "success",
        "data": response.data,
      };
    } on DioException catch (e) {
      if (_isUnauthorized(e.response?.statusCode)) {
        throw SessionExpiredException();
      }

      return {
        "status": "error",
        "message": e.response?.data?["message"] ?? "Something went wrong",
      };
    }
  }
}
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_constant.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../../core/services/service_locator.dart';
import 'package:dio/dio.dart';

final dio = Dio();

class AppointmentApi {
  final String baseUrl = ApiConstant.baseUrl;
  final storage = getIt<SecureStorageService>();

  Future<Map<String, dynamic>> getAvailableDoctor() async {
    final url = Uri.parse(
      "${ApiConstant.baseUrl}/doctors/get-available-doctors",
    );

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

      if (response.statusCode == 200) {
        return {"status": "success", "data": data["doctors"]};
      } else if (response.statusCode == 401) {
        return {"status": "unauthorized"};
      } else {
        return {"status": "error"};
      }
    } catch (error) {
      return {"status": "error"};
    }
  }

  Future<Map<String, dynamic>> getActiveAppointment() async {
    final token = await storage.getToken();
    final response = await dio.get(
      '$baseUrl/appointments/get-my-active-appointment',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
    final data = response.data["appointment"];
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {"status": "success", "data": data};
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return {"status": "unauthorized"};
    } else {
      return {"status": "error"};
    }
  }

  Future<Map<String, dynamic>> getDoctorDetails(String doctorId) async {
    final token = await storage.getToken();
    final response = await dio.get(
      '$baseUrl/doctors/$doctorId',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
    final data = response.data["doctorProfile"];
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        "status": "success",
        "doctor": data["doctor"],
        "reviews": data["reviews"],
      };
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return {"status": "unauthorized"};
    } else {
      return {"status": "error"};
    }
  }

  Future<Map<String, dynamic>> getAppointmentDetails(
    String appointmentId,
  ) async {
    final token = await storage.getToken();
    final response = await dio.get(
      "$baseUrl/appointments/$appointmentId",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
    final data = response.data["appointment"];
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {"status": "success", "data": data};
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return {"status": "unauthorized"};
    } else {
      return {"status": "error"};
    }
  }

  Future<Map<String, dynamic>> getDoctorSchedule(String doctorId) async {
    try {
      final token = await storage.getToken();

      final response = await dio.get(
        '$baseUrl/doctors/$doctorId/schedual',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final data = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "status": "success",
          "data": data,
        };
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return {
          "status": "unauthorized",
        };
      } else {
        return {
          "status": "error",
        };
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        return {
          "status": "unauthorized",
        };
      }

      return {
        "status": "error",
        "message": e.response?.data?["message"] ?? e.message,
      };
    } catch (e) {
      return {
        "status": "error",
        "message": e.toString(),
      };
    }
  }
}

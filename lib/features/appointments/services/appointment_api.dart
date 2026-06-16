import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_constant.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../../core/services/service_locator.dart';
import 'package:dio/dio.dart';

import '../data/models/previous_appointment_model.dart';

final dio = Dio();

class AppointmentApi {
  final String baseUrl = ApiConstant.baseUrl;
  final storage = getIt<SecureStorageService>();

  Future<Map<String, dynamic>> getAvailableDoctor({
    int page = 1,
    int limit = 8,
    String search = "",
  }) async {
    final token = await storage.getToken();

    final uri = Uri.parse(
      "$baseUrl/doctors/get-available-doctors",
    ).replace(
      queryParameters: {
        "page": page.toString(),
        "limit": limit.toString(),
        if (search.trim().isNotEmpty) "search": search.trim(),
      },
    );

    try {
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          "status": "success",
          "data": data["doctors"] ?? [],
          "page": data["page"] ?? page,
          "totalPages": data["totalPages"] ?? 1,
          "totalDoctors": data["totalDoctors"] ?? 0,
        };
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return {"status": "unauthorized"};
      } else {
        return {"status": "error", "message": data["message"]};
      }
    } catch (error) {
      return {"status": "error", "message": error.toString()};
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
        return {"status": "success", "data": data};
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return {"status": "unauthorized"};
      } else {
        return {"status": "error"};
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        return {"status": "unauthorized"};
      }

      return {
        "status": "error",
        "message": e.response?.data?["message"] ?? e.message,
      };
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getPets() async {
    final token = await storage.getToken();
    final response = await dio.get(
      '$baseUrl/pets/get-my-pets',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
    try {
      final data = response.data["pets"];

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {"status": "success", "data": data};
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return {"status": "unauthorized"};
      } else {
        return {"status": "error"};
      }
    } catch (e) {
      return {"status": "error"};
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

      final response = await dio.post(
        '$baseUrl/appointments',
        data: {
          "pet": pet,
          "doctor": doctor,
          "date": date,
          "time": time,
          "reason": reason,
          "notes": notes ?? "",
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final data = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {"status": "success", "data": data};
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return {"status": "unauthorized"};
      } else {
        return {
          "status": "error",
          "message": data["message"] ?? "Something went wrong",
        };
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        return {"status": "unauthorized"};
      }

      return {
        "status": "error",
        "message": e.response?.data?["message"] ?? "Something went wrong",
      };
    } catch (e) {
      return {"status": "error", "message": "Network error, please try again"};
    }
  }

  Future<Map<String, dynamic>> getPreviousAppointments() async {
    try {
      final token = await storage.getToken();

      final response = await dio.get(
        '$baseUrl/appointments/get-my-previous-appointments',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final List data = response.data["appointments"] ?? [];

      if (response.statusCode == 200 || response.statusCode == 201) {
        final appointments = data
            .map<PreviousAppointmentModel>(
              (e) => PreviousAppointmentModel.fromJson(e),
            )
            .toList();

        return {"status": "success", "data": appointments};
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return {"status": "unauthorized"};
      } else {
        return {"status": "error"};
      }
    } catch (e) {
      return {"status": "error"};
    }
  }

  Future<Map<String, dynamic>> cancelAppointment(String appointmentId, String reason,) async {
    try {
      final token = await storage.getToken();

      final response = await dio.patch(
        '$baseUrl/appointments/cancel-appointment-by-user/$appointmentId',
        data: {
          "reason": reason,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final data = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {"status": "success", "data": data};
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return {"status": "unauthorized"};
      } else {
        return {
          "status": "error",
          "message": data["message"] ?? "Something went wrong",
        };
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        return {"status": "unauthorized"};
      }

      return {
        "status": "error",
        "message": e.response?.data?["message"] ?? "Something went wrong",
      };
    } catch (e) {
      return {"status": "error", "message": "Network error, please try again"};
    }
  }
}

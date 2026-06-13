import 'package:dio/dio.dart';
import 'package:aleef/core/constants/api_constant.dart';
import 'package:aleef/core/services/secure_storage_service.dart';
import 'package:aleef/core/services/service_locator.dart';

class ActiveAppointmentsApiService {
  final SecureStorageService _storage = getIt<SecureStorageService>();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstant.baseUrl,
      headers: {'Accept': 'application/json'},
    ),
  );

  // 1. Get active appointments for a specific date
  Future<Map<String, dynamic>> getActiveAppointments({
    required String date,
  }) async {
    try {
      final token = await _storage.getDoctorToken();

      final response = await _dio.get(
        '/appointments/active-appointments',
        queryParameters: {'date': date},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return {'status': 'success', 'data': response.data};
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // 1.1 Get all active appointments (بدون تمرير تاريخ)
  Future<Map<String, dynamic>> getAllAppointments() async {
    try {
      final token = await _storage.getDoctorToken();

      final response = await _dio.get(
        '/appointments/active-appointments',
        // لاحظي أننا حذفنا الـ queryParameters هنا
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return {'status': 'success', 'data': response.data};
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // 2. Get details of a specific appointment
  Future<Map<String, dynamic>> getAppointmentDetails({
    required String appointmentId,
  }) async {
    try {
      final token = await _storage.getDoctorToken();

      final response = await _dio.get(
        '/appointments/$appointmentId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return {'status': 'success', 'data': response.data};
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // 3. End appointment (PATCH) with attachments
  Future<Map<String, dynamic>> endAppointment({
    required String appointmentId,
    required FormData formData,
  }) async {
    try {
      final token = await _storage.getDoctorToken();

      final response = await _dio.patch(
        '/appointments/end-appointment/$appointmentId',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return {'status': 'success', 'data': response.data};
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Standardized error handling
  Map<String, dynamic> _handleError(DioException e) {
    final responseData = e.response?.data;
    return {
      'status': 'error',
      'message': responseData is Map<String, dynamic>
          ? responseData['message'] ?? 'An unexpected error occurred'
          : 'Connection error occurred',
    };
  }
}

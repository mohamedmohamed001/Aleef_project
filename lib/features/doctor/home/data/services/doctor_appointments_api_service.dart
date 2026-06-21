import 'package:aleef/core/constants/api_constant.dart';
import 'package:aleef/core/services/secure_storage_service.dart';
import 'package:aleef/core/services/service_locator.dart';
import 'package:dio/dio.dart';

class DoctorAppointmentsApiService {
  final SecureStorageService _storage = getIt<SecureStorageService>();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstant.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Future<Map<String, dynamic>> getAppointmentRequests() async {
    try {
      final token = await _storage.getDoctorToken();

      if (token == null || token.isEmpty) {
        return {
          'status': 'unauthorized',
          'message': 'Doctor token not found',
        };
      }

      final response = await _dio.get(
        '/appointments/requests',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return {
        'status': 'success',
        'data': response.data,
      };
    } on DioException catch (e) {
      return _handleError(e, 'Failed to load appointment requests');
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Unexpected error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> acceptAppointment({
    required String appointmentId,
  }) async {
    try {
      final token = await _storage.getDoctorToken();

      if (token == null || token.isEmpty) {
        return {
          'status': 'unauthorized',
          'message': 'Doctor token not found',
        };
      }

      final response = await _dio.post(
        '/appointments/approve-appointment/$appointmentId/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return {
        'status': 'success',
        'data': response.data,
      };
    } on DioException catch (e) {
      return _handleError(e, 'Failed to accept appointment');
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Unexpected error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> rejectAppointment({
    required String appointmentId,
    required String rejectionReason,
  }) async {
    try {
      final token = await _storage.getDoctorToken();

      if (token == null || token.isEmpty) {
        return {
          'status': 'unauthorized',
          'message': 'Doctor token not found',
        };
      }

      final response = await _dio.post(
        '/appointments/reject-appointment/$appointmentId',
        data: {
          'rejectionReason': rejectionReason,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return {
        'status': 'success',
        'data': response.data,
      };
    } on DioException catch (e) {
      return _handleError(e, 'Failed to reject appointment');
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Unexpected error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getAppointmentDetails({
    required String appointmentId,
  }) async {
    try {
      final token = await _storage.getDoctorToken();

      if (token == null || token.isEmpty) {
        return {
          'status': 'unauthorized',
          'message': 'Doctor token not found',
        };
      }

      final response = await _dio.get(
        '/appointments/$appointmentId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return {
        'status': 'success',
        'data': response.data,
      };
    } on DioException catch (e) {
      return _handleError(e, 'Failed to load appointment details');
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Unexpected error: $e',
      };
    }
  }

  Map<String, dynamic> _handleError(DioException e, String fallbackMessage) {
    final statusCode = e.response?.statusCode;
    final responseData = e.response?.data;

    if (statusCode == 401 || statusCode == 403) {
      return {
        'status': 'unauthorized',
        'message': responseData is Map<String, dynamic>
            ? responseData['message'] ?? 'Unauthorized'
            : 'Unauthorized',
      };
    }

    return {
      'status': 'error',
      'message': responseData is Map<String, dynamic>
          ? responseData['message'] ?? fallbackMessage
          : fallbackMessage,
    };
  }
}
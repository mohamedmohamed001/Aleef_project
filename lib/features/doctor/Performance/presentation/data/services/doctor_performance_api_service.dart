import 'package:dio/dio.dart';

import '../../../../../../core/constants/api_constant.dart';
import '../../../../../../core/services/secure_storage_service.dart';


class DoctorPerformanceApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstant.baseUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<Map<String, dynamic>> getDoctorPerformance() async {
    try {
      final token = await SecureStorageService().getDoctorToken();

      final response = await _dio.get(
        '/appointments/doctor-performance',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      return {
        'status': 'error',
        'message': e.response?.data['message'] ?? 'Something went wrong',
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Unexpected error',
      };
    }
  }
}
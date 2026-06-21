import 'package:aleef/core/constants/api_constant.dart';
import 'package:aleef/core/services/secure_storage_service.dart';
import 'package:dio/dio.dart';

class AppointmentManagementService {
  final Dio _dio;

  AppointmentManagementService(this._dio);

  Future<Map<String, dynamic>> endAppointment({
    required String appointmentId,
    required FormData formData,
  }) async {
    try {
      final storage = SecureStorageService();
      final token = await storage.getDoctorToken();

      if (token == null || token.toString().isEmpty) {
        return {
          "status": "error",
          "message": "Doctor token not found",
        };
      }

      final response = await _dio.patch(
        "${ApiConstant.baseUrl}/appointments/end-appointment/$appointmentId",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      return {
        "status": "success",
        "data": response.data,
      };
    } on DioException catch (e) {
      final responseData = e.response?.data;

      String message = "حدث خطأ غير متوقع";

      if (responseData is Map<String, dynamic>) {
        message = responseData["message"]?.toString() ??
            responseData["error"]?.toString() ??
            message;
      } else if (responseData != null) {
        message = responseData.toString();
      }

      return {
        "status": "error",
        "message": message,
      };
    } catch (e) {
      return {
        "status": "error",
        "message": e.toString().replaceAll("Exception:", "").trim(),
      };
    }
  }
}
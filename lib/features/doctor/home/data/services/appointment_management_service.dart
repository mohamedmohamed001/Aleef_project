import 'package:aleef/core/constants/api_constant.dart';
import 'package:dio/dio.dart';
 // افترضي وجود ملف للـ BaseUrl

class AppointmentManagementService {
  final Dio _dio;

  // نقوم باستقبال Dio في الكونستركتور (يفضل حقنها عبر GetIt)
  AppointmentManagementService(this._dio);

  Future<Map<String, dynamic>> endAppointment({
    required String appointmentId,
    required FormData formData,
  }) async {
    try {
      // تنفيذ الـ PATCH Request
      final response = await _dio.patch(
        "${ApiConstant.baseUrl}/appointments/end-appointment/$appointmentId",
        data: formData,
      );

      // إرجاع النتيجة
      return {
        "status": "success",
        "data": response.data,
      };
    } on DioException catch (e) {
      // معالجة الأخطاء
      return {
        "status": "error",
        "message": e.response?.data['message'] ?? "حدث خطأ غير متوقع",
      };
    }
  }
}
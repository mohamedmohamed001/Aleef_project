import 'package:aleef/features/doctor/home/data/models/End_Appointment_Request_Model.dart';
import 'package:aleef/features/doctor/home/data/services/appointment_management_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AppointmentManagementProvider extends ChangeNotifier {
  final AppointmentManagementService _managementService =
  GetIt.I<AppointmentManagementService>();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String _cleanError(Object error) {
    if (error is DioException) {
      final responseData = error.response?.data;

      if (responseData is Map<String, dynamic>) {
        return responseData['message']?.toString() ??
            responseData['error']?.toString() ??
            error.message ??
            'Something went wrong.';
      }

      return error.message ?? 'Something went wrong.';
    }

    return error.toString().replaceAll('Exception:', '').trim();
  }

  Future<bool> endAppointment({
    required String appointmentId,
    required EndAppointmentRequestModel requestModel,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final Map<String, dynamic> data = requestModel.toFormDataMap();

      final formData = FormData.fromMap(data);

      if (requestModel.attachments != null &&
          requestModel.attachments!.isNotEmpty) {
        for (final file in requestModel.attachments!) {
          formData.files.add(
            MapEntry(
              'attachments',
              await MultipartFile.fromFile(
                file.path,
                filename: file.path.split('/').last,
              ),
            ),
          );
        }
      }

      debugPrint('========== END APPOINTMENT FORM DATA ==========');
      debugPrint('Appointment ID: $appointmentId');

      for (final field in formData.fields) {
        debugPrint('${field.key}: ${field.value}');
      }

      for (final file in formData.files) {
        debugPrint('${file.key}: ${file.value.filename}');
      }

      debugPrint('==============================================');

      final result = await _managementService.endAppointment(
        appointmentId: appointmentId,
        formData: formData,
      );

      final bool success = result['status'] == 'success';

      if (!success) {
        _errorMessage =
            result['message']?.toString() ?? 'Failed to complete appointment.';
      }

      return success;
    } catch (e) {
      _errorMessage = _cleanError(e);
      debugPrint('Error in endAppointment: $_errorMessage');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
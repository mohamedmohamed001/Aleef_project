import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:aleef/features/doctor/home/data/models/confirmed_appointment_model.dart';
import 'package:aleef/features/doctor/home/data/services/active_appointments_api_service.dart';

class DoctorConfirmedAppointmentsProvider extends ChangeNotifier {
  // حقن السيرفيس بدلاً من إنشاء Dio مباشرة
  final ActiveAppointmentsApiService _apiService =
      GetIt.I<ActiveAppointmentsApiService>();

  List<ConfirmedAppointmentModel> _appointments = [];
  bool _isLoading = false;

  List<ConfirmedAppointmentModel> get appointments => _appointments;
  bool get isLoading => _isLoading;

  // جلب المواعيد
  Future<void> getAppointmentsByDate(String date) async {
    _isLoading = true;
    notifyListeners();

    Map<String, dynamic> result;

    // استخدام المنطق الصحيح بناءً على الاختيار
    if (date == "All Appointments") {
      result = await _apiService.getAllAppointments();
    } else {
      result = await _apiService.getActiveAppointments(date: date);
    }
    print("API Response:${result['data']}");

    if (result['status'] == 'success') {
      _appointments = (result['data']['appointments'] as List)
          .map((e) => ConfirmedAppointmentModel.fromJson(e))
          .toList();
    } else {
      _appointments = [];
      debugPrint("Error: ${result['message']}");
    }

    _isLoading = false;
    notifyListeners();
  }

  // إنهاء الموعد
  Future<bool> endAppointment(
    String appointmentId,
    Map<String, dynamic> data,
    File? file,
  ) async {
    _isLoading = true;
    notifyListeners();

    // تجهيز الـ FormData هنا في البروفايدر
    FormData formData = FormData.fromMap(data);
    if (file != null) {
      formData.files.add(
        MapEntry(
          "attachments",
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ),
      );
    }

    // استدعاء السيرفيس
    final result = await _apiService.endAppointment(
      appointmentId: appointmentId,
      formData: formData,
    );

    _isLoading = false;
    notifyListeners();

    return result['status'] == 'success';
  }
}

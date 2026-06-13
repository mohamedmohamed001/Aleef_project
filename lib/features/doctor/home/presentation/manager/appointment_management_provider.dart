import 'dart:convert';
import 'dart:io';
import 'package:aleef/features/doctor/home/data/models/End_Appointment_Request_Model.dart';
import 'package:aleef/features/doctor/home/data/services/appointment_management_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AppointmentManagementProvider extends ChangeNotifier {
  // نقوم بحقن السيرفيس الخاصة بالإدارة
  final AppointmentManagementService _managementService =
      GetIt.I<AppointmentManagementService>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> endAppointment({
    required String appointmentId,
    required EndAppointmentRequestModel requestModel,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. تحويل الموديل إلى Map
      Map<String, dynamic> data = requestModel.toJson();

      // 2. تجهيز الـ FormData (مع مراعاة تحويل الـ Objects لـ JSON Strings)
      // في البروفايدر
      FormData formData = FormData.fromMap({
        "medicalRecord": jsonEncode(data['medicalRecord']),
      });

      // إضافة التطعيم فقط إذا كان موجوداً (لن يرسل null)
      if (requestModel.vaccination != null) {
        formData.fields.add(
          MapEntry(
            "vaccination",
            jsonEncode(requestModel.vaccination!.toJson()),
          ),
        );
      }

      // إضافة التطعيم القادم فقط إذا كان موجوداً
      if (requestModel.upComingVaccination != null) {
        formData.fields.add(
          MapEntry(
            "upComingVaccination",
            jsonEncode(requestModel.upComingVaccination!.toJson()),
          ),
        );
      }

      // 3. إضافة المرفقات (Attachments) إذا وجدت
      if (requestModel.attachments != null &&
          requestModel.attachments!.isNotEmpty) {
        for (var file in requestModel.attachments!) {
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
      }

      // 4. استدعاء السيرفيس لإرسال الطلب
      final result = await _managementService.endAppointment(
        appointmentId: appointmentId,
        formData: formData,
      );

      _isLoading = false;
      notifyListeners();

      // إرجاع النتيجة
      return result['status'] == 'success';
    } catch (e) {
      debugPrint("Error in endAppointment: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

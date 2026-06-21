import 'dart:io';

import 'package:aleef/features/doctor/home/data/models/confirmed_appointment_model.dart';
import 'package:aleef/features/doctor/home/data/services/active_appointments_api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class DoctorConfirmedAppointmentsProvider extends ChangeNotifier {
  final ActiveAppointmentsApiService _apiService =
  GetIt.I<ActiveAppointmentsApiService>();

  List<ConfirmedAppointmentModel> _appointments = [];

  bool _isLoading = false;
  bool _isEndingAppointment = false;

  String _lastSelectedDate = 'All Appointments';

  List<ConfirmedAppointmentModel> get appointments => _appointments;
  bool get isLoading => _isLoading;
  bool get isEndingAppointment => _isEndingAppointment;

  Future<void> getAppointmentsByDate(String date) async {
    _lastSelectedDate = date;

    _isLoading = true;
    notifyListeners();

    try {
      final Map<String, dynamic> result;

      if (date == "All Appointments") {
        result = await _apiService.getAllAppointments();
      } else {
        result = await _apiService.getActiveAppointments(date: date);
      }

      debugPrint("CONFIRMED APPOINTMENTS API RESPONSE => ${result['data']}");

      if (result['status'] == 'success') {
        final data = result['data'];

        final appointmentsList = data is Map<String, dynamic>
            ? data['appointments'] as List? ?? []
            : [];

        _appointments = appointmentsList
            .map(
              (e) => ConfirmedAppointmentModel.fromJson(
            Map<String, dynamic>.from(e),
          ),
        )
            .toList();
      } else {
        _appointments = [];
        debugPrint("Confirmed appointments error: ${result['message']}");
      }
    } catch (e) {
      _appointments = [];
      debugPrint("Confirmed appointments exception: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshCurrentAppointments() async {
    await getAppointmentsByDate(_lastSelectedDate);
  }

  Future<bool> endAppointment(
      String appointmentId,
      Map<String, dynamic> data,
      File? file,
      ) async {
    if (_isEndingAppointment) return false;

    _isEndingAppointment = true;
    notifyListeners();

    try {
      final formData = FormData.fromMap(data);

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

      final result = await _apiService.endAppointment(
        appointmentId: appointmentId,
        formData: formData,
      );

      final success = result['status'] == 'success';

      if (success) {
        _appointments.removeWhere(
              (appointment) => appointment.id == appointmentId,
        );

        notifyListeners();

        refreshCurrentAppointments();
      }

      return success;
    } catch (e) {
      debugPrint("End appointment exception: $e");
      return false;
    } finally {
      _isEndingAppointment = false;
      notifyListeners();
    }
  }

  void removeAppointmentLocally(String appointmentId) {
    _appointments.removeWhere(
          (appointment) => appointment.id == appointmentId,
    );
    notifyListeners();
  }

  void clearConfirmedAppointments() {
    _appointments = [];
    _isLoading = false;
    _isEndingAppointment = false;
    notifyListeners();
  }
}
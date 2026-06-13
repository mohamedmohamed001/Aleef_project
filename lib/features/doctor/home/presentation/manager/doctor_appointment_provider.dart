import 'package:flutter/material.dart';

import '../../data/models/appointment_details_model.dart';
import '../../data/models/appointment_request_model.dart';
import '../../data/services/doctor_appointments_api_service.dart';

class DoctorAppointmentsProvider extends ChangeNotifier {
  final DoctorAppointmentsApiService _apiService =
  DoctorAppointmentsApiService();

  List<AppointmentRequestModel> appointmentRequests = [];

  AppointmentDetailsModel? appointmentDetails;

  bool isLoading = false;
  bool isDetailsLoading = false;

  String? errorMessage;
  String? detailsErrorMessage;

  final Set<String> _loadingAppointmentIds = {};

  int get requestsCount => appointmentRequests.length;

  bool isAppointmentLoading(String appointmentId) {
    return _loadingAppointmentIds.contains(appointmentId);
  }

  Future<void> getAppointmentRequests() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.getAppointmentRequests();

      if (result['status'] == 'success') {
        final response = AppointmentRequestsResponse.fromJson(
          result['data'] as Map<String, dynamic>,
        );

        appointmentRequests = response.appointments;
      } else {
        appointmentRequests = [];
        errorMessage = result['message'] ?? 'Something went wrong';
      }
    } catch (e) {
      appointmentRequests = [];
      errorMessage = 'Failed to load appointment requests';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAppointmentDetails(String appointmentId) async {
    isDetailsLoading = true;
    detailsErrorMessage = null;
    appointmentDetails = null;
    notifyListeners();

    try {
      final result = await _apiService.getAppointmentDetails(
        appointmentId: appointmentId,
      );

      if (result['status'] == 'success') {
        final data = result['data'] as Map<String, dynamic>;

        appointmentDetails = AppointmentDetailsModel.fromJson(
          data['appointment'] as Map<String, dynamic>,
        );
      } else {
        detailsErrorMessage = result['message'] ?? 'Something went wrong';
      }
    } catch (e) {
      detailsErrorMessage = 'Failed to load appointment details';
    } finally {
      isDetailsLoading = false;
      notifyListeners();
    }
  }

  Future<String?> acceptAppointment(String appointmentId) async {
    if (_loadingAppointmentIds.contains(appointmentId)) {
      return null;
    }

    _loadingAppointmentIds.add(appointmentId);
    notifyListeners();

    try {
      final result = await _apiService.acceptAppointment(
        appointmentId: appointmentId,
      );

      if (result['status'] == 'success') {
        appointmentRequests.removeWhere(
              (appointment) => appointment.id == appointmentId,
        );

        return null;
      }

      return result['message'] ?? 'Failed to accept appointment';
    } catch (e) {
      return 'Failed to accept appointment';
    } finally {
      _loadingAppointmentIds.remove(appointmentId);
      notifyListeners();
    }
  }

  Future<String?> declineAppointment(String appointmentId) async {
    if (_loadingAppointmentIds.contains(appointmentId)) {
      return null;
    }

    _loadingAppointmentIds.add(appointmentId);
    notifyListeners();

    try {
      final result = await _apiService.declineAppointment(
        appointmentId: appointmentId,
      );

      if (result['status'] == 'success') {
        appointmentRequests.removeWhere(
              (appointment) => appointment.id == appointmentId,
        );

        return null;
      }

      return result['message'] ?? 'Failed to decline appointment';
    } catch (e) {
      return 'Failed to decline appointment';
    } finally {
      _loadingAppointmentIds.remove(appointmentId);
      notifyListeners();
    }
  }

  void clearAppointmentDetails() {
    appointmentDetails = null;
    detailsErrorMessage = null;
    isDetailsLoading = false;
  }
}
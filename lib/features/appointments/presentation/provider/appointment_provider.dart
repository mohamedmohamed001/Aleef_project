import 'package:aleef/features/appointments/services/appointment_api.dart';
import 'package:flutter/cupertino.dart';

import '../../data/models/previous_appointment_model.dart';

class AppointmentProvider extends ChangeNotifier {
  final AppointmentApi appointmentApi = AppointmentApi();

  List<PreviousAppointmentModel> previousAppointments = [];

  bool isPreviousAppointmentsLoading = false;
  bool isCancelAppointmentLoading = false;

  String? previousAppointmentsError;
  String? cancelAppointmentError;

  Future<void> getPreviousAppointments() async {
    try {
      isPreviousAppointmentsLoading = true;
      previousAppointmentsError = null;
      notifyListeners();

      final response = await appointmentApi.getPreviousAppointments();

      if (response["status"] == "success") {
        previousAppointments = response["data"];
      } else if (response["status"] == "unauthorized") {
        previousAppointmentsError = "Unauthorized";
      } else {
        previousAppointmentsError =
            response["message"] ?? "Something went wrong";
      }
    } catch (e) {
      previousAppointmentsError = "Check your internet connection";
    }

    isPreviousAppointmentsLoading = false;
    notifyListeners();
  }

  Future<bool> cancelAppointment({
    required String appointmentId,
    required String reason,
  }) async {
    try {
      isCancelAppointmentLoading = true;
      cancelAppointmentError = null;
      notifyListeners();

      final response = await appointmentApi.cancelAppointment(
        appointmentId,
        reason,
      );

      if (response["status"] == "success") {
        isCancelAppointmentLoading = false;
        notifyListeners();
        return true;
      }

      if (response["status"] == "unauthorized") {
        cancelAppointmentError = "Unauthorized";
      } else {
        cancelAppointmentError =
            response["message"] ?? "Something went wrong";
      }
    } catch (e) {
      cancelAppointmentError = "Check your internet connection";
    }

    isCancelAppointmentLoading = false;
    notifyListeners();
    return false;
  }
}
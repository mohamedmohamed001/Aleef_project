import 'package:aleef/features/appointments/services/appointment_api.dart';
import 'package:flutter/cupertino.dart';

import '../../data/models/previous_appointment_model.dart';

class AppointmentProvider extends ChangeNotifier {
  final AppointmentApi appointmentApi = AppointmentApi();

  List<PreviousAppointmentModel> previousAppointments = [];
  bool isPreviousAppointmentsLoading = false;
  String? previousAppointmentsError;

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
        previousAppointmentsError = "Something went wrong";
      }
    } catch (e) {
      previousAppointmentsError = "Check your internet connection";
    }

    isPreviousAppointmentsLoading = false;
    notifyListeners();
  }
}

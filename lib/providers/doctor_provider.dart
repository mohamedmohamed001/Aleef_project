import 'package:flutter/material.dart';

import '../core/services/secure_storage_service.dart';
import '../core/services/service_locator.dart';
import '../core/services/session_service.dart';
import '../features/appointments/data/models/doctor_model.dart';

class DoctorProvider with ChangeNotifier {
  final SecureStorageService _storage = getIt<SecureStorageService>();
  final SessionService _session = getIt<SessionService>();

  DoctorModel? doctor;

  bool isLoading = false;
  String? errorMessage;

  Future<void> loadDoctor() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final storedDoctor = await _storage.getDoctor();
      final token = await _storage.getDoctorToken();

      if (storedDoctor == null || token == null || token.isEmpty) {
        errorMessage = 'Doctor session not found';
        return;
      }

      doctor = storedDoctor;

      _session.setDoctorSession(
        doctor: storedDoctor,
        doctorTokenValue: token,
      );
    } catch (e) {
      errorMessage = 'Failed to load doctor profile';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setDoctor(DoctorModel newDoctor) {
    doctor = newDoctor;
    notifyListeners();
  }

  void clearDoctor() {
    doctor = null;
    errorMessage = null;
    notifyListeners();
  }
}
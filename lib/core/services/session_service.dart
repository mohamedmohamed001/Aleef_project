import 'package:aleef/features/appointments/data/models/doctor_model.dart';
import 'package:flutter/material.dart';

import '../../features/auth/data/models/user_model.dart';

class SessionService extends ChangeNotifier {
  UserModel? currentUser;
  String? token;

  DoctorModel? currentDoctor;
  String? doctorToken;

  void setSession({
    required UserModel user,
    required String tokenValue,
  }) {
    currentUser = user;
    token = tokenValue;
    notifyListeners();
  }

  void setDoctorSession({
    required DoctorModel doctor,
    required String doctorTokenValue,
  }) {
    currentDoctor = doctor;
    doctorToken = doctorTokenValue;
    notifyListeners();
  }

  void clearUserSession() {
    currentUser = null;
    token = null;
    notifyListeners();
  }

  void clearDoctorSession() {
    currentDoctor = null;
    doctorToken = null;
    notifyListeners();
  }

  void clearAllSessions() {
    currentUser = null;
    token = null;
    currentDoctor = null;
    doctorToken = null;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

class VerifyProvider extends ChangeNotifier {
  String? _email;
  bool isDoctor = false;

  String? get email => _email;

  void setVerificationData({
    required String email,
    required bool doctor,
  }) {
    _email = email;
    isDoctor = doctor;
    notifyListeners();
  }
}

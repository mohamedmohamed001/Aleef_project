import 'package:flutter/material.dart';
import '../../features/auth/data/models/user_model.dart';

class SessionService extends ChangeNotifier {
  UserModel? currentUser;
  String? token;

  void setSession({
    required UserModel user,
    required String tokenValue,
  }) {
    currentUser = user;
    token = tokenValue;
    notifyListeners();
  }

  void clearSession() {
    currentUser = null;
    token = null;
    notifyListeners();
  }
}
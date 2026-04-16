import 'package:flutter/material.dart';

import '../features/auth/data/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? user;

  void setUser(UserModel newUser) {
    user = newUser;
    notifyListeners();
  }

  void clearUser() {
    user = null;
    notifyListeners();
  }
}
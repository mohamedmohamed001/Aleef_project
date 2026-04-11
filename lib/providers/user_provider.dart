import 'package:flutter/cupertino.dart';

import '../features/auth/data/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? user;

  void setUser(UserModel newUser) {
    user = newUser;
    notifyListeners();
  }

  void updateName(UserModel newUser) {
    user = newUser;
    notifyListeners();
  }
}
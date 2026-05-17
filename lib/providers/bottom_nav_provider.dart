import 'package:flutter/cupertino.dart';

class BottomNavProvider extends ChangeNotifier {
  int selectedIndex = 0;

  bool shouldRefreshAppointments = false; // 👈 الجديد

  void changeTab(int index) {
    selectedIndex = index;

    if (index == 1) {
      shouldRefreshAppointments = true; // 👈 قول للتاب يعمل refresh
    }

    notifyListeners();
  }

  void doneRefresh() {
    shouldRefreshAppointments = false;
  }
}
import 'package:flutter/material.dart';

class AppViewModel extends ChangeNotifier {
  double _dailyTarget = 1000000;

  double get dailyTarget => _dailyTarget;

  void setDailyTarget(double newTarget) {
    _dailyTarget = newTarget;
    notifyListeners();
  }
}

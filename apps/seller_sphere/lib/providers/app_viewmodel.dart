
import 'package:flutter/material.dart';

class AppViewModel extends ChangeNotifier {
  int _selectedIndex = 0;
  String _ownerName = 'Pengguna';

  String get ownerName => _ownerName;

  set ownerName(String name) {
    _ownerName = name;
    notifyListeners();
  }
  
  int get selectedIndex => _selectedIndex;

  set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}

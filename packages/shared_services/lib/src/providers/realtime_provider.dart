import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Import ini WAJIB

class Realtime extends ChangeNotifier {
  // Nama class harus sesuai nama file (Disarankan)

  // Contoh variabel
  int _data = 0;
  int get data => _data;

  void updateData(int newValue) {
    _data = newValue;
    notifyListeners(); // Sekarang method ini seharusnya dikenali
  }
}

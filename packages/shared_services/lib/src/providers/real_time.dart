import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RealTime extends ChangeNotifier {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  
  Map<dynamic, dynamic> _data = {};
  bool _isLoading = true;

  Map<dynamic, dynamic> get data => _data;
  bool get isLoading => _isLoading;

  RealTime() {
    _initDataListener();
  }

  void _initDataListener() {
    _dbRef.onValue.listen((event) {
      final snapshotValue = event.snapshot.value;
      if (snapshotValue is Map<dynamic, dynamic>) {
        _data = snapshotValue;
      }
      _isLoading = false;
      notifyListeners();
    });
  }
}
import 'package:flutter/material.dart';

class StreamingViewModel extends ChangeNotifier {
  bool _isStreaming = false;
  String _currentStreamTitle = "Siap untuk Live Streaming";

  bool get isStreaming => _isStreaming;
  String get currentStreamTitle => _currentStreamTitle;

  void startStream() {
    _isStreaming = true;
    // Di sini Anda bisa mengambil judul dari input atau API
    _currentStreamTitle = "LIVE: Sesi Tanya Jawab Produk Baru!";
    notifyListeners();
  }

  void stopStream() {
    _isStreaming = false;
    _currentStreamTitle = "Siap untuk Live Streaming";
    notifyListeners();
  }
}
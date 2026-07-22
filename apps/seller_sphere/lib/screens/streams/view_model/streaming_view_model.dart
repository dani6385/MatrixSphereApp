
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();


class StreamingViewModel extends ChangeNotifier {
  // Contoh data atau logika terkait streaming
  String _currentStreamTitle = "Live Stream Produk Terbaru";
  bool _isStreaming = false;

  String get currentStreamTitle => _currentStreamTitle;
  bool get isStreaming => _isStreaming;

  void startStream() {
    _isStreaming = true;
    _currentStreamTitle = "Sedang Live: Produk Unggulan!";
    notifyListeners();
    // Tambahkan logika memulai stream (misal: koneksi ke server RTMP)
    logger.i("Streaming dimulai!");
  }

  void stopStream() {
    _isStreaming = false;
    _currentStreamTitle = "Live Stream Produk Terbaru";
    notifyListeners();
    // Tambahkan logika menghentikan stream
    logger.i("Streaming dihentikan.");
  }

  void updateStreamTitle(String newTitle) {
    _currentStreamTitle = newTitle;
    notifyListeners();
  }
}

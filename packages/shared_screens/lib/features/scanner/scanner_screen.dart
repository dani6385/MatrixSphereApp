// Disimpan di d:/matrixsphere/packages/shared_screens/lib/features/scanner_screen.dart

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:logger/logger.dart';

class ScannerScreen extends StatefulWidget {
  final bool isAttendance; // Menentukan apakah ini untuk absensi (true) atau produk/kasir (false)

  const ScannerScreen({
    super.key,
    this.isAttendance = false, // Default ke false (kamera belakang / produk / kasir)
  });

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final Logger _logger = Logger();
  late MobileScannerController _controller;
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    
    // Inisialisasi controller scanner dengan posisi kamera berdasarkan parameter
    // Jika isAttendance true -> Kamera Depan (Front)
    // Jika isAttendance false -> Kamera Belakang (Back)
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: widget.isAttendance ? CameraFacing.front : CameraFacing.back,
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Bersihkan resource kamera saat halaman ditutup
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isAttendance ? 'Pemindai Absensi (Wajah)' : 'Pemindai Produk / Kasir'),
        actions: [
          // Tombol untuk menyalakan/mematikan lampu flash menggunakan value dari controller
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: _controller,
            builder: (context, state, child) {
              final torchState = state.torchState;
              return IconButton(
                icon: Icon(
                  torchState == TorchState.on ? Icons.flash_on : Icons.flash_off,
                  color: torchState == TorchState.on ? Colors.yellow : Colors.grey,
                ),
                onPressed: () => _controller.toggleTorch(),
              );
            },
          ),
          // Tombol untuk membalikkan kamera (depan/belakang) secara manual jika diperlukan
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: _controller,
            builder: (context, state, child) {
              final cameraFacing = state.cameraDirection;
              return IconButton(
                icon: Icon(
                  cameraFacing == CameraFacing.front ? Icons.camera_front : Icons.camera_rear,
                ),
                onPressed: () => _controller.switchCamera(),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Widget utama penampil kamera
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              if (!_isScanning) return;

              final List<Barcode> barcodes = capture.barcodes;

              // Proses barcode / QR code yang terdeteksi
              if (barcodes.isNotEmpty) {
                final barcode = barcodes.first;
                _logger.i('Data terdeteksi: ${barcode.rawValue}');
                setState(() {
                  _isScanning = false;
                });

                _showResultDialog(barcode.rawValue ?? 'Data tidak valid');
              }
            },
          ),
          
          // Bingkai panduan visual di tengah layar
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent, width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          
          // Teks instruksi di bagian bawah
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Text(
              widget.isAttendance 
                  ? 'Arahkan wajah ke dalam kotak untuk absen' 
                  : 'Arahkan barcode produk ke dalam kotak',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                backgroundColor: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan hasil deteksi dalam bentuk dialog
  void _showResultDialog(String data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hasil Pemindaian'),
        content: Text('Berhasil memindai: $data'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isScanning = true; // Lanjutkan kembali pemindaian
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
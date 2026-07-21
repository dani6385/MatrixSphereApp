// lib/screens/absensi/camera_absen_screen.dart

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:shared_ui/shared_ui.dart';

class CameraAbsenScreen extends StatefulWidget {
  const CameraAbsenScreen({super.key});

  @override
  State<CameraAbsenScreen> createState() => _CameraAbsenScreenState();
}

class _CameraAbsenScreenState extends State<CameraAbsenScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      // Ambil daftar semua kamera fisik di ponsel
      _cameras = await availableCameras();
      
      if (_cameras != null && _cameras!.isNotEmpty) {
        // Cari sensor Kamera Depan (front-facing) secara otomatis untuk selfie absen
        CameraDescription? frontCamera;
        for (var camera in _cameras!) {
          if (camera.lensDirection == CameraLensDirection.front) {
            frontCamera = camera;
            break;
          }
        }

        // Jika kamera depan tidak terdeteksi, gunakan kamera default pertama
        frontCamera ??= _cameras!.first;

        _controller = CameraController(
          frontCamera,
          ResolutionPreset.medium,
          enableAudio: false, // Matikan suara agar tidak mengganggu
        );

        await _controller!.initialize();
        
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint("Gagal memuat sensor kamera: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose(); // Bebaskan pemakaian memori kamera saat halaman ditutup
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    try {
      // Mengambil foto
      final XFile file = await _controller!.takePicture();
      debugPrint("Foto absen berhasil disimpan di lokal: ${file.path}");

      if (mounted) {
        // Tampilkan konfirmasi sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Presensi Berhasil Dikirim!'),
            backgroundColor: Colors.green,
          ),
        );
        // Kembali ke halaman AbsensiScreen utama
        Navigator.of(context).pop();
      }
    } catch (e) {
      debugPrint("Gagal menangkap gambar: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: kBrandPrimary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Ambil Foto Presensi', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. Tampilan Feed Kamera Utama (Mengikuti Rasio Asli Kamera)
          Positioned.fill(
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: CameraPreview(_controller!),
            ),
          ),

          // 2. Garis Penuntun Wajah Oval (Overlay) agar wajah presisi di tengah
          Align(
            alignment: const Alignment(0, -0.2),
            child: Container(
              width: 240,
              height: 310,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white70, width: 2),
                borderRadius: BorderRadius.circular(150), // Membuat bentuk oval wajah
              ),
            ),
          ),

          // 3. Tombol Rana / Shutter untuk Menangkap Gambar (Bagian Bawah)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: FloatingActionButton(
                onPressed: _takePicture,
                backgroundColor: Colors.white,
                child: const Icon(Icons.camera_alt, color: Colors.black, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
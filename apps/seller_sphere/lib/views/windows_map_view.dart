import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WindowsMapView extends StatelessWidget {
  const WindowsMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Maps di Windows')),
      body: const GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(-6.200000, 106.816666), // Contoh koordinat Jakarta
          zoom: 14.0,
        ),
        // API Key untuk Windows telah didaftarkan di main.dart
        // sehingga tidak perlu disetel lagi di sini.
      ),
    );
  }
}
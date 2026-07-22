import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:geodesy/geodesy.dart';

/// A data class to hold the result of a location check.
class LocationCheckResult {
  final bool isWithinRadius;
  final String errorTitle;
  final String errorMessage;
  final bool needsSettings;

  LocationCheckResult({
    this.isWithinRadius = false,
    this.errorTitle = '',
    this.errorMessage = '',
    this.needsSettings = false,
  });
}

/// A service to handle all location-based operations.
///
/// This service is responsible for checking permissions, getting the
/// user's current location, and verifying if they are within a
/// predefined office radius.
class LocationService {
  // --- KONFIGURASI ---
  // Ganti dengan koordinat lokasi kantor Anda.
  // Anda bisa mendapatkan koordinat dari Google Maps.
  static const LatLng _officeLocation = LatLng(-6.2088, 106.8456); // Contoh: Monas, Jakarta
  static const double _officeRadiusMeters = 100.0; // Radius 100 meter
  // -------------------

  final Geodesy _geodesy;

  // Sediakan Geodesy melalui constructor untuk kemudahan testing.
  // Default value digunakan agar tidak merusak kode yang sudah ada.
  LocationService({Geodesy? geodesy}) : _geodesy = geodesy ?? Geodesy();

  /// Checks if the user is physically within the office radius.
  ///
  /// This method handles permission checks, requests location, and
  /// calculates the distance to the office.
  Future<LocationCheckResult> isUserWithinOfficeRadius() async {
    // 1. Periksa apakah layanan lokasi di perangkat aktif.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationCheckResult(
        errorTitle: 'GPS Tidak Aktif',
        errorMessage: 'Harap aktifkan layanan lokasi (GPS) di perangkat Anda untuk melanjutkan absensi.',
        needsSettings: true, // Tampilkan tombol untuk membuka pengaturan
      );
    }

    // 2. Periksa dan minta izin lokasi kepada pengguna.
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationCheckResult(
          errorTitle: 'Izin Lokasi Ditolak',
          errorMessage: 'Aplikasi memerlukan izin akses lokasi untuk memverifikasi kehadiran. Silakan berikan izin.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Pengguna menolak izin secara permanen.
      return LocationCheckResult(
        errorTitle: 'Izin Lokasi Ditolak Permanen',
        errorMessage: 'Anda telah menolak izin lokasi secara permanen. Harap aktifkan secara manual di pengaturan aplikasi.',
        needsSettings: true, // Tampilkan tombol untuk membuka pengaturan
      );
    }

    // 3. Jika izin diberikan, dapatkan lokasi pengguna saat ini.
    try {
      Position userPosition = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
        // ignore: deprecated_member_use
        timeLimit: const Duration(seconds: 10), // Batas waktu 10 detik
      );

      final userLocation = LatLng(userPosition.latitude, userPosition.longitude);

      // 4. Hitung jarak dari pengguna ke kantor.
      final distance = _geodesy.distanceBetweenTwoGeoPoints(userLocation, _officeLocation);

      // 5. Bandingkan jarak dengan radius yang diizinkan.
      if (distance <= _officeRadiusMeters) {
        return LocationCheckResult(isWithinRadius: true);
      } else {
        return LocationCheckResult(
          errorTitle: 'Di Luar Jangkauan',
          errorMessage: 'Anda terdeteksi berada di luar radius kantor yang diizinkan. Jarak Anda sekitar ${distance.round()} meter dari lokasi.',
        );
      }
    } on TimeoutException {
      return LocationCheckResult(
        errorTitle: 'Gagal Mendapatkan Lokasi',
        errorMessage: 'Tidak dapat mengambil lokasi Anda saat ini. Pastikan sinyal GPS Anda kuat dan coba lagi.',
      );
    } catch (e) {
      return LocationCheckResult(
        errorTitle: 'Terjadi Kesalahan',
        errorMessage: 'Terjadi kesalahan tak terduga saat memeriksa lokasi: $e',
      );
    }
  }
}
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
  final Geodesy _geodesy;

  // Sediakan Geodesy melalui constructor untuk kemudahan testing.
  // Default value digunakan agar tidak merusak kode yang sudah ada.
  LocationService({Geodesy? geodesy}) : _geodesy = geodesy ?? Geodesy();

  /// Mendapatkan lokasi pengguna saat ini setelah memeriksa izin.
  ///
  /// Menangani pengecekan layanan, izin, dan permintaan izin.
  /// Melemparkan `Exception` dengan pesan yang jelas jika terjadi masalah.
  ///
  /// @return `Position` jika berhasil.
  /// @throws `Exception` jika layanan lokasi mati, izin ditolak, atau terjadi error lain.
  Future<Position> getCurrentLocation() async {
    // 1. Periksa apakah layanan lokasi di perangkat aktif.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Harap aktifkan layanan lokasi (GPS) di perangkat Anda.');
    }

    // 2. Periksa dan minta izin lokasi kepada pengguna.
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Aplikasi memerlukan izin akses lokasi untuk menentukan pin point.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Pengguna menolak izin secara permanen.
      throw Exception('Izin lokasi ditolak permanen. Harap aktifkan manual di pengaturan aplikasi.');
    }

    // 3. Jika izin diberikan, dapatkan lokasi pengguna saat ini.
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15), // Batas waktu 15 detik
        ),
      );
    } on TimeoutException {
      throw Exception('Gagal mendapatkan lokasi. Pastikan sinyal GPS kuat dan coba lagi.');
    } catch (e) {
      throw Exception('Terjadi kesalahan tak terduga saat mengambil lokasi: $e');
    }
  }

  /// Membuka pengaturan lokasi aplikasi.
  ///
  /// Berguna jika pengguna menolak izin secara permanen.
  Future<void> openLocationSettings() async {
    await Geolocator.openAppSettings();
  }

  /// Memeriksa apakah pengguna secara fisik berada dalam radius lokasi yang ditentukan.
  ///
  /// Metode ini adalah versi generik yang menangani:
  /// 1. Pengecekan layanan lokasi (GPS).
  /// 2. Pengecekan dan permintaan izin lokasi.
  /// 3. Pengambilan lokasi pengguna saat ini.
  /// 4. Perhitungan jarak ke lokasi target.
  /// 5. Pengembalian hasil dalam bentuk [LocationCheckResult].
  ///
  /// [targetLocation]: Koordinat LatLng dari lokasi target (bisa kantor, toko, dll).
  /// [radiusMeters]: Radius yang diizinkan dalam meter (default 100m).
  Future<LocationCheckResult> isUserWithinRadius({
    required LatLng targetLocation,
    double radiusMeters = 100.0,
  }) async {
    // 1. Periksa apakah layanan lokasi di perangkat aktif.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationCheckResult(
        errorTitle: 'GPS Tidak Aktif',
        errorMessage: 'Harap aktifkan layanan lokasi (GPS) di perangkat Anda untuk melanjutkan absensi.',
        needsSettings: true,
      );
    }

    // 2. Periksa dan minta izin lokasi.
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationCheckResult(
          errorTitle: 'Izin Lokasi Ditolak',
          errorMessage: 'Aplikasi memerlukan izin akses lokasi untuk memverifikasi kehadiran.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationCheckResult(
        errorTitle: 'Izin Lokasi Ditolak Permanen',
        errorMessage: 'Anda telah menolak izin lokasi secara permanen. Harap aktifkan manual di pengaturan aplikasi.',
        needsSettings: true,
      );
    }

    // 3. Dapatkan lokasi pengguna saat ini.
    try {
      final userPosition = await getCurrentLocation(); // Menggunakan metode yang sudah ada
      final userLocation =
          LatLng(userPosition.latitude, userPosition.longitude);

      // 4. Hitung jarak dari pengguna ke lokasi target.
      final distance =
          _geodesy.distanceBetweenTwoGeoPoints(userLocation, targetLocation);

      // 5. Bandingkan jarak dengan radius yang diizinkan.
      if (distance <= radiusMeters) {
        return LocationCheckResult(isWithinRadius: true);
      } else {
        return LocationCheckResult(
          errorTitle: 'Di Luar Jangkauan',
          errorMessage:
              'Anda terdeteksi berada di luar radius yang diizinkan. Jarak Anda sekitar ${distance.round()} meter dari lokasi target.',
        );
      }
    } catch (e) {
      // Tangkap error dari getCurrentLocation() atau lainnya
      return LocationCheckResult(
          errorTitle: 'Gagal Mendapatkan Lokasi',
          errorMessage: e.toString().replaceAll("Exception: ", ""));
    }
  }
}
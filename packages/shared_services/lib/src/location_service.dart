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

  /// Memeriksa apakah pengguna secara fisik berada dalam radius toko yang ditentukan.
  ///
  /// Method ini menangani pengecekan izin, permintaan lokasi, dan
  /// menghitung jarak ke lokasi toko yang diberikan.
  ///
  /// [shopLocation]: Koordinat LatLng dari toko.
  /// [radiusMeters]: Radius yang diizinkan dalam meter (default 100m).
  Future<LocationCheckResult> isUserWithinShopRadius({
    required LatLng shopLocation,
    double radiusMeters = 100.0,
  }) async {
    // 1. Periksa apakah layanan lokasi di perangkat aktif.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationCheckResult(
        errorTitle: 'GPS Tidak Aktif',
        errorMessage: 'Harap aktifkan layanan lokasi (GPS) di perangkat Anda untuk melanjutkan.',
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
      final userLocation = LatLng(userPosition.latitude, userPosition.longitude);

      // 4. Hitung jarak dari pengguna ke toko.
      final distance = _geodesy.distanceBetweenTwoGeoPoints(userLocation, shopLocation);

      // 5. Bandingkan jarak dengan radius yang diizinkan.
      if (distance <= radiusMeters) {
        return LocationCheckResult(isWithinRadius: true);
      } else {
        return LocationCheckResult(
          errorTitle: 'Di Luar Jangkauan Toko',
          errorMessage: 'Anda terdeteksi berada di luar radius toko. Jarak Anda sekitar ${distance.round()} meter dari lokasi toko.',
        );
      }
    } catch (e) {
      // Tangkap error dari getCurrentLocation() atau lainnya
      return LocationCheckResult(errorTitle: 'Gagal Mendapatkan Lokasi', errorMessage: e.toString().replaceAll("Exception: ", ""));
    }
  }

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
        // Perbaikan: Menggunakan LocationSettings yang lebih modern
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
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
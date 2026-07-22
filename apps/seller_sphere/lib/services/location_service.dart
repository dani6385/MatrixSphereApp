import 'package:geolocator/geolocator.dart';

/// Result class for location verification process.
class LocationVerificationResult {
  final bool isAllowed;
  final String? errorTitle;
  final String? errorMessage;
  final bool showSettingsButton;

  LocationVerificationResult.allowed()
      : isAllowed = true,
        errorTitle = null,
        errorMessage = null,
        showSettingsButton = false;

  LocationVerificationResult.error(this.errorTitle, this.errorMessage, {bool showSettings = false})
      : isAllowed = false,
        showSettingsButton = showSettings;
}

/// A service class to handle all location-related functionalities.
class LocationService {
  /// Verifies if the user is within a specified radius of a target location.
  ///
  /// This method handles checking for service status, permissions, and calculating distance.
  Future<LocationVerificationResult> verifyLocation({
    required double targetLatitude,
    required double targetLongitude,
    required double maxDistanceInMeters,
  }) async {
    // 1. Check if location services are enabled.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationVerificationResult.error("Layanan Lokasi Mati",
          "Harap aktifkan layanan lokasi (GPS) di perangkat Anda untuk melanjutkan.");
    }

    // 2. Handle location permissions.
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationVerificationResult.error("Izin Lokasi Ditolak",
            "Izin lokasi diperlukan untuk memverifikasi lokasi Anda saat absensi.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationVerificationResult.error(
          "Izin Lokasi Diblokir",
          "Izin lokasi telah diblokir secara permanen. Harap aktifkan secara manual di pengaturan aplikasi.",
          showSettings: true);
    }

    // 3. Get current position and calculate distance.
    final Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final double distance = Geolocator.distanceBetween(position.latitude, position.longitude, targetLatitude, targetLongitude);

    if (distance > maxDistanceInMeters) {
      return LocationVerificationResult.error("Di Luar Jangkauan",
          "Anda berada terlalu jauh dari lokasi yang ditentukan. Jarak Anda saat ini adalah ${distance.toStringAsFixed(0)} meter dari target.");
    }

    return LocationVerificationResult.allowed();
  }
}
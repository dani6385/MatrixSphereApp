import 'package:firebase_database/firebase_database.dart';
import 'package:geodesy/geodesy.dart';

/// A service to fetch application-wide configurations.
///
/// This service can be used to get dynamic values like feature flags,
/// API endpoints, or important coordinates from a remote source
/// like Firebase Realtime Database or Remote Config.
class ConfigService {
  final FirebaseDatabase _database;

  ConfigService({FirebaseDatabase? database})
      : _database = database ?? FirebaseDatabase.instance;

  /// Fetches the main office coordinates from Firebase Realtime Database.
  ///
  /// Assumes the data is stored at the path: `/system/config/office_location`
  /// with 'latitude' and 'longitude' children.
  ///
  /// @return A [LatLng] object representing the office location.
  /// @throws [Exception] if the location data is not found or invalid.
  Future<LatLng> getOfficeLocation() async {
    try {
      final ref = _database.ref('system/config/office_location');
      final snapshot = await ref.get();

      if (snapshot.exists && snapshot.value != null) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        final lat = data['latitude'] as double;
        final lon = data['longitude'] as double;
        return LatLng(lat, lon);
      } else {
        throw Exception('Konfigurasi lokasi kantor tidak ditemukan di database.');
      }
    } catch (e) {
      throw Exception('Gagal mengambil konfigurasi lokasi kantor: $e');
    }
  }
}
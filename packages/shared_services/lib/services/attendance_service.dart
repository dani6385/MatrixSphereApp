import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_models/shared_models.dart';

class AttendanceService {
  // Memeriksa izin lokasi GPS pengguna
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Layanan lokasi tidak aktif. Harap aktifkan GPS Anda.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Izin lokasi ditolak.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Izin lokasi ditolak permanen. Silakan atur di pengaturan HP.");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Menghitung jarak antara pengguna dan lokasi admin
  double calculateDistance(Position userPos, OfficeLocationModel office) {
    return Geolocator.distanceBetween(
      userPos.latitude,
      userPos.longitude,
      office.latitude,
      office.longitude,
    );
  }

  // Mengirimkan data foto dan lokasi ke server
  Future<bool> uploadAttendanceData({
    required File imageFile,
    required double latitude,
    required double longitude,
    required String employeeId,
  }) async {
    try {
      var uri = Uri.parse('https://api.domainanda.com/v1/attendance/verify');
      var request = http.MultipartRequest('POST', uri);

      request.files.add(await http.MultipartFile.fromPath('face_image', imageFile.path));
      request.fields['employee_id'] = employeeId;
      request.fields['latitude'] = latitude.toString();
      request.fields['longitude'] = longitude.toString();

      var response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
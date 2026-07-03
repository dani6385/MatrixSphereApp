import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class SellerProfileProvider with ChangeNotifier {
  // Lokasi default dummy (Bandung)
  LatLng _storeLocation = const LatLng(-6.9175, 107.6191);
  String _storeAddress = 'Jl. Teknologi No. 1, Bandung, Jawa Barat';

  LatLng get storeLocation => _storeLocation;
  String get storeAddress => _storeAddress;

  void setStoreLocation(LatLng newLocation, String newAddress) {
    _storeLocation = newLocation;
    _storeAddress = newAddress;
    notifyListeners();
    // Di aplikasi nyata, Anda akan menyimpan ini ke database (misalnya, Firestore).
    logger.i('Lokasi toko baru disimpan: $newAddress');
  }
}
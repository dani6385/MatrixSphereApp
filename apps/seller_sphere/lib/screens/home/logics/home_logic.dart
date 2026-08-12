// lib/features/home/logics/home_logic.dart
import 'package:shared_services/shared_services.dart';

class HomeLogic {
  final AuthService _authService = AuthService();

  /// Memeriksa status kepemilikan toko pengguna
  Future<bool> checkShopStatus() async {
    final shopId = await _authService.getCurrentShopId();
    // Jika shopId bukan 'toko_percobaan' dan tidak kosong, berarti toko ada
    return shopId != null && shopId.isNotEmpty && shopId != 'toko_percobaan';
  }
}
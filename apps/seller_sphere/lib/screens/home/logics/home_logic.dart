// lib/features/home/logics/home_logic.dart
import 'package:shared_services/shared_services.dart';

class HomeLogic {
  final AuthService _authService = AuthService();
final ShopService shopService = ShopService();
  /// Memeriksa status kepemilikan toko pengguna
  Future<bool> checkShopStatus() async {
    final shopId = await shopService.getCurrentShopId(_authService.currentUser);
    // Jika shopId bukan 'toko_percobaan' dan tidak kosong, berarti toko ada
    return shopId != null && shopId.isNotEmpty && shopId != 'toko_percobaan';
  }
}
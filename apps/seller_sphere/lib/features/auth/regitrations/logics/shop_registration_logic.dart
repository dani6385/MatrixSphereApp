import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';
import '../states/shop_registration_state.dart';

class ShopRegistrationLogic {
  final AuthService _authService = AuthService();

  /// Mendapatkan lokasi GPS pengguna saat ini
  Future<void> getCurrentLocation({
    required ShopRegistrationState state,
    required VoidCallback onUpdate,
  }) async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      
      if (permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition();
      state.mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 15.0,
          ),
        ),
      );
    } catch (e) {
      // Gagal mendapatkan lokasi, abaikan
    }
  }

  /// Menangani proses pendaftaran toko
  Future<void> handleRegisterShop({
    required BuildContext context,
    required ShopRegistrationState state,
    required void Function(bool) setLoading,
  }) async {
    if (state.formKey.currentState!.validate()) {
      setLoading(true);
      try {
        // Ambil ID pengguna dari local storage
        final userId = await LocalAuthStorage.getUserId();
        if (userId == null) {
          throw Exception("Sesi pengguna tidak valid. Silakan login kembali.");
        }

        if (state.selectedCoordinates == null) {
          throw Exception("Silakan pilih lokasi penjemputan di peta.");
        }

        // Ambil shopId yang sudah dibuat di langkah sebelumnya
        final sellerData = await _authService.getSellerData(userId);
        if (sellerData == null) {
          throw Exception("Data penjual tidak ditemukan. Silakan mulai registrasi dari awal.");
        }

        final shopId = sellerData['shopId'] as String?;

        if (shopId == null) {
          // Pesan error ini lebih spesifik, mengindikasikan masalah pada alur registrasi.
          throw Exception("ID Toko belum terdaftar. Pastikan Anda telah menyelesaikan tahap registrasi awal sebelum memilih lokasi.");
        }

        await _authService.updateShopDetails(
          uid: userId,
          shopId: shopId,
          fullAddress: state.fullAddressController.text.trim(),
          coordinates: {
            'latitude': state.selectedCoordinates!.latitude,
            'longitude': state.selectedCoordinates!.longitude,
          },
        );
      } catch (e) {
        if (context.mounted) {
          showErrorDialog(
            context: context, 
            message: e.toString().replaceAll("Exception: ", ""),
          );
        }
      } finally {
        setLoading(false);
      }
    }
  }

  /// Menangani aksi ketika kamera peta bergerak.
  /// Pin berada di tengah, jadi kita hanya perlu menyimpan koordinat tengah peta.
  void onCameraMove({
    required CameraPosition position,
    required ShopRegistrationState state,
  }) {
    // Setiap kali peta digeser, perbarui koordinat yang dipilih ke posisi tengah kamera.
    state.selectedCoordinates = position.target;
  }
}

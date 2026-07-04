import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Model untuk data profil penjual.
class SellerProfile {
  final String id;
  final String name;
  final String storeName;
  final String email;
  final String phone;
  final String address;
  final String profilePictureUrl;
  final LatLng? location;

  SellerProfile({
    required this.id,
    required this.name,
    required this.storeName,
    required this.email,
    required this.phone,
    required this.address,
    required this.profilePictureUrl,
    this.location,
  });

  SellerProfile copyWith({
    String? name,
    String? storeName,
    String? email,
    String? phone,
    String? address,
    String? profilePictureUrl,
    LatLng? location,
  }) {
    return SellerProfile(
      id: id,
      name: name ?? this.name,
      storeName: storeName ?? this.storeName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      location: location ?? this.location,
    );
  }
}

/// Provider untuk mengelola state profil penjual.
class SellerProfileProvider with ChangeNotifier {
  SellerProfile _profile = SellerProfile(
    id: 'seller123',
    name: 'Budi Santoso',
    storeName: 'Toko Elektronik Jaya',
    email: 'budi.s@example.com',
    phone: '0812-3456-7890',
    address: 'Pilih lokasi di peta atau cari alamat.',
    profilePictureUrl: 'https://i.pravatar.cc/150?u=budi.santoso',
    location: const LatLng(-6.2088, 106.8456), // Default: Jakarta
  );

  SellerProfile get profile => _profile;

  void updateProfile(SellerProfile newProfile) {
    _profile = newProfile;
    notifyListeners();
  }

  void setStoreLocation(LatLng newLocation, String newAddress) {
    _profile = _profile.copyWith(location: newLocation, address: newAddress);
    notifyListeners();
  }
}
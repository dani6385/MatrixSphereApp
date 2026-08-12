// lib/features/auth/shop_registration/states/shop_registration_state.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShopRegistrationState {
  final GlobalKey<FormState> formKey;
  final TextEditingController shopNameController;
  final TextEditingController fullAddressController;
  
  GoogleMapController? mapController;
  LatLng? selectedCoordinates;
  final Set<Marker> markers = {};
  
  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(-6.2088, 106.8456),
    zoom: 11.0,
  );

  bool isLoading;

  ShopRegistrationState({
    required this.formKey,
    required this.shopNameController,
    required this.fullAddressController,
    this.mapController,
    this.selectedCoordinates,
    this.isLoading = false,
  });
}

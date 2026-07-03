import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // This import is already present.
import 'package:provider/provider.dart'; // This import is already present.
import 'package:seller_sphere/providers/seller_profile_provider.dart';

class StoreLocationScreen extends StatefulWidget {
  const StoreLocationScreen({super.key});

  @override
  State<StoreLocationScreen> createState() => _StoreLocationScreenState();
}

class _StoreLocationScreenState extends State<StoreLocationScreen> {
  late GoogleMapController _mapController;
  LatLng? _pickedLocation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    final sellerProfile = Provider.of<SellerProfileProvider>(context, listen: false);
    setState(() {
      _pickedLocation = sellerProfile.storeLocation;
      _isLoading = false;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final currentLocation = LatLng(position.latitude, position.longitude);
      setState(() {
        _pickedLocation = currentLocation;
      });
      _mapController.animateCamera(CameraUpdate.newLatLngZoom(currentLocation, 16));
    } catch (e) {
      // Handle error
      print('Error mendapatkan lokasi: $e');
    }
  }

  void _saveLocation() {
    if (_pickedLocation == null) return;
    // Di aplikasi nyata, Anda akan menggunakan Geocoding untuk mendapatkan alamat dari LatLng
    final newAddress = 'Alamat di Lat: ${_pickedLocation!.latitude.toStringAsFixed(4)}, Lng: ${_pickedLocation!.longitude.toStringAsFixed(4)}';
    Provider.of<SellerProfileProvider>(context, listen: false).setStoreLocation(_pickedLocation!, newAddress);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lokasi toko berhasil disimpan!')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final initialLocation = Provider.of<SellerProfileProvider>(context, listen: false).storeLocation;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Atur Lokasi Toko'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveLocation,
            tooltip: 'Simpan Lokasi',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _pickedLocation ?? initialLocation,
                    zoom: 16.0,
                  ),
                  onTap: _selectLocation,
                  markers: (_pickedLocation == null)
                      ? {}
                      : {
                          Marker(
                            markerId: const MarkerId('m1'),
                            position: _pickedLocation!,
                          ),
                        },
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: _getCurrentLocation,
                    tooltip: 'Lokasi Saat Ini',
                    child: const Icon(Icons.my_location),
                  ),
                ),
              ],
            ),
    );
  }
}
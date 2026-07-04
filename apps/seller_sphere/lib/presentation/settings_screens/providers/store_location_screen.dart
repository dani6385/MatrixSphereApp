import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/presentation/profile_screens/providers/seller_profile_provider.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:logger/logger.dart';
import 'package:shared_ui/shared_ui.dart';

final logger = Logger();

class StoreLocationScreen extends StatefulWidget {
  const StoreLocationScreen({super.key});

  @override
  State<StoreLocationScreen> createState() => _StoreLocationScreenState();
}

class _StoreLocationScreenState extends State<StoreLocationScreen> with SingleTickerProviderStateMixin {
  late GoogleMapController _mapController;
  LatLng? _pickedLocation;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isSearching = false;
  final _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _radiusAnimation;
  late Animation<Color?> _colorAnimation;
  String _currentAddress = 'Pilih lokasi di peta atau cari alamat.';
  bool _isFetchingAddress = false;

  @override
  void initState() {
    super.initState();
    _initializeMap();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _radiusAnimation = Tween<double>(begin: 0, end: 50).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _colorAnimation = ColorTween(
      begin: AppColors.beginend,
      end: AppColors.beginend,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.ease),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    final sellerProfile = Provider.of<SellerProfileProvider>(context, listen: false);
    setState(() {
      _pickedLocation = sellerProfile.profile.location;
      _isLoading = false;
    });
    if (_pickedLocation != null) _updateAddressFromLatLng(_pickedLocation!);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
      _updateAddressFromLatLng(position);
      _animationController.forward(from: 0.0);
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
        _updateAddressFromLatLng(currentLocation);
        _animationController.forward(from: 0.0);
      });
      _mapController.animateCamera(CameraUpdate.newLatLngZoom(currentLocation, 16));
    } catch (e) {
      logger.e('Error mendapatkan lokasi saat ini', error: e);
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  Future<void> _searchAndGoToLocation() async {
    final address = _searchController.text;
    if (address.isEmpty) return;

    try {
      List<geo.Location> locations = await geo.locationFromAddress(address);
      if (locations.isNotEmpty) {
        final location = locations.first;
        final newPosition = LatLng(location.latitude, location.longitude);
        _selectLocation(newPosition);
        _mapController.animateCamera(CameraUpdate.newLatLngZoom(newPosition, 16));
        _toggleSearch();
      }
    } catch (e) {
      logger.e('Gagal mencari alamat', error: e);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alamat tidak ditemukan. Coba dengan kata kunci lain.')),
      );
    }
  }

  Future<void> _updateAddressFromLatLng(LatLng position) async {
    setState(() {
      _isFetchingAddress = true;
    });
    try {
      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks[0];
        setState(() {
          _currentAddress = '${p.street}, ${p.subLocality}, ${p.locality}, ${p.administrativeArea} ${p.postalCode}';
        });
      }
    } catch (e) {
      logger.w('Gagal mendapatkan alamat dari LatLng', error: e);
      setState(() {
        _currentAddress = 'Tidak dapat mengambil alamat untuk lokasi ini.';
      });
    }
    setState(() => _isFetchingAddress = false);
  }

  Future<void> _saveLocation() async {
    if (_pickedLocation == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final addressToSave = _currentAddress;
      
      if (!mounted) return;
      Provider.of<SellerProfileProvider>(context, listen: false).setStoreLocation(_pickedLocation!, addressToSave);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lokasi toko berhasil disimpan!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      logger.e('Gagal melakukan geocoding', error: e);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mendapatkan alamat. Coba lagi.')),
      );
    }
    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    final initialLocation = Provider.of<SellerProfileProvider>(context, listen: false).profile.location;

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Cari alamat...',
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _searchAndGoToLocation(),
              )
            : const Text('Atur Lokasi Toko'),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _searchAndGoToLocation,
            )
          else
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _toggleSearch,
            ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: (_pickedLocation == null || _isSaving) ? null : _saveLocation,
            tooltip: 'Simpan Lokasi',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [ 
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, _) {
                    return GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(target: _pickedLocation ?? initialLocation ?? const LatLng(0, 0), zoom: 16.0),
                      onTap: _selectLocation,
                      markers: _buildMarkers(),
                      circles: _pickedLocation == null ? {} : {
                        Circle(
                          circleId: const CircleId('c1'),
                          center: _pickedLocation!,
                          radius: _radiusAnimation.value,
                          fillColor: _colorAnimation.value ?? Colors.transparent,
                          strokeWidth: 0,
                        ),
                      },
                    );
                  },
                  ),
                Positioned(
                  bottom: 90,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: _getCurrentLocation,
                    tooltip: 'Lokasi Saat Ini',
                    child: const Icon(Icons.my_location),
                  ),
                ),
                _AddressDisplayPanel(
                  isFetchingAddress: _isFetchingAddress,
                  currentAddress: _currentAddress,
                ),
                if (_isSaving)
                  Container(
                    color: AppColors.black,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
    );
  }

  Set<Marker> _buildMarkers() {
    if (_pickedLocation == null) {
      return {};
    }
    return {
      Marker(
        markerId: const MarkerId('m1'),
        position: _pickedLocation!,
        draggable: true,
        onDragEnd: (newPosition) {
          _selectLocation(newPosition);
        },
      ),
    };
  }
}

class _AddressDisplayPanel extends StatelessWidget {
  const _AddressDisplayPanel({
    required this.isFetchingAddress,
    required this.currentAddress,
  });

  final bool isFetchingAddress;
  final String currentAddress;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Material(
        elevation: 4.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: const BoxConstraints(minHeight: 70),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, color: Colors.grey),
              const SizedBox(width: 12),
              Expanded(
                child: isFetchingAddress
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ],
                      )
                    : Text(currentAddress, maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
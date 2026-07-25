import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/services/location_service.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shopNameController = TextEditingController();
  final _rtdbService = FirebaseRtdbService();
  final _locationService = LocationService();
  bool _isLoading = false;
  bool _isFetchingLocation = false;
  double? _latitude;
  double? _longitude;

  @override
  void dispose() {
    _shopNameController.dispose();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    setState(() {
      _isFetchingLocation = true;
    });

    try {
      final position = await _locationService.getCurrentLocation();
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Lokasi berhasil didapatkan!"),
            backgroundColor: kSoftTeal,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString().replaceAll("Exception: ", "")}"),
            backgroundColor: kAlertRed,
          ),
        );
      }
    } finally {
      setState(() {
        _isFetchingLocation = false;
      });
    }
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Harap tentukan lokasi penjemputan terlebih dahulu."),
          backgroundColor: kAlertRed,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Seharusnya tidak terjadi karena ada redirect, tapi sebagai pengaman
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Pengguna tidak ditemukan.")),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final shopName = _shopNameController.text.trim();
    final data = {
      'nama': shopName,
      'status': 'waiting',
      'latitude': _latitude,
      'longitude': _longitude,
    };

    // Menggunakan UID pengguna sebagai key di node 'approval'
    final success = await _rtdbService.writeData('approval/${user.uid}', data);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "Pendaftaran toko berhasil! Mohon tunggu persetujuan admin."),
            backgroundColor: kSoftTeal,
          ),
        );
        // Arahkan ke halaman utama, GoRouter akan menangani sisanya
        // (misal, tetap di halaman ini atau halaman tunggu)
        context.go('/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal mendaftarkan toko. Silakan coba lagi."),
            backgroundColor: kAlertRed,
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftarkan Toko Anda'),
        automaticallyImplyLeading: false, // Sembunyikan tombol back
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.store_mall_directory_outlined, size: 80, color: kBrandPrimary),
                const SizedBox(height: 24),
                Text(
                  'Satu Langkah Lagi!',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Daftarkan nama toko Anda untuk mulai berjualan.',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _shopNameController,
                  decoration: const InputDecoration(labelText: 'Nama Toko'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama toko tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // --- WIDGET LOKASI BARU ---
                Card(
                  color: Theme.of(context).cardColor.withValues(alpha: 0.5),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, color: kSoftTeal),
                            const SizedBox(width: 8),
                            Text(
                              'Pin Lokasi Penjemputan',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (_latitude != null && _longitude != null)
                          Text(
                            'Lat: ${_latitude!.toStringAsFixed(6)}, Long: ${_longitude!.toStringAsFixed(6)}',
                            style: const TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold),
                          )
                        else
                          const Text(
                            'Lokasi belum ditentukan.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: _isFetchingLocation ? null : _fetchLocation,
                          icon: _isFetchingLocation
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.my_location),
                          label: Text(_isFetchingLocation ? 'Mencari...' : 'Gunakan Lokasi Saat Ini'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _isLoading ? null : _submitRegistration,
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Daftarkan Toko'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'states/shop_registration_state.dart';
import 'logics/shop_registration_logic.dart';

class ShopRegistrationScreen extends StatefulWidget {
  const ShopRegistrationScreen({super.key});

  @override
  State<ShopRegistrationScreen> createState() => _ShopRegistrationScreenState();
}

class _ShopRegistrationScreenState extends State<ShopRegistrationScreen> {
  final ShopRegistrationLogic _logic = ShopRegistrationLogic();

  late final ShopRegistrationState _shopState = ShopRegistrationState(
    formKey: GlobalKey<FormState>(),
    shopNameController: TextEditingController(),
    fullAddressController: TextEditingController(),
  );

  @override
  void initState() {
    super.initState();
    _logic.getCurrentLocation(
      state: _shopState,
      onUpdate: () => setState(() {}),
    );
  }

  @override
  void dispose() {
    _shopState.shopNameController.dispose();
    _shopState.fullAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftarkan Toko Anda'),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _shopState.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Selamat datang! Mari daftarkan toko pertamamu untuk mulai berjualan di Seller Sphere.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey, // Warna teks penjelas yang lebih lembut
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Langkah 2: Lengkapi Detail Toko',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _shopState.shopNameController,
                decoration: const InputDecoration(labelText: 'Nama Toko'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Nama toko tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _shopState.fullAddressController,
                decoration: const InputDecoration(labelText: 'Alamat Lengkap'),
                maxLines: 3,
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Alamat tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 24),
              const Text(
                'Sesuaikan dengan Alamat Anda:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12), // Tetap di sini untuk estetika
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      GoogleMap(
                        initialCameraPosition:
                            ShopRegistrationState.initialCameraPosition,
                        onMapCreated: (controller) =>
                            _shopState.mapController = controller,
                        // Ganti onTap dengan onCameraMove
                        onCameraMove: (position) => _logic.onCameraMove(
                          position: position,
                          state: _shopState,
                        ),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                      ),
                      const Icon(Icons.location_pin, color: Colors.red, size: 50),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _shopState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () => _logic.handleRegisterShop(
                        context: context,
                        state: _shopState,
                        setLoading: (val) =>
                            setState(() => _shopState.isLoading = val),
                      ),
                      child: const Text('Daftarkan Toko'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

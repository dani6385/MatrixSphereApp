// lib/screens/shop/shop_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:seller_sphere/features/services/profiles/shop/widgets/shop_profile_appbar.dart';
import 'package:seller_sphere/features/services/profiles/shop/widgets/shop_profile_form.dart';
import 'widgets/shop_profile_body.dart';

class ShopProfileScreen extends StatefulWidget {
  // Konstruktor tidak lagi memerlukan shopId, karena akan diambil secara otomatis.
  const ShopProfileScreen({super.key, required String shopId});

  @override
  State<ShopProfileScreen> createState() => _ShopProfileScreenState();
}

class _ShopProfileScreenState extends State<ShopProfileScreen> {
  // Variabel untuk menampung shopId yang didapat dari AuthService
  String? _shopId;

  // Tambahkan variabel untuk menyimpan data toko yang dimuat
  String? _currentShopName;
  String? _currentDescription;
  bool _isLoading = true;
  bool _isTrialMode = false;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _shopNameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _initializeShopProfile(); // Panggil fungsi inisialisasi
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  // Fungsi untuk inisialisasi: mengambil shopId lalu memuat data toko
  Future<void> _initializeShopProfile() async {
    // 1. Buat instance AuthService
    final authService = AuthService();
    // 2. Ambil shopId dari pengguna yang sedang login
    final shopId = await authService.getCurrentShopId();

    // Guard clause untuk memastikan widget masih ter-mount setelah await.
    if (!mounted) return;

    if (shopId != null) {
      setState(() {
        _isTrialMode = authService.currentUser == null; // Cek apakah dalam mode percobaan
        _shopId = shopId;
      });
      // 3. Jika shopId ditemukan, lanjutkan memuat data toko
      await _loadShopData(shopId);
    } else {
      // Handle jika shopId tidak ditemukan (misal: tampilkan error).
      // Karena sudah ada pengecekan `mounted` di atas, aman untuk menggunakan context di sini.
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat profil toko: ID Toko tidak ditemukan.')),
      );
    }
  }

  // Fungsi untuk memuat data toko dari database
  Future<void> _loadShopData(String shopId) async {
    // TODO: Implementasi logika untuk mengambil data toko dari database
    // Gunakan shopId yang didapat dari _initializeShopProfile
    // Contoh placeholder:
    await Future.delayed(const Duration(seconds: 1)); // Simulasi loading data
    setState(() {
      _currentShopName = 'Toko Agan dari DB ($shopId)'; // Ganti dengan data asli
      _currentDescription = 'Menjual berbagai macam kebutuhan sehari-hari dari DB.'; // Ganti dengan data asli
      _shopNameController = TextEditingController(text: _currentShopName);
      _descriptionController = TextEditingController(text: _currentDescription);
      _isLoading = false;
    });
  }

  void _saveProfile() {
    // Jangan lakukan apa-apa jika dalam mode percobaan
    if (_isTrialMode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login untuk mengubah profil toko.')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      // TODO: Implementasikan logika untuk menyimpan data ke database.
      // Ambil nilai dari controller:
      // final newShopName = _shopNameController.text;
      // final newDescription = _descriptionController.text;
      // Gunakan _shopId untuk mengupdate data toko yang benar.

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil toko berhasil diperbarui!')),
      );
      // Setelah berhasil disimpan, mungkin perlu memperbarui state lokal
      setState(() {
        _currentShopName = _shopNameController.text;
        _currentDescription = _descriptionController.text;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShopProfileAppBar(),
      body: ShopProfileBody(
        // Tampilkan loading indicator jika data masih dimuat
        isLoading: _isLoading,
        // Hanya tampilkan form jika _shopId tidak null dan tidak sedang loading
        child: !_isLoading && _shopId != null
            ? ShopProfileForm(
                formKey: _formKey,
                shopId: _shopId!, // Gunakan _shopId dari state
                shopNameController: _shopNameController,
                descriptionController: _descriptionController,
                onCopyShopId: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ID Toko disalin!')));
                },
                onSaveProfile: _saveProfile, // Fungsi simpan tetap sama
                // Tambahkan parameter untuk menonaktifkan tombol jika dalam mode percobaan
                isSaveDisabled: _isTrialMode,
              )
            // Tampilkan widget kosong atau pesan error jika _shopId null
            : const SizedBox.shrink(),
      ),
    );
  }
}
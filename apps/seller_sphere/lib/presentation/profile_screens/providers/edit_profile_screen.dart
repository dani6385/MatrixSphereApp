import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/presentation/profile_screens/providers/seller_profile_provider.dart';
//import 'package:seller_sphere/widgets/image_picker_options.dart';
import 'package:seller_sphere/utils/ui_helpers.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _storeNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    // Ambil data profil awal dari provider dan isi controller
    final profile = Provider.of<SellerProfileProvider>(context, listen: false).profile;
    _nameController = TextEditingController(text: profile.name);
    _storeNameController = TextEditingController(text: profile.storeName);
    _emailController = TextEditingController(text: profile.email);
    _phoneController = TextEditingController(text: profile.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _storeNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final profileProvider = Provider.of<SellerProfileProvider>(context, listen: false);
      final currentProfile = profileProvider.profile;

      // Buat objek profil baru dengan data yang diperbarui
      final updatedProfile = SellerProfile(
        id: currentProfile.id,
        address: currentProfile.address,
        profilePictureUrl: _imageFile?.path ?? currentProfile.profilePictureUrl,
        name: _nameController.text,
        storeName: _storeNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
      );

      // Panggil provider untuk memperbarui data
      profileProvider.updateProfile(updatedProfile);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui!')),
      );
      // Kembali ke halaman profil
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: 50, // Kompresi gambar untuk menghemat ruang
        maxWidth: 800,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      // Handle error
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil gambar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Simpan',
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade200,
                    // Menggunakan child agar bisa memakai errorBuilder dari Image.network
                    child: ClipOval(
                      child: _buildImageWidget(),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                        onPressed: () => showImagePickerOptions(context, onPick: _pickImage),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Lengkap'),
              validator: (value) => (value == null || value.isEmpty) ? 'Nama tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _storeNameController,
              decoration: const InputDecoration(labelText: 'Nama Toko'),
              validator: (value) => (value == null || value.isEmpty) ? 'Nama toko tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email tidak boleh kosong';
                }
                // Validasi format email menggunakan RegEx
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Masukkan format email yang valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Nomor Telepon'),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nomor telepon tidak boleh kosong';
                }
                // Anda bisa menambahkan validasi format nomor telepon yang lebih kompleks di sini
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Membangun widget gambar untuk avatar dengan penanganan error.
  Widget _buildImageWidget() {
    const double imageSize = 120; // 2 * radius

    if (_imageFile != null) {
      return Image.file(
        _imageFile!,
        fit: BoxFit.cover,
        width: imageSize,
        height: imageSize,
      );
    }

    final profileUrl = Provider.of<SellerProfileProvider>(context, listen: false).profile.profilePictureUrl;

    if (profileUrl.startsWith('http')) {
      return Image.network(
        profileUrl,
        fit: BoxFit.cover,
        width: imageSize,
        height: imageSize,
        errorBuilder: (context, error, stackTrace) {
          // Jika gagal memuat gambar dari network, tampilkan gambar default.
          return Image.asset('assets/images/default_avatar.png', fit: BoxFit.cover);
        },
      );
    }

    // Fallback ke gambar default jika tidak ada URL atau path lokal.
    return Image.asset('assets/images/default_avatar.png',
        fit: BoxFit.cover, width: imageSize, height: imageSize);
  }
}
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/providers/seller_profile_provider.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil gambar: $e')),
      );
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => ImagePickerOptions(onPick: _pickImage),
    );
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
                    backgroundImage: _buildImageProvider(),
                    backgroundColor: Colors.grey.shade200,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                        onPressed: _showImagePickerOptions,
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
            TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Nomor Telepon'), keyboardType: TextInputType.phone),
          ],
        ),
      ),
    );
  }

  ImageProvider _buildImageProvider() {
    if (_imageFile != null) {
      return FileImage(_imageFile!);
    }
    final profileUrl = Provider.of<SellerProfileProvider>(context, listen: false).profile.profilePictureUrl;
    if (profileUrl.startsWith('http')) {
      return NetworkImage(profileUrl);
    } else if (profileUrl.isNotEmpty) {
      return FileImage(File(profileUrl));
    }
    // Fallback ke gambar default jika tidak ada
    return const AssetImage('assets/images/default_avatar.png'); // Pastikan Anda punya aset ini
  }
}

/// Widget helper untuk menampilkan opsi pilihan gambar
class ImagePickerOptions extends StatelessWidget {
  final Function(ImageSource) onPick;
  const ImagePickerOptions({super.key, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Ambil Foto'),
            onTap: () {
              Navigator.of(context).pop();
              onPick(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Pilih dari Galeri'),
            onTap: () {
              Navigator.of(context).pop();
              onPick(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.close),
            title: const Text('Batal'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
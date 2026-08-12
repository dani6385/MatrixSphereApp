import 'package:flutter/material.dart';
//import 'package:shared_ui/shared_ui.dart';
import 'shop_id_card.dart';

/// Widget yang berisi form untuk mengedit profil toko.
/// Ini adalah bagian dari UI yang menampilkan input field.
class ShopProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String shopId;
  final TextEditingController shopNameController;
  final TextEditingController descriptionController;
  final VoidCallback onCopyShopId;
  final VoidCallback onSaveProfile;
  final bool isSaveDisabled; // Parameter baru

  const ShopProfileForm({
    super.key,
    required this.formKey,
    required this.shopId,
    required this.shopNameController,
    required this.descriptionController,
    required this.onCopyShopId,
    required this.onSaveProfile,
    this.isSaveDisabled = false, // Defaultnya tidak dinonaktifkan
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShopIdCard(
            shopId: shopId,
            onCopyPressed: onCopyShopId,
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: shopNameController,
            decoration: const InputDecoration(labelText: 'Nama Toko'),
            validator: (value) =>
                value!.isEmpty ? 'Nama toko tidak boleh kosong' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Deskripsi Toko'),
            maxLines: 3,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              // Nonaktifkan tombol jika isSaveDisabled adalah true
              // onPressed diisi null akan menonaktifkan tombol secara visual
              onPressed: isSaveDisabled ? null : onSaveProfile,
              child: const Text('Simpan Perubahan'),
            ),
          ),
        ],
      ),
    );
  }
}
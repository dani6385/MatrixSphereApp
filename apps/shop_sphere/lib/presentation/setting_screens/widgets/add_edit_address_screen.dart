import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop_sphere/providers/session_provider.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:uuid/uuid.dart';

class AddEditAddressScreen extends StatefulWidget {
  final AddressModel? address;

  const AddEditAddressScreen({super.key, this.address});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isPrimary = false;
  bool _isLoading = false;

  // Menentukan apakah ini mode edit atau tambah
  bool get _isEditMode => widget.address != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      // Isi controller dengan data yang ada jika dalam mode edit
      final addr = widget.address!;
      _labelController.text = addr.label;
      _nameController.text = addr.recipientName;
      _phoneController.text = addr.phoneNumber;
      _addressController.text = addr.fullAddress;
      _isPrimary = addr.isPrimary;
    }
  }
  @override
  void dispose() {
    _labelController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      final sessionProvider = context.read<SessionProvider>();
      final messenger = ScaffoldMessenger.of(context);
      final navigator = context;

      try {
        if (_isEditMode) {
          // Mode Edit: Panggil updateAddress
          final updatedAddress = AddressModel(
            id: widget.address!.id, // Gunakan ID yang ada
            label: _labelController.text,
            recipientName: _nameController.text,
            phoneNumber: _phoneController.text,
            fullAddress: _addressController.text,
            isPrimary: _isPrimary,
          );
          await sessionProvider.updateAddress(updatedAddress);
          messenger.showSnackBar(const SnackBar(content: Text('Alamat berhasil diperbarui!')));
        } else {
          // Mode Tambah: Panggil addAddress
          final newAddress = AddressModel(
            id: const Uuid().v4(), // Generate ID baru
            label: _labelController.text,
            recipientName: _nameController.text,
            phoneNumber: _phoneController.text,
            fullAddress: _addressController.text,
            isPrimary: _isPrimary,
          );
          await sessionProvider.addAddress(newAddress);
          messenger.showSnackBar(const SnackBar(content: Text('Alamat baru berhasil disimpan!')));
        }
        // Pastikan widget masih ada sebelum melakukan navigasi.
        if (navigator.mounted) {
          navigator.pop();
        }
      } catch (e) {
        messenger.showSnackBar(SnackBar(content: Text('Gagal: ${e.toString()}')));
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Alamat' : 'Tambah Alamat Baru'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _labelController,
              decoration: const InputDecoration(labelText: 'Label Alamat (Contoh: Rumah, Kantor)'),
              validator: (value) => (value?.isEmpty ?? true) ? 'Label tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Penerima'),
              validator: (value) => (value?.isEmpty ?? true) ? 'Nama tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Nomor Telepon'),
              keyboardType: TextInputType.phone,
              validator: (value) => (value?.isEmpty ?? true) ? 'Nomor telepon tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Alamat Lengkap'),
              maxLines: 3,
              validator: (value) => (value?.isEmpty ?? true) ? 'Alamat tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Jadikan Alamat Utama'),
              value: _isPrimary,
              onChanged: (value) {
                setState(() {
                  _isPrimary = value;
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryButton(
          onPressed: _isLoading ? null : _saveAddress,
          child: _isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                )
              : Text(_isEditMode ? 'Simpan Perubahan' : 'Simpan Alamat'),
        ),
      ),
    );
  }
}
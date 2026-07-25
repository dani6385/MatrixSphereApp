// lib/feature/employees/add_edit_employee_screen.dart
import 'package:flutter/material.dart';
import 'models/employee_model.dart';

class AddEditEmployeeScreen extends StatefulWidget {
  final Employee? employee; // Jika null, berarti mode 'Tambah Baru'

  const AddEditEmployeeScreen({super.key, this.employee});

  @override
  State<AddEditEmployeeScreen> createState() => _AddEditEmployeeScreenState();
}

class _AddEditEmployeeScreenState extends State<AddEditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _roleController;

  bool get _isEditing => widget.employee != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name);
    _emailController = TextEditingController(text: widget.employee?.email);
    _phoneController = TextEditingController(text: widget.employee?.phone);
    _roleController = TextEditingController(text: widget.employee?.role);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Logika untuk menyimpan data
      // Di sini Anda bisa memanggil BLoC atau service untuk
      // menyimpan data ke backend/database.
      final name = _nameController.text;
      // ... dan seterusnya

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Karyawan "$name" berhasil ${ _isEditing ? 'diperbarui' : 'ditambahkan'}.'),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Karyawan' : 'Tambah Karyawan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Masukkan email yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor telepon tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(
                  labelText: 'Jabatan/Posisi',
                  hintText: 'Contoh: Kasir, Staf Gudang',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jabatan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(_isEditing ? 'Simpan Perubahan' : 'Tambah Karyawan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

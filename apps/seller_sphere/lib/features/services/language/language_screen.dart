// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

/// Halaman untuk memilih bahasa aplikasi.
class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  // Variabel state untuk menyimpan bahasa yang dipilih.
  // Dalam aplikasi nyata, ini akan diinisialisasi dari preferensi pengguna
  // dan akan memicu perubahan locale aplikasi secara keseluruhan.
  String? _selectedLanguage = 'id'; // Default ke Bahasa Indonesia

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Bahasa'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildLanguageOption(title: 'Bahasa Indonesia', value: 'id'),
          _buildLanguageOption(title: 'English', value: 'en'),
          _buildLanguageOption(title: 'Sistem (Default)', value: null),
          // Anda bisa menambahkan lebih banyak opsi bahasa di sini
        ],
      ),
    );
  }
  
  void _handleLanguageChange(String? value) {
    setState(() {
      _selectedLanguage = value;
      final String message;
      if (value == 'id') {
        message = 'Bahasa diubah ke Indonesia';
      } else if (value == 'en') {
        message = 'Language changed to English';
      } else {
        message = 'Bahasa diatur mengikuti sistem';
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    });
  }

  /// Widget helper untuk membuat setiap opsi bahasa.
  Widget _buildLanguageOption({
    required String title,
    required String? value,
  }) {
    return ListTile(
      title: Text(title),
      leading: Radio<String?>(
        value: value,
        groupValue: _selectedLanguage,
        onChanged: (String? newValue) => _handleLanguageChange(newValue),
      ),
      onTap: () => _handleLanguageChange(value),
    );
  }
}
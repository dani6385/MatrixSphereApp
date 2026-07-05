import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

import 'widgets/address_management_screen.dart';
class SettingsScreen extends StatelessWidget {
  final String title;

  const SettingsScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.surface,
      ),
      body: _buildBody(title),
    );
  }

  Widget _buildBody(String title) {
    switch (title) {
      case 'Alamat Pengiriman':
        return const AddressManagementScreen();
      // Tambahkan case lain di sini untuk fitur selanjutnya
      // case 'Metode Pembayaran':
      //   return const PaymentMethodView();
      default:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction_rounded, size: 80, color: Colors.grey),
              SizedBox(height: 16),
              Text('Fitur Segera Hadir!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Kami sedang bekerja keras untuk Anda.', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
        );
    }
  }
}
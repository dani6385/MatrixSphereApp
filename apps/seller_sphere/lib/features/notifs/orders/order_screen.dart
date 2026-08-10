// lib/features/management/screens/order_screen.dart (atau sesuaikan dengan direktori project-mu)

import 'package:flutter/material.dart';
// Menyesuaikan dengan import service yang kamu miliki
import 'package:seller_sphere/navigations/app_extractor.dart'; // Mengimpor file OrderListView yang sudah ada

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Orderan'),
        elevation: 0,
      ),
      // Menggunakan FutureBuilder atau langsung memanggil komponen OrderListView 
      // bergantung pada bagaimana data pesanan disediakan oleh service-mu.
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: _buildOrderBody(context),
      ),
    );
  }

  // Fungsi pembantu untuk memuat data pesanan
  Widget _buildOrderBody(BuildContext context) {
    // CONTOH: Jika menggunakan data list statis atau mengambil dari state management/service.
    // Di sini kita sediakan wadah penampung data pesanan.
    // Kamu bisa mengganti bagian ini dengan StreamBuilder/FutureBuilder jika mengambil dari API/Database.
    
// Ganti dengan sumber data pesaneanan aslimu

    // Jika data kosong, OrderListView sudah memiliki widget tampilan kosong (empty state) yang informatif
    return const OrderListView(shopId: 'toko_agan',);
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_ui/shared_ui.dart';

import 'providers/order_provider.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  const OrderSuccessScreen({super.key, required this.orderId});
  
  @override
  Widget build(BuildContext context) {
    final order = Provider.of<OrderProvider>(context, listen: false).findById(orderId);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('Pesanan tidak ditemukan.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan Berhasil'),
        automaticallyImplyLeading: false, // Sembunyikan tombol kembali
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 100),
              const SizedBox(height: 24),
              const Text(
                'Pesanan Anda Telah Dikonfirmasi!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Tunjukkan QR code atau kode verifikasi berikut kepada penjual saat Anda menjemput pesanan.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const Text(
                'QR CODE & KODE VERIFIKASI',
                style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildVerificationCodeBox(context, order),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
              _buildOrderSummary(order),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryButton(
          child: const Text('Kembali ke Beranda'),
          onPressed: () => context.go('/home'),
        ),
      ),
    );
  }

  Widget _buildVerificationCodeBox(BuildContext context, Order order) {
    // Data yang akan di-encode ke dalam QR code
    final qrData = jsonEncode({
      'orderId': order.id,
      'verificationCode': order.verificationCode,
    });

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          // Widget untuk menampilkan QR Code
          QrImageView(
            data: qrData,
            version: QrVersions.auto,
            size: 200.0,
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 24),
          const Text('Kode Verifikasi Manual', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: order.verificationCode));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kode verifikasi disalin ke clipboard!')),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  order.verificationCode,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.copy, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(Order order) {
    return Column(
      children: [
        Text('ID Pesanan: ${order.id}', style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        Text(
          'Total Pembayaran: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(order.totalAmount)}',
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
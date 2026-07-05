import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Model sederhana untuk pendaftaran seller yang tertunda
class PendingSeller {
  final String id;
  final String partnerName;
  final String email;
  final DateTime registrationDate;

  const PendingSeller({
    required this.id,
    required this.partnerName,
    required this.email,
    required this.registrationDate,
  });
}

class SellerRegistrationListScreen extends StatelessWidget {
  const SellerRegistrationListScreen({super.key});

  // Data dummy untuk demonstrasi
  static final List<PendingSeller> _pendingSellers = [
    PendingSeller(id: 'seller-001', partnerName: 'Toko Jaya Abadi', email: 'jaya.abadi@email.com', registrationDate: DateTime(2023, 10, 26)),
    PendingSeller(id: 'seller-002', partnerName: 'Warung Bu Siti', email: 'siti.warung@email.com', registrationDate: DateTime(2023, 10, 25)),
    PendingSeller(id: 'seller-003', partnerName: 'Gadget Store ID', email: 'contact@gadgetstore.id', registrationDate: DateTime(2023, 10, 24)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendaftaran Seller Sphere'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: _pendingSellers.length,
        itemBuilder: (context, index) {
          final seller = _pendingSellers[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.storefront_outlined),
              title: Text(seller.partnerName),
              subtitle: Text('Mendaftar pada: ${DateFormat.yMMMd().format(seller.registrationDate)}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Di sini Anda bisa navigasi ke layar detail pendaftaran
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lihat detail untuk ${seller.partnerName}')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
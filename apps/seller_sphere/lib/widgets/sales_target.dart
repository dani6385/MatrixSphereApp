import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class SalesTarget extends StatelessWidget {
  const SalesTarget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: kDarkSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Target Penjualan Harian',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Ubah'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Expanded(
                child: LinearProgressIndicator(
                  value: 0.75,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '75%',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Rp 750.000 / Rp 1.000.000',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'Hampir sampai 75% target tercapai. Tambah beberapa transaksi lagi untuk mencapai sukses hari ini!',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

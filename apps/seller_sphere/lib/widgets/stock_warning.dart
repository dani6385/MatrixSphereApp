import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class StockWarning extends StatelessWidget {
  const StockWarning({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: kDarkSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Stok segera habis',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
              Icon(Icons.warning, color: Colors.red),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Cek 5 produk yang stoknya hampir habis. Jangan sampai kehabisan & kehilangan pelanggan!',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('Lihat Produk'),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class OrderStatistics extends StatelessWidget {
  const OrderStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF171C22),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistik Pengambilan Pesanan Toko',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Ketuk item untuk detail paket masuk & pengambilan oleh pembeli',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                color: Colors.green,
              ),
              const SizedBox(width: 8),
              const Text('Selesai Diambil', style: TextStyle(color: Colors.white70)),
              const SizedBox(width: 16),
              Container(
                width: 10,
                height: 10,
                color: kWarmOrange,
              ),
              const SizedBox(width: 8),
              const Text('Belum Diambil', style: TextStyle(color: Colors.white70)),
              const Spacer(),
              const Text('5 Pesanan', style: TextStyle(color: Colors.blue)),
            ],
          )
        ],
      ),
    );
  }
}

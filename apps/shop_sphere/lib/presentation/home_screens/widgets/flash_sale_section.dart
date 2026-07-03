import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart'; // Jika ada widget reusable di sini

class FlashSaleSection extends StatelessWidget {
  const FlashSaleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Judul Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Flash Sale",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text("Berakhir dalam 02:00:00", 
                   style: TextStyle(color: Colors.red, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Daftar Produk Horizontal
        SizedBox(
          height: 150,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 3, // Contoh jumlah item
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return Container(
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 4)],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag, size: 40, color: Colors.teal),
                    const SizedBox(height: 8),
                    Text("Produk $index", style: const TextStyle(fontSize: 12)),
                    const Text("Rp 50.000", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
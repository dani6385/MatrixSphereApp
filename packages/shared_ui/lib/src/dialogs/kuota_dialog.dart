import 'package:flutter/material.dart';

void showBeliKuota(BuildContext context) {
  final List<Map<String, String>> packages = [
    {'name': 'Paket Hemat', 'desc': '1 GB - 24 Jam', 'price': 'Rp 5.000'},
    {'name': 'Paket Seru', 'desc': '5 GB - 7 Hari', 'price': 'Rp 20.000'},
  ];

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Pilih Paket Kuota", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...packages.map((pkg) => ListTile(
                  title: Text(pkg['name']!),
                  subtitle: Text(pkg['desc']!),
                  trailing: Text(pkg['price']!),
                  onTap: () => Navigator.pop(context),
                )),
          ],
        ),
      );
    },
  );
}
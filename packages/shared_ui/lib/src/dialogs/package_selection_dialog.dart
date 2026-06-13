import 'package:flutter/material.dart';

// Model sederhana untuk data paket internet
class InternetPackage {
  final String name;
  final int price;
  final String validity;

  const InternetPackage({required this.name, required this.price, required this.validity});
}

// Dialog untuk memilih paket internet
Future<InternetPackage?> showPackageSelectionDialog(BuildContext context, List<InternetPackage> packages) {
  return showDialog<InternetPackage>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Pilih Paket Internet'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: packages.map((package) {
              return ListTile(
                title: Text(package.name),
                subtitle: Text('Rp ${package.price} - Berlaku ${package.validity}'),
                onTap: () {
                  Navigator.pop(context, package); // Kembalikan paket yang dipilih
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () {
              Navigator.pop(context, null);
            },
          ),
        ],
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class PackageStatus extends StatelessWidget {
  const PackageStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: kDarkSurface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(Icons.warning, color: Colors.orange),
                SizedBox(height: 8),
                Text(
                  '4 Paket',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Belum Diambil',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: kDarkSurface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(height: 8),
                Text(
                  '1 Paket',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Selesai Diambil',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

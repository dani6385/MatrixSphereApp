import 'package:flutter/material.dart';

class SystemIntegrityCard extends StatelessWidget {
  const SystemIntegrityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('SYSTEM INTEGRITY: ACTIVE', style: TextStyle(color: Colors.orange)),
          const SizedBox(height: 10),
          Text(
            'Berjalan dalam Offline-first Mode. Database lokal Room siap menyinkronkan data begitu google-services.json diaktifkan.',
            style: TextStyle(color: Colors.white.withAlpha(178)),
          ),
        ],
      ),
    );
  }
}

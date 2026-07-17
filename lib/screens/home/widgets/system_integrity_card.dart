import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class SystemIntegrityCard extends StatelessWidget {
  const SystemIntegrityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: kDarkTextSecondary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: kWarmOrange.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('SYSTEM INTEGRITY: ACTIVE', style: TextStyle(color: Colors.orange)),
          const SizedBox(height: 10),
          Text(
            'Berjalan dalam Offline-first Mode. Database lokal Room siap menyinkronkan data begitu google-services.json diaktifkan.',
            style: TextStyle(color: kTextOnDarkPrimary.withAlpha(178)),
          ),
        ],
      ),
    );
  }
}

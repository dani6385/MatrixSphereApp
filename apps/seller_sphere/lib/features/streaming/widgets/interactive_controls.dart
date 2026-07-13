import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

import 'control_tab.dart';

class InteractiveControls extends StatelessWidget {
  const InteractiveControls({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kDarkSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('KONTROL INTERAKTIF', style: textTheme.labelSmall?.copyWith(color: Colors.grey)),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.play_arrow, size: 16),
                label: const Text('Mulai Live'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kSeaGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              ControlTab(text: 'Live Chat', icon: Icons.chat_bubble_outline, isActive: true),
              SizedBox(width: 16),
              ControlTab(text: 'Semakan Produk', icon: Icons.production_quantity_limits, isActive: false),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Putar Video Demo Otomatis', style: textTheme.bodyMedium?.copyWith(color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(
                      'Saat siaran dimulai, sistem akan memutar video promo...',
                      style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Switch(value: true, onChanged: (value) {}, activeColor: kPurple),
            ],
          ),
          const SizedBox(height: 16),
          Text('PILIH SUMBER VIDEO SIMULASI', style: textTheme.labelSmall?.copyWith(color: Colors.grey)),
        ],
      ),
    );
  }
}

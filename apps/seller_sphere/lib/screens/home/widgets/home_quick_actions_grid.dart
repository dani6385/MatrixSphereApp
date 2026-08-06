// lib/screens/home/widgets/home_quick_actions_grid.dart
import 'package:flutter/material.dart';
import 'package:seller_sphere/navigations/app_extractor.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:logger/logger.dart';

final Logger _logger = Logger();

class HomeQuickActionsGrid extends StatelessWidget {
  const HomeQuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        QuickActionChip(
            icon: Icons.add_box_outlined,
            label: 'Produk',
            onPressed: () {
        _logger.i('Menu Products diklik!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => const AddProductScreen(),
          ),
        );
      },
            //onTap: () => const AddProductScreen()
            ),
        QuickActionChip(icon: Icons.qr_code_scanner, label: 'Scan', onPressed: () {
    // Tulis logika ketika tombol Scan diklik di sini
    _logger.i('Tombol Scan QR diklik!');
    
    // Contoh: Membuka halaman scanner atau memunculkan dialog
    // Navigator.push(context, MaterialPageRoute(builder: (context) => const QrScannerScreen()));
  },
),
        QuickActionChip(icon: Icons.bar_chart_outlined, label: 'Laporan', onPressed: () {  },),
        QuickActionChip(icon: Icons.chat_bubble_outline, label: 'Chat', onPressed: () {  },),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:seller_sphere/screens/inventory/widgets/inventory_dialogs.dart';
import 'package:shared_ui/shared_ui.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 13,
          child: ElevatedButton.icon(
            onPressed: () => InventoryDialogs.showProductFormDialog(context),
            icon: const Icon(Icons.add),
            label: const Text("Tambah Barang"),
            style: ElevatedButton.styleFrom(
              backgroundColor: kNeonCyan,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 10,
          child: OutlinedButton.icon(
            onPressed: () => InventoryDialogs.showCsvDialog(context),
            icon: const Icon(Icons.import_export),
            label: const Text("Impor/Ekspor"),
            style: OutlinedButton.styleFrom(
              foregroundColor: kNeonCyan,
              side: const BorderSide(color: kNeonCyan),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}

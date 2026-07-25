import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/screens/inventory_bottom/providers/inventory_provider.dart';
import 'package:shared_ui/shared_ui.dart';

class SafeModeCard extends StatelessWidget {
  const SafeModeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<InventoryProvider>(
      builder: (context, provider, child) {
        return Card(
          color: provider.isSafeModeEnabled
              ? theme.primaryColor.withValues(alpha: 0.05)
              : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
                color: provider.isSafeModeEnabled
                    ? kNeonCyan.withValues(alpha: 0.3)
                    : theme.colorScheme.outline.withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text("Safe Mode",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                subtitle: Text(
                  provider.isSafeModeEnabled
                      ? "Filter hasil pencarian sesuai batas usia"
                      : "Batas usia pencarian tidak aktif",
                  style: const TextStyle(fontSize: 10),
                ),
                value: provider.isSafeModeEnabled,
                onChanged: (value) => provider.setSafeMode(value),
                secondary: Icon(
                  provider.isSafeModeEnabled
                      ? Icons.shield
                      : Icons.verified_user,
                  color: provider.isSafeModeEnabled
                      ? kNeonCyan
                      : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ),
              if (provider.isSafeModeEnabled)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Batas Usia:", style: TextStyle(fontSize: 11)),
                      ToggleButtons(
                        isSelected: [
                          provider.safeModeAgeLimit == 0,
                          provider.safeModeAgeLimit == 13,
                          provider.safeModeAgeLimit == 18
                        ],
                        onPressed: (index) {
                          provider.setSafeModeAgeLimit([0, 13, 18][index]);
                        },
                        borderRadius: BorderRadius.circular(8),
                        constraints:
                            const BoxConstraints(minHeight: 32, minWidth: 60),
                        children: const [
                          Text("SU"),
                          Text("13+"),
                          Text("18+")
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

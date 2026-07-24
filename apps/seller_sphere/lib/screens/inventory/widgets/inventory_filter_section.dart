import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/screens/inventory/providers/inventory_provider.dart';


class InventoryFilterSection extends StatelessWidget {
  const InventoryFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: provider.categories.map((category) {
                    final isSelected = provider.selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            provider.updateCategory(category);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            // Sort Dropdown
            DropdownButton<String>(
              value: provider.selectedSortKey,
              underline: Container(),
              items: provider.sortOptions.entries.map((entry) {
                return DropdownMenuItem(
                    value: entry.key, child: Text(entry.value));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  provider.updateSortKey(value);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
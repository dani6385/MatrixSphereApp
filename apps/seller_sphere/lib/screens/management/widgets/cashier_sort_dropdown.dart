// lib/screens/management/widgets/cashier_sort_dropdown.dart

import 'package:flutter/material.dart';

// Definisi enum sortir (bisa ditaruh di file terpisah jika ingin lebih rapi)
enum ProductSortOption {
  none,
  mostSold,
  priceLowToHigh,
  priceHighToLow,
  nameAsc,
  nameDesc,
}

class CashierSortDropdown extends StatelessWidget {
  final ProductSortOption currentSortOption;
  final ValueChanged<ProductSortOption?> onChanged;

  const CashierSortDropdown({
    super.key,
    required this.currentSortOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: DropdownButtonFormField<ProductSortOption>(
        initialValue: currentSortOption,
        decoration: const InputDecoration(
          labelText: 'Urutkan Berdasarkan',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: const [
          DropdownMenuItem(
            value: ProductSortOption.none,
            child: Text('Default'),
          ),
          DropdownMenuItem(
            value: ProductSortOption.mostSold,
            child: Text('Terlaris'),
          ),
          DropdownMenuItem(
            value: ProductSortOption.priceLowToHigh,
            child: Text('Harga Terendah'),
          ),
          DropdownMenuItem(
            value: ProductSortOption.priceHighToLow,
            child: Text('Harga Tertinggi'),
          ),
          DropdownMenuItem(
            value: ProductSortOption.nameAsc,
            child: Text('Nama (A-Z)'),
          ),
          DropdownMenuItem(
            value: ProductSortOption.nameDesc,
            child: Text('Nama (Z-A)'),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
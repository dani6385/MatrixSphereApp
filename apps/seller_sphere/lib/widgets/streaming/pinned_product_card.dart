import 'package:flutter/material.dart';
import 'package:seller_sphere/models/product.dart';
import 'package:intl/intl.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:seller_sphere/viewmodel/app_viewmodel.dart';

class PinnedProductCard extends StatelessWidget {
  final Product product;
  final AppViewModel viewModel;

  const PinnedProductCard({
    super.key,
    required this.product,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: kNeonCyan.withValues(alpha: 0.5), width: 1),
      ),
      child: SizedBox(
        width: 135,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 36,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.shopping_bag, color: kNeonCyan, size: 16),
              ),
              const SizedBox(height: 4),
              Text(
                product.name,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(product.price),
                style: const TextStyle(fontSize: 9, color: kSoftTeal, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(color: kNeonCyan, borderRadius: BorderRadius.circular(4)),
                alignment: Alignment.center,
                child: const Text("TERSEMAT", style: TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
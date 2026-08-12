
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produk ${product.name} diklik!')),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: kLightBackground.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: kLightTextPrimary.withValues(alpha: 0.2),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                product.imageUrl ?? '',
                height: 60,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 60,
                  color: Colors.grey,
                  child:
                      const Icon(Icons.broken_image, color: kLightBackground),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: kLightTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ')
                        .format(product.unitPrice),
                    style: const TextStyle(
                      fontSize: 10,
                      color: kLightBackground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
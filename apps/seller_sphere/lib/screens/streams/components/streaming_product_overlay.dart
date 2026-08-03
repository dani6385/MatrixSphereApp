import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import '../widgets/product_card.dart';

class StreamingProductOverlay extends StatelessWidget {
  final List<Product> products;

  const StreamingProductOverlay({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      left: 10,
      child: SizedBox(
        width: 120,
        height: 200,
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) =>
              ProductCard(product: products[index]),
        ),
      ),
    );
  }
}
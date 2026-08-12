import 'package:flutter/material.dart';
import 'controllers/inventory_logic.dart';
import 'package:shared_services/shared_services.dart';
import 'components/inventory_list_view.dart';
//import 'package:seller_sphere/navigations/app_extractor.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final ProductService _productService = ProductService();
  final InventoryLogic _inventoryLogic =
      InventoryLogic(); // Instantiate the logic

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventaris Produk'),
      ),
      body: StreamBuilder<List<Product>>(
        stream: _productService.getProductsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Use InventoryListView's empty state
            return InventoryListView(
              products: const [],
              onStockUpdateCallback: (product, newStock) {
                _inventoryLogic.updateProductStockDirectly(context, product, newStock);
              },
            );
          }

          final products = snapshot.data!;
          return InventoryListView(
            products: products,
            onStockUpdateCallback: (product, newStock) {
              _inventoryLogic.updateProductStockDirectly(context, product, newStock);
            },
          );
        },
      ),
    );
  }
}

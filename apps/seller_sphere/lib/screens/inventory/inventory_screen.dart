import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/models/product.dart';
import 'package:seller_sphere/screens/inventory/providers/inventory_provider.dart';
import 'package:seller_sphere/screens/inventory/widgets/inventory_app_bar.dart';
import 'package:seller_sphere/screens/inventory/widgets/inventory_drawer.dart';
import 'package:seller_sphere/screens/inventory/widgets/inventory_enddrawer.dart';
import 'package:seller_sphere/screens/inventory/widgets/inventory_filter_section.dart';
import 'package:seller_sphere/screens/inventory/widgets/inventory_stats_section.dart';
import 'package:seller_sphere/screens/inventory/widgets/low_stock_warning.dart';
import 'package:seller_sphere/screens/inventory/widgets/product_list_section.dart';
import 'package:seller_sphere/screens/inventory/widgets/quick_actions_section.dart';
import 'package:seller_sphere/screens/inventory/widgets/safe_mode_card.dart';

class InventoryScreen extends StatefulWidget {
  final void Function(Product) onNavigateToLabelPrinter;

  const InventoryScreen({
    super.key,
    required this.onNavigateToLabelPrinter,
  });

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InventoryProvider(),
      child: Consumer<InventoryProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: InventoryAppBar(
              onSearchChanged: (query) {
                provider.updateSearchQuery(query);
              },
            ),
            drawer: const InventoryDrawer(),
            endDrawer: const InventoryEndDrawer(),
            body: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const SafeModeCard(),
                const SizedBox(height: 12),
                const InventoryFilterSection(),
                const SizedBox(height: 16),
                const QuickActionsSection(),
                const SizedBox(height: 12),
                const InventoryStatsSection(),
                const SizedBox(height: 12),
                const LowStockWarning(),
                const SizedBox(height: 16),
                ProductListSection(
                  onNavigateToLabelPrinter: widget.onNavigateToLabelPrinter,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
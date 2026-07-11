
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/app_view_model.dart' hide AppViewModel, Product;
import 'package:shared_ui/shared_ui.dart'; // Assuming colors are here
import 'dashboard_screen.dart'; // For OrderPickupItem, assuming it's defined here

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  int _activeTab = 0;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppViewModel>();
    final pendingPackingCount = viewModel.shopsphereOrders.where((o) => o.status == "Perlu Dipacking").length;
    final tabs = [
      "Kasir POS",
      pendingPackingCount > 0 ? "Orderan Masuk ($pendingPackingCount)" : "Orderan Masuk"
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Custom Segmented Pill Tab Selector
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: List.generate(tabs.length, (index) {
                    final isSelected = _activeTab == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _activeTab = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? neonCyan : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tabs[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isSelected ? const Color(0xFF090D1A) : Theme.of(context).colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _activeTab == 0
                    ? const _PosTabContent()
                    : const _OrdersTabContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- KASIR (POS) TAB WIDGETS ---

class _PosTabContent extends StatefulWidget {
  const _PosTabContent();

  @override
  __PosTabContentState createState() => __PosTabContentState();
}

class __PosTabContentState extends State<_PosTabContent> {
  String _searchQuery = "";

  void _showCheckoutSheet() {
    final viewModel = context.read<AppViewModel>();
    final cart = viewModel.cart;
    final cartTotal = cart.entries.fold<double>(0, (sum, e) => sum + e.key.sellingPrice * e.value);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _CheckoutSheet(
          cart: cart,
          cartTotal: cartTotal,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppViewModel>();
    final products = viewModel.products;
    final cart = viewModel.cart;

    final filteredProducts = products.where((p) =>
        p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        p.sku.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    
    final cartTotal = cart.entries.fold<double>(0, (sum, e) => sum + e.key.sellingPrice * e.value);

    return Stack(
      children: [
        Column(
          children: [
            // Search Bar
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: const InputDecoration(
                hintText: "Cari barang untuk dijual...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              ),
            ),
            const SizedBox(height: 12),
            // Products Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 80), // Padding for floating bar
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.9,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return _PosProductCard(
                    product: product,
                    cartQty: cart[product] ?? 0,
                  );
                },
              ),
            ),
          ],
        ),
        // Floating Cart Bar
        if (cart.isNotEmpty)
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: _FloatingCartBar(
              onTap: _showCheckoutSheet,
              totalItems: cart.values.fold(0, (sum, qty) => sum + qty),
              cartTotal: cartTotal,
            ),
          ),
      ],
    );
  }
}

class _PosProductCard extends StatelessWidget {
  final Product product;
  final int cartQty;

  const _PosProductCard({required this.product, required this.cartQty});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<AppViewModel>();
    final isOutOfStock = product.stock <= 0;

    return Card(
      color: isOutOfStock
          ? Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
          : product.isLowStock
              ? const Color(0xFF281116)
              : Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: product.isLowStock && !isOutOfStock
            ? const BorderSide(color: Color(0xFF991B1B))
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: isOutOfStock ? null : () => viewModel.addToCart(product),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: isOutOfStock ? Colors.white.withValues(alpha: 0.5) : Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "SKU: ${product.sku}",
                          style: TextStyle(
                            fontSize: 9,
                            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (cartQty > 0)
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: neonCyan,
                      child: Text(
                        cartQty.toString(),
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                alignItems: Alignment.center,
                children: [
                  Text(
                    viewModel.formatRupiah(product.sellingPrice),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: neonCyan),
                  ),
                  Text(
                    isOutOfStock ? "Habis" : "Stok: ${product.stock}",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isOutOfStock
                          ? radiantRose
                          : product.isLowStock
                              ? warmOrange
                              : softTeal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingCartBar extends StatelessWidget {
  final VoidCallback onTap;
  final int totalItems;
  final double cartTotal;

  const _FloatingCartBar({required this.onTap, required this.totalItems, required this.cartTotal});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppViewModel>();
    return Card(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: neonCyan.withValues(alpha: 0.5)),
      ),
      elevation: 8,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 64,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: neonCyan,
                      child: Text(totalItems.toString(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Keranjang Belanja", style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text(viewModel.formatRupiah(cartTotal), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: neonCyan)),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: softTeal,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Text("Transaksi", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, color: Colors.black, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckoutSheet extends StatefulWidget {
  final Map<Product, int> cart;
  final double cartTotal;

  const _CheckoutSheet({required this.cart, required this.cartTotal});

  @override
  __CheckoutSheetState createState() => __CheckoutSheetState();
}

class __CheckoutSheetState extends State<_CheckoutSheet> {
  late String _selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    _selectedPaymentMethod = context.read<AppViewModel>().defaultPaymentMethod;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<AppViewModel>();
    final totalItems = widget.cart.values.fold(0, (sum, qty) => sum + qty);

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Keranjang Belanja ($totalItems Barang)", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              TextButton(
                onPressed: () {
                  viewModel.clearCart();
                  Navigator.pop(context);
                },
                child: const Text("Hapus Semua", style: TextStyle(color: radiantRose)),
              )
            ],
          ),
          const Divider(),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 240),
            child: ListView(
              shrinkWrap: true,
              children: widget.cart.entries.map((entry) {
                return _CartItemRow(product: entry.key, quantity: entry.value);
              }).toList(),
            ),
          ),
          const Divider(),
          const Text("Metode Pembayaran", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          _PaymentMethodSelector(
            selectedMethod: _selectedPaymentMethod,
            onChanged: (method) => setState(() => _selectedPaymentMethod = method),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Bayar", style: TextStyle(fontSize: 16)),
              Text(viewModel.formatRupiah(widget.cartTotal), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: neonCyan)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                viewModel.checkout(_selectedPaymentMethod);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.receipt),
              label: const Text("Bayar & Cetak Nota"),
              style: ElevatedButton.styleFrom(backgroundColor: softTeal, foregroundColor: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
    final Product product;
    final int quantity;
    const _CartItemRow({required this.product, required this.quantity});

    @override
    Widget build(BuildContext context) {
      final viewModel = context.read<AppViewModel>();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(viewModel.formatRupiah(product.sellingPrice * quantity), style: const TextStyle(color: neonCyan)),
                    ],
                  ),
                ),
                Row(
                    children: [
                        IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => viewModel.removeFromCart(product)),
                        Text(quantity.toString()),
                        IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => viewModel.addToCart(product)),
                    ],
                )
            ],
          ),
        );
    }
}

class _PaymentMethodSelector extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onChanged;

  const _PaymentMethodSelector({required this.selectedMethod, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const methods = ["Tunai", "QRIS", "Transfer"];
    return Row(
      children: methods.map((method) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(method, style: const TextStyle(fontSize: 12)),
              selected: selectedMethod == method,
              onSelected: (_) => onChanged(method),
              selectedColor: neonCyan.withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: selectedMethod == method ? neonCyan : Colors.grey)
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// --- ORDERAN MASUK TAB WIDGETS ---

class _OrdersTabContent extends StatefulWidget {
  const _OrdersTabContent();
  @override
  __OrdersTabContentState createState() => __OrdersTabContentState();
}

class __OrdersTabContentState extends State<_OrdersTabContent> {
  String _searchQuery = "";
  String _selectedFilter = "Semua";

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppViewModel>();
    final orders = viewModel.shopsphereOrders;

    final filteredOrders = orders.where((order) {
      final matchesSearch = order.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          order.customerName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedFilter == "Semua" || order.status == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();

    return Column(
      children: [
         // Search
        TextField(
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: const InputDecoration(
            hintText: "Cari ID order, nama...",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        // Filter Chips
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: ["Semua", "Perlu Dipacking", "Siap Diambil", "Selesai Diambil"].map((filter) {
                    return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                            label: Text(filter, style: const TextStyle(fontSize: 12)),
                            selected: _selectedFilter == filter,
                            onSelected: (_) => setState(() => _selectedFilter = filter),
                        ),
                    );
                }).toList(),
            ),
        ),
        const SizedBox(height: 12),
        // Orders List
        Expanded(
          child: filteredOrders.isEmpty
              ? const Center(child: Text("Tidak ada orderan ditemukan."))
              : ListView.builder(
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
                    // Using the previously defined OrderPickupItem from dashboard_screen
                    return OrderPickupItem(order: order, viewModel: viewModel);
                  },
                ),
        ),
      ],
    );
  }
}

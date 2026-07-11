import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/shared_ui.dart';
import '../viewmodels/app_view_model.dart';

class InventoryScreen extends StatefulWidget {
  final Function(Product) onNavigateToLabelPrinter;

  const InventoryScreen({super.key, required this.onNavigateToLabelPrinter});

  @override
  State<InventoryScreen> createState() {
    return _InventoryScreenState();
  }
}

class _InventoryScreenState extends State<InventoryScreen> {
  String _searchQuery = "";
  String _selectedCategory = "Semua";
  final String _selectedSortKey = "Alphabetical";

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) => ProductFormDialog(
        title: "Tambah Produk Baru",
        onSave: (name, sku, stock, purchase, sell, cat, threshold, images) {
          context.read<AppViewModel>().addProduct(
            name: name,
            stock: stock,
            purchasePrice: purchase,
            sellingPrice: sell,
            minStockThreshold: threshold,
            // sku: sku,
            // category: cat,
            // imageUrls: images,
          );
        },
      ),
    );
  }

  void _showEditProductDialog(Product product) {
    showDialog(
      context: context,
      builder: (context) => ProductFormDialog(
        title: "Ubah Produk",
        product: product,
        onSave: (name, sku, stock, purchase, sell, cat, threshold, images) {
          final updatedProduct = product.copyWith(
            name: name,
            sku: sku,
            stock: stock,
            purchasePrice: purchase,
            sellingPrice: sell,
            category: cat,
            minStockThreshold: threshold,
            imageUrls: images,
          );
          context.read<AppViewModel>().updateProduct(updatedProduct);
        },
      ),
    );
  }

  void _showDeleteDialog(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Produk?"),
        content: Text("Anda yakin ingin menghapus '${product.name}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              context.read<AppViewModel>().deleteProduct(product);
              Navigator.pop(context);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppViewModel>();
    final categories =
        ["Semua"] + viewModel.products.map((p) => p.category).toSet().toList();

    final filteredProducts = viewModel.products.where((p) {
      final matchesSearch =
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.sku.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == "Semua" || p.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    final sortedProducts = [...filteredProducts];
    sortedProducts.sort((a, b) {
      switch (_selectedSortKey) {
        case "Stock Level (Low to High)":
          return a.stock.compareTo(b.stock);
        case "Price":
          return a.sellingPrice.compareTo(b.sellingPrice);
        default:
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventaris Produk"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddProductDialog,
            tooltip: "Tambah Produk",
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: const InputDecoration(
                labelText: "Cari Produk",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedCategory = category);
                      }
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedProducts.length,
              itemBuilder: (context, index) {
                final product = sortedProducts[index];
                return _ProductItemCard(
                  product: product,
                  onEdit: () => _showEditProductDialog(product),
                  onDelete: () => _showDeleteDialog(product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductItemCard extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductItemCard({
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<AppViewModel>();
    final isLowStock = product.isLowStock;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isLowStock
          ? const Color(0xFF281116)
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isLowStock ? kRadiantRose : Colors.transparent,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductImage(context, product),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Chip(
                        label: Text(
                          product.category,
                          style: const TextStyle(fontSize: 10),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "SKU: ${product.sku}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: onEdit,
                      tooltip: "Ubah",
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: onDelete,
                      tooltip: "Hapus",
                      color: kRadiantRose,
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewModel.formatRupiah(product.sellingPrice),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "Modal: ${viewModel.formatRupiah(product.purchasePrice)}",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${product.stock} Unit",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isLowStock ? kWarmOrange : kSoftTeal,
                      ),
                    ),
                    if (isLowStock)
                      Text(
                        "Min: ${product.minStockThreshold}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: kWarmOrange,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context, Product product) {
    final firstImageUrl = product.imageUrls
        .split(',')
        .firstWhere((url) => url.isNotEmpty, orElse: () => '');

    return Container(
      width: 60,
      height: 60,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surface.withAlpha(128),
      ),
      child: firstImageUrl.isNotEmpty
          ? Image.network(
              firstImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) =>
                  const Icon(Icons.image_not_supported, color: Colors.grey),
              loadingBuilder: (context, child, progress) => progress == null
                  ? child
                  : const Center(child: CircularProgressIndicator()),
            )
          : const Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }
}

class ProductFormDialog extends StatefulWidget {
  final String title;
  final Product? product;
  final Function(
    String name,
    String sku,
    int stock,
    double purchase,
    double sell,
    String cat,
    int threshold,
    String images,
  )
  onSave;

  const ProductFormDialog({
    super.key,
    required this.title,
    this.product,
    required this.onSave,
  });

  @override
  State<ProductFormDialog> createState() {
    return _ProductFormDialogState();
  }
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _skuController;
  late TextEditingController _stockController;
  late TextEditingController _purchaseController;
  late TextEditingController _sellController;
  late TextEditingController _categoryController;
  late TextEditingController _thresholdController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _skuController = TextEditingController(text: widget.product?.sku ?? '');
    _stockController = TextEditingController(
      text: widget.product?.stock.toString() ?? '',
    );
    _purchaseController = TextEditingController(
      text: widget.product?.purchasePrice.toString() ?? '',
    );
    _sellController = TextEditingController(
      text: widget.product?.sellingPrice.toString() ?? '',
    );
    _categoryController = TextEditingController(
      text: widget.product?.category ?? 'Umum',
    );
    _thresholdController = TextEditingController(
      text: widget.product?.minStockThreshold.toString() ?? '5',
    );
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(
        _nameController.text,
        _skuController.text,
        int.parse(_stockController.text),
        double.parse(_purchaseController.text),
        double.parse(_sellController.text),
        _categoryController.text,
        int.parse(_thresholdController.text),
        widget.product?.imageUrls ??
            '', // Image handling not fully implemented in this conversion
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nama Barang"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _skuController,
                decoration: const InputDecoration(labelText: "SKU / Barcode"),
              ),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: "Stok"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _purchaseController,
                decoration: const InputDecoration(labelText: "Harga Beli"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _sellController,
                decoration: const InputDecoration(labelText: "Harga Jual"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: "Kategori"),
              ),
              TextFormField(
                controller: _thresholdController,
                decoration: const InputDecoration(labelText: "Min. Threshold"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Batal"),
        ),
        ElevatedButton(onPressed: _handleSave, child: const Text("Simpan")),
      ],
    );
  }
}

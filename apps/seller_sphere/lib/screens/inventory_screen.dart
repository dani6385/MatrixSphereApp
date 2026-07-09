
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_sphere/data/local/app_database.dart';
import 'package:seller_sphere/viewmodel/app_view_model.dart';
import 'package:shared_ui/shared_ui.dart';

// Definisikan warna kustom yang digunakan di l

class InventoryScreen extends ConsumerWidget {
  final void Function(Product) onNavigateToLabelPrinter;

  const InventoryScreen({super.key, required this.onNavigateToLabelPrinter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              flex: 1,
              child: _OperationsPanel(),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: _ProductListPanel(
                onNavigateToLabelPrinter: onNavigateToLabelPrinter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OperationsPanel extends ConsumerWidget {
  const _OperationsPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final products = ref.watch(productsProvider).asData?.value ?? [];
    final lowStockProducts = products.where((p) => p.stock <= p.minStockThreshold).toList();

    return Column(
      children: [
        Card(
          color: theme.colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Manajemen Inventaris", style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  "Kelola data produk, stok, harga, serta cetak label harga dan promo barcode secara mandiri.",
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const Divider(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showProductFormDialog(context, ref),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text("Tambah Barang"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kNeonCyan,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showCsvDialog(context, ref),
                    icon: const Icon(Icons.import_export, size: 18),
                    label: const Text("Impor / Ekspor CSV"),
                    style: OutlinedButton.styleFrom(foregroundColor: kNeonCyan),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Card(
            color: theme.colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Ringkasan Stok", style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  _buildStatRow(context, "Total Jenis Produk", "${products.length} Item", kNeonCyan),
                  const SizedBox(height: 8),
                  _buildStatRow(context, "Total Unit Tersedia", "${products.fold(0, (sum, p) => sum + p.stock)} Unit", kSoftTeal),
                  const SizedBox(height: 8),
                  _buildStatRow(context, "Barang Stok Menipis", "${lowStockProducts.length} Item",
                      lowStockProducts.isNotEmpty ? kWarmOrange : kSoftTeal),
                  if (lowStockProducts.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kWarmOrange.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(children: [
                        Icon(Icons.warning, color: kWarmOrange, size: 16),
                        SizedBox(width: 8),
                        Expanded(
                            child: Text("Ada produk perlu re-stock segera!",
                                style: TextStyle(color: kWarmOrange, fontSize: 12))),
                      ]),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(BuildContext context, String title, String value, Color valueColor) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        Text(value, style: theme.textTheme.labelMedium?.copyWith(color: valueColor)),
      ],
    );
  }
}

class _ProductListPanel extends ConsumerStatefulWidget {
  final void Function(Product) onNavigateToLabelPrinter;
  const _ProductListPanel({required this.onNavigateToLabelPrinter});

  @override
  ConsumerState<_ProductListPanel> createState() => _ProductListPanelState();
}

class _ProductListPanelState extends ConsumerState<_ProductListPanel> {
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final products = ref.watch(productsProvider).asData?.value ?? [];
    final categories = ['Semua', ...products.map((p) => p.category).toSet().toList()];

    final filteredProducts = products.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.sku.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'Semua' || p.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Column(
      children: [
        TextField(
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: const InputDecoration(
            hintText: "Cari berdasarkan nama atau SKU...",
            prefixIcon: Icon(Icons.search, size: 18),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((cat) {
            final isSelected = _selectedCategory == cat;
            return ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedCategory = cat);
              },
              selectedColor: theme.colorScheme.primary.withAlpha(50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: filteredProducts.isEmpty
              ? Center(
                  child: Text("Tidak ada produk ditemukan",
                      style: TextStyle(color: theme.colorScheme.onSurfaceVariant.withAlpha(150))))
              : ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return _ProductItemCard(
                      product: product,
                      onEdit: () => _showProductFormDialog(context, ref, product: product),
                      onDelete: () => _showDeleteConfirmationDialog(context, ref, product),
                      onPrintLabel: () {
                        ref.read(appViewModelProvider).selectProductForLabel(product);
                        widget.onNavigateToLabelPrinter(product);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _ProductItemCard extends ConsumerWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onPrintLabel;

  const _ProductItemCard({
    required this.product,
    required this.onEdit,
    required this.onDelete,
    required this.onPrintLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final viewModel = ref.read(appViewModelProvider);
    final isLowStock = product.stock <= product.minStockThreshold;
    final profit = product.sellingPrice - product.purchasePrice;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: const Color(0xFF131A2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isLowStock ? kWarmOrange.withAlpha(128) : Colors.transparent, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(product.name, style: theme.textTheme.titleSmall?.copyWith(color: Colors.white)),
                    const SizedBox(height: 4),
                    Wrap(spacing: 8, children: [
                      Chip(label: Text("SKU: ${product.sku}"), visualDensity: VisualDensity.compact),
                      Chip(label: Text(product.category), visualDensity: VisualDensity.compact),
                    ]),
                  ]),
                ),
                Row(children: [
                  IconButton(onPressed: onPrintLabel, icon: const Icon(Icons.print, color: kNeonCyan, size: 18)),
                  IconButton(onPressed: onEdit, icon: const Icon(Icons.edit, color: kSoftTeal, size: 18)),
                  IconButton(onPressed: onDelete, icon: const Icon(Icons.delete, color: kRadiantRose, size: 18)),
                ]),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(viewModel.formatRupiah(product.sellingPrice), style: theme.textTheme.titleSmall?.copyWith(color: Colors.white)),
                  Text("Modal: ${viewModel.formatRupiah(product.purchasePrice)} • Untung: ${viewModel.formatRupiah(profit)}",
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withAlpha(200))),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Row(children: [
                    Icon(Icons.circle, size: 8, color: isLowStock ? kWarmOrange : kSoftTeal),
                    const SizedBox(width: 6),
                    Text("${product.stock} Unit",
                        style: theme.textTheme.labelMedium?.copyWith(color: isLowStock ? kWarmOrange : kSoftTeal)),
                  ]),
                  if (isLowStock)
                    Text("Min: ${product.minStockThreshold} Unit",
                        style: theme.textTheme.bodySmall?.copyWith(color: kWarmOrange, fontSize: 10)),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _showProductFormDialog(BuildContext context, WidgetRef ref, {Product? product}) {
  showDialog(
    context: context,
    builder: (_) => _ProductFormDialogContent(product: product),
  );
}

class _ProductFormDialogContent extends ConsumerStatefulWidget {
  final Product? product;
  const _ProductFormDialogContent({this.product});

  @override
  ConsumerState<_ProductFormDialogContent> createState() => _ProductFormDialogContentState();
}

class _ProductFormDialogContentState extends ConsumerState<_ProductFormDialogContent> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name, _sku, _stock, _purchase, _sell, _category, _threshold;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _name = TextEditingController(text: p?.name ?? '');
    _sku = TextEditingController(text: p?.sku ?? '');
    _stock = TextEditingController(text: p?.stock.toString() ?? '');
    _purchase = TextEditingController(text: p?.purchasePrice.toString() ?? '');
    _sell = TextEditingController(text: p?.sellingPrice.toString() ?? '');
    _category = TextEditingController(text: p?.category ?? 'Umum');
    _threshold = TextEditingController(text: p?.minStockThreshold.toString() ?? '5');
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final viewModel = ref.read(appViewModelProvider);
      if (widget.product == null) {
        viewModel.addProduct(
          name: _name.text,
          sku: _sku.text,
          stock: int.parse(_stock.text),
          purchasePrice: double.parse(_purchase.text),
          sellingPrice: double.parse(_sell.text),
          category: _category.text,
          threshold: int.parse(_threshold.text),
        );
      } else {
        viewModel.updateProduct(widget.product!.copyWith(
          name: _name.text,
          sku: _sku.text,
          stock: int.parse(_stock.text),
          purchasePrice: double.parse(_purchase.text),
          sellingPrice: double.parse(_sell.text),
          category: _category.text,
          minStockThreshold: int.parse(_threshold.text),
        ));
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product == null ? "Tambah Produk Baru" : "Ubah Produk"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Nama Barang'), validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
              TextFormField(controller: _sku, decoration: const InputDecoration(labelText: 'SKU / Barcode')),
              Row(children: [
                Expanded(child: TextFormField(controller: _stock, decoration: const InputDecoration(labelText: 'Stok'), keyboardType: TextInputType.number, validator: (v) => int.tryParse(v!) == null ? 'Angka tidak valid' : null)),
                const SizedBox(width: 8),
                Expanded(child: TextFormField(controller: _threshold, decoration: const InputDecoration(labelText: 'Min. Stok'), keyboardType: TextInputType.number, validator: (v) => int.tryParse(v!) == null ? 'Angka tidak valid' : null)),
              ]),
              Row(children: [
                Expanded(child: TextFormField(controller: _purchase, decoration: const InputDecoration(labelText: 'Harga Beli'), keyboardType: TextInputType.number, validator: (v) => double.tryParse(v!) == null ? 'Angka tidak valid' : null)),
                const SizedBox(width: 8),
                Expanded(child: TextFormField(controller: _sell, decoration: const InputDecoration(labelText: 'Harga Jual'), keyboardType: TextInputType.number, validator: (v) => double.tryParse(v!) == null ? 'Angka tidak valid' : null)),
              ]),
              TextFormField(controller: _category, decoration: const InputDecoration(labelText: 'Kategori'), validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Batal")),
        ElevatedButton(onPressed: _onSave, child: const Text("Simpan")),
      ],
    );
  }
}

void _showDeleteConfirmationDialog(BuildContext context, WidgetRef ref, Product product) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.delete, color: kRadiantRose),
      title: const Text("Hapus Produk?"),
      content: Text("Anda yakin ingin menghapus '${product.name}'? Tindakan ini tidak dapat dibatalkan."),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Batal")),
        ElevatedButton(
          onPressed: () {
            ref.read(appViewModelProvider).deleteProduct(product);
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(backgroundColor: kRadiantRose, foregroundColor: Colors.white),
          child: const Text("Hapus"),
        ),
      ],
    ),
  );
}

void _showCsvDialog(BuildContext context, WidgetRef ref) {
  final csvController = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Impor / Ekspor CSV"),
      content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Format: Nama,SKU,Stok,HargaBeli,HargaJual,Kategori,Threshold", style: TextStyle(fontSize: 12)),
        const SizedBox(height: 8),
        TextField(controller: csvController, maxLines: 5, decoration: const InputDecoration(hintText: "Tempel CSV di sini...")),
      ])),
      actions: [
        TextButton(onPressed: () async {
          final csv = await ref.read(appViewModelProvider).exportProductsToCsv();
          csvController.text = csv;
        }, child: const Text("Ekspor ke Field")),
        TextButton(onPressed: () {
          if (csvController.text.isNotEmpty) {
            ref.read(appViewModelProvider).importProductsFromCsv(csvController.text);
            Navigator.of(context).pop();
          }
        }, child: const Text("Impor dari Field")),
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Tutup")),
      ],
    ),
  );
}

final productsProvider = StreamProvider<List<Product>>((ref) {
  return ref.watch(appViewModelProvider).products;
});

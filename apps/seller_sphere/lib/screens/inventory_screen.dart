
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_sphere/data/local/app_database.dart';
import 'package:seller_sphere/viewmodel/app_view_model.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:seller_sphere/main_shell.dart';
import 'dart:math';
import 'package:qr_flutter/qr_flutter.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  final void Function(Product) onNavigateToLabelPrinter;

  const InventoryScreen({super.key, required this.onNavigateToLabelPrinter});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  String _searchQuery = "";
  String _selectedCategory = "Semua";
  String _selectedSortKey = "Alphabetical";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = ref.watch(appViewModelProvider);
    final productsAsyncValue = ref.watch(productsProvider);

    return productsAsyncValue.when(
      data: (products) {
        final categories = ["Semua"] +
            products.map((p) => p.category).toSet().toList();

        final filteredProducts = products.where((p) {
          final matchesSearch = p.name
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              p.sku.toLowerCase().contains(_searchQuery.toLowerCase());
          final matchesCategory =
              _selectedCategory == "Semua" || p.category == _selectedCategory;
          return matchesSearch && matchesCategory;
        }).toList();

        final sortedProducts = _sortProducts(filteredProducts, _selectedSortKey);

        return Scaffold(
          backgroundColor: theme.colorScheme.background,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: _buildLeftPanel(context, ref, products),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _buildRightPanel(
                      context, sortedProducts, categories, viewModel),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  List<Product> _sortProducts(List<Product> products, String key) {
    switch (key) {
      case "Stock Level (Low to High)":
        return products..sort((a, b) => a.stock.compareTo(b.stock));
      case "Price":
        return products..sort((a, b) => a.sellingPrice.compareTo(b.sellingPrice));
      case "Alphabetical":
        return products..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      default:
        return products;
    }
  }

  Widget _buildLeftPanel(
      BuildContext context, WidgetRef ref, List<Product> products) {
    final theme = Theme.of(context);
    final viewModel = ref.watch(appViewModelProvider);
    final totalStock = products.fold<int>(0, (sum, item) => sum + item.stock);
    final lowStockCount = products.where((p) => p.isLowStock).length;
    final totalRevenue = products.fold<double>(
        0, (sum, p) => sum + (p.sellingPrice * p.stock));
    final totalCost = products.fold<double>(
        0, (sum, p) => sum + (p.purchasePrice * p.stock));
    final potentialProfit = totalRevenue - totalCost;

    return Column(
      children: [
        Card(
          color: theme.colorScheme.surfaceVariant,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Manajemen Inventaris",
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  "Kelola data produk, stok, harga, serta cetak label harga dan promo barcode secara mandiri.",
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const Divider(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showProductFormDialog(context, ref),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text("Tambah Barang"),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showCsvDialog(context, ref),
                    icon: const Icon(Icons.import_export, size: 18),
                    label: const Text("Impor / Ekspor CSV"),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: theme.colorScheme.surfaceVariant,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ringkasan Stok",
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildStatRow(context, "Total Jenis Produk",
                    "${products.length} Item", AppColors.neonCyan),
                _buildStatRow(
                    context, "Total Unit Tersedia", "$totalStock Unit", AppColors.softTeal),
                _buildStatRow(
                    context,
                    "Barang Stok Menipis",
                    "$lowStockCount Item",
                    lowStockCount > 0 ? AppColors.warmOrange : AppColors.softTeal),
                if (lowStockCount > 0) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.warmOrange.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning,
                            color: AppColors.warmOrange, size: 16),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "Ada $lowStockCount produk perlu re-stock segera!",
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.warmOrange,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: theme.colorScheme.surfaceVariant,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Row(
                   children: [
                     Container(
                       padding: const EdgeInsets.all(6),
                       decoration: BoxDecoration(
                         color: AppColors.softTeal.withOpacity(0.15),
                         borderRadius: BorderRadius.circular(8)
                       ),
                       child: Icon(Icons.monetization_on, color: AppColors.softTeal, size: 18)),
                     const SizedBox(width: 8),
                     Text("Estimasi Nilai Inventaris", style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                   ],
                 ),
                const SizedBox(height: 12),
                Text("Total Estimasi Pendapatan", style: theme.textTheme.bodySmall),
                Text(viewModel.formatRupiah(totalRevenue),
                    style: theme.textTheme.headlineSmall?.copyWith(
                        color: AppColors.neonCyan, fontWeight: FontWeight.bold)),
                const Divider(height: 24),
                _buildStatRow(context, "Estimasi Modal (Cost)",
                    viewModel.formatRupiah(totalCost), theme.colorScheme.onSurface),
                _buildStatRow(
                    context,
                    "Potensi Keuntungan",
                    viewModel.formatRupiah(potentialProfit),
                    potentialProfit >= 0 ? AppColors.softTeal : AppColors.radiantRose),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildRightPanel(BuildContext context, List<Product> sortedProducts,
      List<String> categories, AppViewModel viewModel) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: "Cari berdasarkan nama atau SKU...",
                  prefixIcon: const Icon(Icons.search, size: 16),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (String value) {
                setState(() {
                  _selectedSortKey = value;
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Alphabetical',
                  child: Text('Alphabetical'),
                ),
                const PopupMenuItem<String>(
                  value: 'Stock Level (Low to High)',
                  child: Text('Stock Level (Low to High)'),
                ),
                const PopupMenuItem<String>(
                  value: 'Price',
                  child: Text('Price'),
                ),
              ],
              child: OutlinedButton.icon(
                onPressed: null, // onPressed is handled by PopupMenuButton
                icon: const Icon(Icons.sort),
                label: Text(_selectedSortKey),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 30,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = _selectedCategory == category;
              return ChoiceChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  }
                },
                selectedColor: theme.primaryColor.withOpacity(0.2),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 6),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: sortedProducts.isEmpty
              ? Center(
                  child: Text(
                  "Tidak ada produk di dalam inventaris",
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant
                          .withOpacity(0.6)),
                ))
              : ListView.builder(
                  itemCount: sortedProducts.length,
                  itemBuilder: (context, index) {
                    final product = sortedProducts[index];
                    return _ProductItemCard(
                      product: product,
                      viewModel: viewModel,
                      onEdit: () =>
                          _showProductFormDialog(context, ref, product: product),
                      onDelete: () =>
                          _showDeleteConfirmationDialog(context, ref, product),
                      onPrintLabel: () => widget.onNavigateToLabelPrinter(product),
                      onShowQr: () => _showQrDialog(context, product, viewModel),
                    );
                  },
                ),
        )
      ],
    );
  }

  Widget _buildStatRow(
      BuildContext context, String title, String value, Color valueColor) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: theme.textTheme.bodySmall),
        Text(value,
            style: theme.textTheme.bodySmall
                ?.copyWith(fontWeight: FontWeight.bold, color: valueColor)),
      ],
    );
  }

  void _showProductFormDialog(BuildContext context, WidgetRef ref,
      {Product? product}) {
    showDialog(
      context: context,
      builder: (_) =>
          _ProductFormDialog(product: product, viewModel: ref.read(appViewModelProvider)),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, WidgetRef ref, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Hapus Produk?"),
          content: Text(
              "Apakah Anda yakin ingin menghapus '${product.name}'? Tindakan ini tidak dapat dibatalkan."),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.radiantRose),
              child: const Text("Hapus"),
              onPressed: () {
                ref.read(appViewModelProvider).deleteProduct(product);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showCsvDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => _CsvImportExportDialog(viewModel: ref.read(appViewModelProvider)),
    );
  }

  void _showQrDialog(
      BuildContext context, Product product, AppViewModel viewModel) {
    showDialog(
      context: context,
      builder: (_) => _ProductQrDialog(product: product, viewModel: viewModel),
    );
  }
}

class _ProductItemCard extends StatelessWidget {
  final Product product;
  final AppViewModel viewModel;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onPrintLabel;
  final VoidCallback onShowQr;

  const _ProductItemCard({
    required this.product,
    required this.viewModel,
    required this.onEdit,
    required this.onDelete,
    required this.onPrintLabel,
    required this.onShowQr,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: product.isLowStock
              ? AppColors.warmOrange.withOpacity(0.5)
              : Colors.transparent,
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(product.name,
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          if (product.isLowStock) ...[
                            const SizedBox(width: 6),
                            Icon(Icons.error,
                                color: AppColors.radiantRose, size: 16),
                          ]
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Chip(
                            label: Text("SKU: ${product.sku}"),
                            padding: EdgeInsets.zero,
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(product.category),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.qr_code),
                        onPressed: onShowQr,
                        tooltip: "QR Code"),
                    IconButton(
                        icon: const Icon(Icons.print),
                        onPressed: onPrintLabel,
                        tooltip: "Cetak Label"),
                    IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: onEdit,
                        tooltip: "Ubah"),
                    IconButton(
                        icon: const Icon(Icons.delete),
                        color: AppColors.radiantRose,
                        onPressed: onDelete,
                        tooltip: "Hapus"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(viewModel.formatRupiah(product.sellingPrice),
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    Text(
                        "Modal: ${viewModel.formatRupiah(product.purchasePrice)} • Untung: ${viewModel.formatRupiah(product.profitPerUnit)}",
                        style: theme.textTheme.bodySmall),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        if (!product.isLowStock) ... [
                           Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                                color: AppColors.softTeal,
                                shape: BoxShape.circle),
                          ),
                           const SizedBox(width: 6),
                        ],
                        Text("${product.stock} Unit",
                            style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: product.isLowStock
                                    ? AppColors.warmOrange
                                    : AppColors.softTeal)),
                      ],
                    ),
                    if (product.isLowStock)
                      Text("Min: ${product.minStockThreshold} Unit",
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: AppColors.warmOrange)),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _ProductFormDialog extends StatefulWidget {
  final Product? product;
  final AppViewModel viewModel;

  const _ProductFormDialog({this.product, required this.viewModel});

  @override
  __ProductFormDialogState createState() => __ProductFormDialogState();
}

class __ProductFormDialogState extends State<_ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _sku;
  late int _stock;
  late double _purchasePrice;
  late double _sellingPrice;
  late String _category;
  late int _minStockThreshold;

  @override
  void initState() {
    super.initState();
    _name = widget.product?.name ?? "";
    _sku = widget.product?.sku ?? "";
    _stock = widget.product?.stock ?? 0;
    _purchasePrice = widget.product?.purchasePrice ?? 0.0;
    _sellingPrice = widget.product?.sellingPrice ?? 0.0;
    _category = widget.product?.category ?? "Umum";
    _minStockThreshold = widget.product?.minStockThreshold ?? 5;
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.product == null) {
        widget.viewModel.addProduct(
            _name, _sku, _stock, _purchasePrice, _sellingPrice, _category, _minStockThreshold);
      } else {
        final updatedProduct = widget.product!.copyWith(
          name: _name,
          sku: _sku,
          stock: _stock,
          purchasePrice: _purchasePrice,
          sellingPrice: _sellingPrice,
          category: _category,
          minStockThreshold: _minStockThreshold,
        );
        widget.viewModel.updateProduct(updatedProduct);
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
            children: <Widget>[
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Nama Barang'),
                onSaved: (value) => _name = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              TextFormField(
                initialValue: _sku,
                decoration: const InputDecoration(labelText: 'SKU / Barcode'),
                onSaved: (value) => _sku = value!,
              ),
              TextFormField(
                initialValue: _stock.toString(),
                decoration: const InputDecoration(labelText: 'Stok'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _stock = int.tryParse(value!) ?? 0,
              ),
              TextFormField(
                initialValue: _purchasePrice.toString(),
                decoration: const InputDecoration(labelText: 'Harga Beli'),
                keyboardType: TextInputType.number,
                onSaved: (value) =>
                    _purchasePrice = double.tryParse(value!) ?? 0.0,
              ),
              TextFormField(
                initialValue: _sellingPrice.toString(),
                decoration: const InputDecoration(labelText: 'Harga Jual'),
                keyboardType: TextInputType.number,
                onSaved: (value) =>
                    _sellingPrice = double.tryParse(value!) ?? 0.0,
              ),
              TextFormField(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Kategori'),
                onSaved: (value) => _category = value!,
              ),
              TextFormField(
                initialValue: _minStockThreshold.toString(),
                decoration: const InputDecoration(labelText: 'Min. Threshold'),
                keyboardType: TextInputType.number,
                onSaved: (value) =>
                    _minStockThreshold = int.tryParse(value!) ?? 5,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Batal'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Simpan'),
          onPressed: _onSave,
        ),
      ],
    );
  }
}

class _CsvImportExportDialog extends StatefulWidget {
  final AppViewModel viewModel;
  const _CsvImportExportDialog({required this.viewModel});

  @override
  __CsvImportExportDialogState createState() => __CsvImportExportDialogState();
}

class __CsvImportExportDialogState extends State<_CsvImportExportDialog> {
  final TextEditingController _csvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Impor / Ekspor CSV Produk"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Format: Nama,SKU,Stok,HargaBeli,HargaJual,Kategori,Threshold",
                style: TextStyle(fontSize: 11)),
            const SizedBox(height: 8),
            TextField(
              controller: _csvController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Tempel data CSV di sini untuk impor...",
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final csv = widget.viewModel.exportProductsToCsv();
                      _csvController.text = csv;
                    },
                    icon: const Icon(Icons.content_copy, size: 14),
                    label: const Text("Salin Ekspor", style: TextStyle(fontSize: 11)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_csvController.text.isNotEmpty) {
                        final success = widget.viewModel
                            .importProductsFromCsv(_csvController.text);
                        if (success) {
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    icon: const Icon(Icons.upload_file, size: 14),
                    label: const Text("Impor CSV", style: TextStyle(fontSize: 11)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Tutup"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class _ProductQrDialog extends StatelessWidget {
  final Product product;
  final AppViewModel viewModel;

  const _ProductQrDialog({required this.product, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final qrText = product.sku.isEmpty ? "PROD-${product.id}" : product.sku;

    return AlertDialog(
      backgroundColor: const Color(0xFF0B0F19),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(children: const [
        Icon(Icons.qr_code, color: AppColors.neonCyan),
        SizedBox(width: 8),
        Text("Cetak Label & QR Code")
      ]),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Pratinjau Stiker Thermal (Siap Cetak)",
                style: TextStyle(fontSize: 11)),
            const SizedBox(height: 8),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    const Text("SS SELLER SPHERE",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1)),
                    const SizedBox(height: 2),
                    Container(height: 1, color: Colors.black),
                    const SizedBox(height: 10),
                    QrImageView(
                      data: qrText,
                      version: QrVersions.auto,
                      size: 130.0,
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      product.name.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 12),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                    Text("SKU: $qrText",
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 10)),
                    const SizedBox(height: 4),
                    Text(viewModel.formatRupiah(product.sellingPrice),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 14)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
             ElevatedButton.icon(
                onPressed: () {
                   viewModel.triggerNotification(
                        "Cetak QR Selesai 🖨️",
                        "Label QR Code untuk ${product.name} berhasil dicetak.");
                },
                icon: const Icon(Icons.print, size: 16),
                label: const Text("Cetak QR Label"),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.softTeal, foregroundColor: Colors.black),
              )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Tutup"),
        )
      ],
    );
  }
}

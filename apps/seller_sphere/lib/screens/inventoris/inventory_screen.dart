import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:media_info/media_info.dart';
import 'package:shared_ui/shared_ui.dart';
import 'models/product.dart';
import 'providers/app_provider.dart';

// Definisi warna tema agar mudah diakses
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
  String _searchQuery = "";
  String _selectedCategory = "Semua";
  String _selectedSortKey = "Alphabetical";

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppProvider>(context);
    final products = viewModel.products;
    final isSafeModeEnabled = viewModel.isSafeModeEnabled;
    final safeModeAgeLimit = viewModel.safeModeAgeLimit;

    final categories = [
      "Semua",
      ...products.map((p) => p.category).toSet().where((c) => c.isNotEmpty)
    ];

    final filteredProducts = products.where((p) {
      final matchesSearch =
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.sku.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == "Semua" || p.category == _selectedCategory;
      final matchesSafeMode =
          !isSafeModeEnabled || p.ageRating <= safeModeAgeLimit;
      return matchesSearch && matchesCategory && matchesSafeMode;
    }).toList();

    final sortedProducts = [...filteredProducts];
    switch (_selectedSortKey) {
      case "Stock Level (Low to High)":
        sortedProducts.sort((a, b) => a.stock.compareTo(b.stock));
        break;
      case "Price":
        sortedProducts.sort((a, b) => a.sellingPrice.compareTo(b.sellingPrice));
        break;
      case "Alphabetical":
        sortedProducts.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
    }

    return Scaffold(
      // AppBar bisa ditambahkan di sini jika perlu
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Search Box
            _buildSearchField(),
            const SizedBox(height: 12),

            // 1b. Safe Mode controls
            _buildSafeModeCard(viewModel),
            const SizedBox(height: 12),

            // 2. Categories and Sort
            _buildFilterAndSortRow(categories),
            const SizedBox(height: 16),

            // 3. Main Body Scrollable Area
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Header 1: Quick actions and Info Cards
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildActionButtons(context),
                        const SizedBox(height: 12),
                        _buildStatsCards(context, products),
                        const SizedBox(height: 12),
                        _buildLowStockWarning(products),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // Header 2: Product List Label
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Daftar Produk (${filteredProducts.length})",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),

                  // List of Products
                  if (sortedProducts.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Text(
                          "Tidak ada produk di dalam inventaris",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant
                                  .withValues(alpha: 0.6),
                              fontSize: 13),
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = sortedProducts[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: ProductItemCard(
                              product: product,
                              onEdit: () => _showProductFormDialog(context,
                                  product: product),
                              onDelete: () => _showDeleteConfirmationDialog(
                                  context, product),
                              onPrintLabel: () {
                                viewModel.selectProductForLabel(product);
                                widget.onNavigateToLabelPrinter(product);
                              },
                              onShowQr: () =>
                                  _showProductQrDialog(context, product),
                            ),
                          );
                        },
                        childCount: sortedProducts.length,
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

  // --- Builder Methods for UI Sections ---

  Widget _buildSearchField() {
    return SizedBox(
      height: 52,
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: const InputDecoration(
          hintText: "Cari berdasarkan nama atau SKU...",
          hintStyle: TextStyle(fontSize: 13),
          prefixIcon: Icon(Icons.search, size: 18),
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }

  Widget _buildSafeModeCard(AppProvider viewModel) {
    final isSafeModeEnabled = viewModel.isSafeModeEnabled;
    return Card(
      color: isSafeModeEnabled
          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05)
          : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSafeModeEnabled
              ? kNeonCyan.withValues(alpha: 0.3)
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        isSafeModeEnabled ? Icons.shield : Icons.verified_user,
                        color: isSafeModeEnabled
                            ? kNeonCyan
                            : Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant
                                .withValues(alpha: 0.6),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Safe Mode",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                            Text(
                              isSafeModeEnabled
                                  ? "Filter hasil pencarian sesuai batas usia"
                                  : "Batas usia pencarian tidak aktif",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: isSafeModeEnabled,
                    onChanged: (value) => viewModel.toggleSafeMode(value),
                    activeThumbColor: Colors.black,
                    activeTrackColor: kNeonCyan,
                  ),
                ),
              ],
            ),
            if (isSafeModeEnabled) ...[
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                height: 0.5,
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Batas Usia Pengguna:",
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  Row(
                    children: [
                      _ageOptionChip(viewModel, 0, "Semua"),
                      _ageOptionChip(viewModel, 13, "Remaja"),
                      _ageOptionChip(viewModel, 18, "Dewasa"),
                    ],
                  )
                ],
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _ageOptionChip(AppProvider viewModel, int ageVal, String label) {
    final isSelected = viewModel.safeModeAgeLimit == ageVal;
    return GestureDetector(
      onTap: () => viewModel.updateSafeModeAgeLimit(ageVal),
      child: Container(
        margin: const EdgeInsets.only(left: 6),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? kNeonCyan.withValues(alpha: 0.2)
              : Theme.of(context).colorScheme.surface.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? kNeonCyan
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? kNeonCyan
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterAndSortRow(List<String> categories) {
    return Row(
      children: [
        // Categories
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                final isSelected = _selectedCategory == category;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = category),
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .outline
                                .withValues(alpha:0.4),
                      ),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Sort Dropdown
        _buildSortButton(),
      ],
    );
  }

  Widget _buildSortButton() {
    String getShortLabel() {
      switch (_selectedSortKey) {
        case "Stock Level (Low to High)":
          return "Stok";
        case "Price":
          return "Harga";
        default:
          return "A-Z";
      }
    }

    return PopupMenuButton<String>(
      onSelected: (String value) {
        setState(() {
          _selectedSortKey = value;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        _buildSortMenuItem("Alphabetical", "Alphabetical", Icons.sort_by_alpha),
        _buildSortMenuItem("Stock Level (Low to High)",
            "Stock Level (Low to High)", Icons.import_export),
        _buildSortMenuItem("Price", "Price", Icons.monetization_on),
      ],
      child: OutlinedButton(
        onPressed: null, // PopupMenuButton handles tap
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 38),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide(
              color: Theme.of(context).colorScheme.outline.withValues(alpha:0.4)),
        ),
        child: Row(
          children: [
            const Icon(Icons.sort, size: 16),
            const SizedBox(width: 4),
            Text(getShortLabel(),
                style:
                    const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
            const Icon(Icons.arrow_drop_down, size: 14),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildSortMenuItem(
      String value, String label, IconData icon) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 16, color: Theme.of(context).iconTheme.color),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 13,
          child: SizedBox(
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () => _showProductFormDialog(context),
              icon: const Icon(Icons.add, size: 18),
              label: const Text("Tambah Barang",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: kNeonCyan,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 10,
          child: SizedBox(
            height: 44,
            child: OutlinedButton.icon(
              onPressed: () => _showCsvDialog(context),
              icon: const Icon(Icons.import_export, size: 18),
              label: const Text("Impor/Ekspor",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              style: OutlinedButton.styleFrom(
                foregroundColor: kNeonCyan,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                side: const BorderSide(color: kNeonCyan),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards(BuildContext context, List<Product> products) {
    final viewModel = Provider.of<AppProvider>(context, listen: false);
    final totalStock = products.fold<int>(0, (sum, item) => sum + item.stock);
    final lowStockCount = products.where((p) => p.isLowStock).length;
    final totalRevenue = products.fold<double>(
        0, (sum, item) => sum + (item.sellingPrice * item.stock));
    final totalCost = products.fold<double>(
        0, (sum, item) => sum + (item.purchasePrice * item.stock));
    final potentialProfit = totalRevenue - totalCost;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ringkasan Stok
        Expanded(
          child: Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Ringkasan Stok",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 6),
                  _buildStatRow("Jenis", "${products.length} Item",
                      valueColor: kNeonCyan),
                  _buildStatRow("Total", "$totalStock Unit",
                      valueColor: kSoftTeal),
                  _buildStatRow("Kritis", "$lowStockCount Item",
                      valueColor: lowStockCount > 0 ? kWarmOrange : kSoftTeal),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Estimasi Nilai
        Expanded(
          flex: 11, // Corresponds to weight 1.1f
          child: Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Estimasi Nilai",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pendapatan",
                          style: TextStyle(
                              fontSize: 9,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant)),
                      Text(
                        viewModel.formatRupiah(totalRevenue),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: kNeonCyan),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  _buildStatRow("Modal", viewModel.formatRupiah(totalCost),
                      valueColor: Theme.of(context).colorScheme.onSurface),
                  _buildStatRow(
                      "Untung", viewModel.formatRupiah(potentialProfit),
                      valueColor:
                          potentialProfit >= 0 ? kSoftTeal : kRadiantRose),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.onSurfaceVariant)),
        Text(
          value,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
              color: valueColor ?? Theme.of(context).colorScheme.onSurface),
        ),
      ],
    );
  }

  Widget _buildLowStockWarning(List<Product> products) {
    final lowStockCount = products.where((p) => p.isLowStock).length;
    if (lowStockCount > 0) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: kWarmOrange.withValues(alpha:0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning, color: kWarmOrange, size: 16),
            const SizedBox(width: 6),
            Text(
              "Ada $lowStockCount produk perlu re-stock segera!",
              style: const TextStyle(
                  fontSize: 11, color: kWarmOrange, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  // --- Dialog Methods ---

  void _showProductFormDialog(BuildContext context, {Product? product}) {
    showDialog(
      context: context,
      builder: (_) => ProductFormDialog(
        product: product,
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Product product) {
    final viewModel = Provider.of<AppProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          icon: const Icon(Icons.delete, color: kRadiantRose),
          title: const Text("Hapus Produk?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          content: Text(
              "Apakah Anda yakin ingin menghapus '${product.name}'? Tindakan ini tidak dapat dibatalkan.",
              style: const TextStyle(fontSize: 13)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                viewModel.deleteProduct(product);
                Navigator.of(dialogContext).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: kRadiantRose),
              child: const Text("Hapus",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showProductQrDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (_) => ProductQrDialog(product: product),
    );
  }

  void _showCsvDialog(BuildContext context) {
    final viewModel = Provider.of<AppProvider>(context, listen: false);
    final csvInputController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Impor / Ekspor CSV Produk",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Format: Nama,SKU,Stok,HargaBeli,HargaJual,Kategori,Threshold",
                  style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: csvInputController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: "Tempel data CSV di sini untuk impor...",
                    hintStyle: TextStyle(fontSize: 12),
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final csv = viewModel.exportProductsToCsv();
                          csvInputController.text = csv;
                        },
                        icon: const Icon(Icons.content_copy, size: 14),
                        label: const Text("Salin Ekspor",
                            style: TextStyle(fontSize: 11)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceContainerHighest,
                          foregroundColor: kNeonCyan,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (csvInputController.text.isNotEmpty) {
                            final success = viewModel
                                .importProductsFromCsv(csvInputController.text);
                            if (success) {
                              Navigator.of(dialogContext).pop();
                            }
                          }
                        },
                        icon: const Icon(Icons.upload_file, size: 14),
                        label: const Text("Impor CSV",
                            style: TextStyle(fontSize: 11)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kNeonCyan,
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Tutup",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}

// --- Custom Widgets (dulu Composable terpisah) ---

class ProductItemCard extends StatefulWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onPrintLabel;
  final VoidCallback onShowQr;

  const ProductItemCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
    required this.onPrintLabel,
    required this.onShowQr,
  });

  @override
  State<ProductItemCard> createState() => _ProductItemCardState();
}

class _ProductItemCardState extends State<ProductItemCard> {
  bool _isPlayingVideoInCard = false;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.product.videoUrl != null &&
        widget.product.videoUrl!.isNotEmpty) {
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(widget.product.videoUrl!))
            ..initialize().then((_) {
              _videoController?.setLooping(true);
              if (mounted) setState(() {});
            });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _toggleVideoPlayback() {
    setState(() {
      _isPlayingVideoInCard = !_isPlayingVideoInCard;
      if (_isPlayingVideoInCard) {
        _videoController?.play();
        // Batasi pemutaran hingga 30 detik
        Future.delayed(const Duration(seconds: 30), () {
          if (mounted && _isPlayingVideoInCard) {
            setState(() {
              _isPlayingVideoInCard = false;
              _videoController?.pause();
            });
          }
        });
      } else {
        _videoController?.pause();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppProvider>(context, listen: false);
    final product = widget.product;
    final firstImageUrl =
        product.imageUrls.isNotEmpty ? product.imageUrls.first : null;
    final hasVideo = product.videoUrl != null && product.videoUrl!.isNotEmpty;

    return Card(
      color: product.isLowStock
          ? const Color(0xFF281116)
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color:
              product.isLowStock ? const Color(0xFF991B1B) : Colors.transparent,
        ),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image/Video Thumbnail
                _buildThumbnail(firstImageUrl, hasVideo),
                const SizedBox(width: 12),
                // Product Info
                Expanded(child: _buildProductInfo(product)),
                // Action Menu
                _buildActionMenu(),
              ],
            ),
            const SizedBox(height: 12),
            Divider(
                color: Theme.of(context).colorScheme.outline.withValues(alpha:0.1)),
            const SizedBox(height: 10),
            // Price and Stock
            _buildPriceAndStock(viewModel, product),
            if (product.isLowStock) ...[
              const SizedBox(height: 10),
              _buildLowStockBanner(),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(String? imageUrl, bool hasVideo) {
    return GestureDetector(
      onTap: () {
        if (hasVideo) {
          _toggleVideoPlayback();
        } else if (imageUrl != null) {
          _showGalleryDialog(context, widget.product);
        }
      },
      child: SizedBox(
        width: 60,
        height: 60,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_isPlayingVideoInCard &&
                  _videoController != null &&
                  _videoController!.value.isInitialized)
                AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: VideoPlayer(_videoController!),
                )
              else if (imageUrl != null)
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                  placeholder: (context, url) =>
                      Container(color: Colors.grey[800]),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              else if (hasVideo)
                Container(
                  color: Colors.black,
                  child:
                      const Icon(Icons.play_circle, color: kNeonCyan, size: 32),
                )
              else
                Container(
                  color: Theme.of(context).colorScheme.surface.withValues(alpha:0.5),
                  child: Icon(Icons.image_not_supported,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withValues(alpha:0.4),
                      size: 24),
                ),
              if (hasVideo && !_isPlayingVideoInCard)
                Container(
                  color: Colors.black.withValues(alpha:0.4),
                  child:
                      const Icon(Icons.play_circle, color: kNeonCyan, size: 24),
                ),
              if (_isPlayingVideoInCard)
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha:0.7),
                        borderRadius: BorderRadius.circular(2)),
                    child: const Text("30s",
                        style: TextStyle(
                            color: kNeonCyan,
                            fontSize: 8,
                            fontWeight: FontWeight.bold)),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo(Product product) {
    String ageLabel;
    Color ageBgColor, ageTextColor;

    switch (product.ageRating) {
      case 18:
        ageLabel = "Dewasa (18+)";
        ageBgColor = kRadiantRose.withValues(alpha:0.15);
        ageTextColor = kRadiantRose;
        break;
      case 13:
        ageLabel = "Remaja (13+)";
        ageBgColor = kWarmOrange.withValues(alpha:0.15);
        ageTextColor = kWarmOrange;
        break;
      default:
        ageLabel = "Semua Umur (SU)";
        ageBgColor = kSoftTeal.withValues(alpha:0.15);
        ageTextColor = kSoftTeal;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                product.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (product.isLowStock) ...[
              const SizedBox(width: 6),
              const Icon(Icons.error, color: kRadiantRose, size: 16),
            ]
          ],
        ),
        const SizedBox(height: 4),
        _infoBadge(
            product.category,
            Theme.of(context).colorScheme.outline.withValues(alpha:0.1),
            Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(height: 4),
        _infoBadge("SKU: ${product.sku}", kNeonCyan.withValues(alpha:0.1), kNeonCyan,
            isMonospace: true),
        const SizedBox(height: 4),
        _ageBadge(ageLabel, ageBgColor, ageTextColor, product.ageRating >= 13),
      ],
    );
  }

  Widget _infoBadge(String text, Color bgColor, Color textColor,
      {bool isMonospace = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: textColor,
          fontFamily: isMonospace ? 'monospace' : null,
        ),
      ),
    );
  }

  Widget _ageBadge(
      String label, Color bgColor, Color textColor, bool hasWarningIcon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(hasWarningIcon ? Icons.warning : Icons.check_circle,
              size: 10, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
                fontSize: 9, fontWeight: FontWeight.bold, color: textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildActionMenu() {
    return Row(
      children: [
        _actionIconButton(widget.onShowQr, Icons.qr_code, kNeonCyan),
        _actionIconButton(widget.onPrintLabel, Icons.print, kNeonCyan),
        _actionIconButton(widget.onEdit, Icons.edit, kSoftTeal),
        _actionIconButton(widget.onDelete, Icons.delete, kRadiantRose),
      ],
    );
  }

  Widget _actionIconButton(VoidCallback onPressed, IconData icon, Color color) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: color, size: 16),
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.all(8),
      splashRadius: 20,
    );
  }

  Widget _buildPriceAndStock(AppProvider viewModel, Product product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Price & Profit
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  viewModel.formatRupiah(product.sellingPrice),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white),
                ),
                const SizedBox(width: 6),
                Text("Jual",
                    style: TextStyle(
                        fontSize: 9,
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              "Modal: ${viewModel.formatRupiah(product.purchasePrice)} • Untung: ${viewModel.formatRupiah(product.profitPerUnit)}",
              style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withValues(alpha:0.8)),
            ),
          ],
        ),
        // Stock status
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                if (product.isLowStock)
                  const Icon(Icons.error, color: kRadiantRose, size: 14)
                else
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                        color: kSoftTeal, shape: BoxShape.circle),
                  ),
                const SizedBox(width: 4),
                Text(
                  "${product.stock} Unit",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: product.isLowStock ? kWarmOrange : kSoftTeal),
                ),
              ],
            ),
            if (product.isLowStock)
              Text(
                "Min: ${product.minStockThreshold} Unit",
                style: const TextStyle(fontSize: 9, color: Color(0xFFFCA5A5)),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildLowStockBanner() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF38161A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEF4444).withValues(alpha:0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning, color: Color(0xFFEF4444), size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "Peringatan: Stok hampir habis! Segera lakukan pengisian ulang barang.",
              style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFFFCA5A5),
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showGalleryDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (_) => ProductGalleryDialog(product: product),
    );
  }
}

// --- Dialogs ---

class ProductFormDialog extends StatefulWidget {
  final Product? product;

  const ProductFormDialog({super.key, this.product});

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
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

  late int _ageRating;
  late List<String> _imageUrlsList;
  String? _videoUrl;

  bool _isUploadingImage = false;
  String? _uploadError;
  bool _isSavingVideo = false;
  String? _videoError;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p?.name ?? "");
    _skuController = TextEditingController(text: p?.sku ?? "");
    _stockController = TextEditingController(text: p?.stock.toString() ?? "");
    _purchaseController =
        TextEditingController(text: p?.purchasePrice.toString() ?? "");
    _sellController =
        TextEditingController(text: p?.sellingPrice.toString() ?? "");
    _categoryController = TextEditingController(text: p?.category ?? "Umum");
    _thresholdController =
        TextEditingController(text: p?.minStockThreshold.toString() ?? "5");
    _ageRating = p?.ageRating ?? 0;
    _imageUrlsList = p?.imageUrls.toList() ?? [];
    _videoUrl = p?.videoUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _stockController.dispose();
    _purchaseController.dispose();
    _sellController.dispose();
    _categoryController.dispose();
    _thresholdController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _isUploadingImage = true;
        _uploadError = null;
      });

      try {
        // ignore: use_build_context_synchronously
        final viewModel = Provider.of<AppProvider>(context, listen: false);
        final uploadedUrl =
            await viewModel.uploadImageToImgBB(imagePath: pickedFile.path);
        setState(() {
          if (_imageUrlsList.length < 10) {
            _imageUrlsList.add(uploadedUrl);
          }
        });
      } catch (e) {
        setState(() {
          _uploadError = "Gagal mengunggah foto: $e";
        });
      } finally {
        setState(() {
          _isUploadingImage = false;
        });
      }
    }
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _isSavingVideo = true;
        _videoError = null;
      });

      try {
        // Check video duration
        final mediaInfo = MediaInfo();
        final info = await mediaInfo.getMediaInfo(pickedFile.path);
        final durationMs = info['durationMs'] ?? 0;

        if (durationMs > 30500) {
          setState(() {
            _videoError =
                "Durasi video melebihi 30 detik! (${(durationMs / 1000).toInt()} detik)";
          });
          return;
        }

        // Copy to local app files directory
        final appDir = await getApplicationDocumentsDirectory();
        final videoDir = Directory('${appDir.path}/product_videos');
        if (!await videoDir.exists()) {
          await videoDir.create(recursive: true);
        }
        final fileName = 'vid_${DateTime.now().millisecondsSinceEpoch}.mp4';
        final savedFile =
            await File(pickedFile.path).copy('${videoDir.path}/$fileName');

        setState(() {
          _videoUrl = savedFile.path;
        });
      } catch (e) {
        setState(() {
          _videoError = "Kesalahan membaca video: $e";
        });
      } finally {
        setState(() {
          _isSavingVideo = false;
        });
      }
    }
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final viewModel = Provider.of<AppProvider>(context, listen: false);
      final name = _nameController.text;
      final sku = _skuController.text;
      final stock = int.tryParse(_stockController.text) ?? 0;
      final purchase = double.tryParse(_purchaseController.text) ?? 0.0;
      final sell = double.tryParse(_sellController.text) ?? 0.0;
      final category = _categoryController.text;
      final threshold = int.tryParse(_thresholdController.text) ?? 5;

      if (widget.product == null) {
        // Add new product
        viewModel.addProduct(name, sku, stock, purchase, sell, category,
            threshold, _imageUrlsList, _ageRating, _videoUrl);
      } else {
        // Update existing product
        final updatedProduct = widget.product!.copyWith(
          name: name,
          sku: sku,
          stock: stock,
          purchasePrice: purchase,
          sellingPrice: sell,
          category: category,
          minStockThreshold: threshold,
          imageUrls: _imageUrlsList,
          ageRating: _ageRating,
          videoUrl: _videoUrl,
        );
        viewModel.updateProduct(updatedProduct);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product == null ? "Tambah Produk Baru" : "Ubah Produk",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Nama Barang"),
                  validator: (v) => v!.isEmpty ? "Wajib diisi" : null),
              const SizedBox(height: 10),
              TextFormField(
                  controller: _skuController,
                  decoration:
                      const InputDecoration(labelText: "SKU / Barcode")),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                          controller: _stockController,
                          decoration: const InputDecoration(labelText: "Stok"),
                          keyboardType: TextInputType.number,
                          validator: (v) => int.tryParse(v!) == null
                              ? "Angka tidak valid"
                              : null)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: TextFormField(
                          controller: _thresholdController,
                          decoration: const InputDecoration(
                              labelText: "Min. Threshold"),
                          keyboardType: TextInputType.number,
                          validator: (v) => int.tryParse(v!) == null
                              ? "Angka tidak valid"
                              : null)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                          controller: _purchaseController,
                          decoration:
                              const InputDecoration(labelText: "Harga Beli"),
                          keyboardType: TextInputType.number,
                          validator: (v) => double.tryParse(v!) == null
                              ? "Angka tidak valid"
                              : null)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: TextFormField(
                          controller: _sellController,
                          decoration:
                              const InputDecoration(labelText: "Harga Jual"),
                          keyboardType: TextInputType.number,
                          validator: (v) => double.tryParse(v!) == null
                              ? "Angka tidak valid"
                              : null)),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: "Kategori")),
              const SizedBox(height: 16),
              // Age Classification
              _buildAgeClassification(),
              const SizedBox(height: 16),
              // Image Uploader
              _buildImageUploader(),
              const SizedBox(height: 16),
              // Video Uploader
              _buildVideoUploader(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Batal")),
        ElevatedButton(
          onPressed: _onSave,
          style: ElevatedButton.styleFrom(
              backgroundColor: kNeonCyan, foregroundColor: Colors.black),
          child: const Text("Simpan",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildAgeClassification() {
    // ... (Implementasi UI untuk memilih batas usia)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Klasifikasi Batas Usia",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Row(
          children: [
            _ageChip(0, "Semua"),
            _ageChip(13, "Remaja"),
            _ageChip(18, "Dewasa"),
          ],
        )
      ],
    );
  }

  Widget _ageChip(int val, String label) {
    final isSelected = _ageRating == val;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _ageRating = val),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? kNeonCyan.withValues(alpha:0.2)
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: isSelected
                    ? kNeonCyan
                    : Theme.of(context).colorScheme.outline.withValues(alpha:0.2)),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? kNeonCyan
                      : Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploader() {
    // ... (Implementasi UI untuk upload gambar)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Foto Produk (Maksimal 10)",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ..._imageUrlsList.map((url) => _buildImageThumbnail(url)),
              if (_isUploadingImage) _buildUploadingPlaceholder(),
              if (_imageUrlsList.length < 10 && !_isUploadingImage)
                _buildAddPhotoButton(),
            ],
          ),
        ),
        if (_uploadError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text("Gagal mengunggah foto: $_uploadError",
                style: const TextStyle(color: kRadiantRose, fontSize: 11)),
          ),
      ],
    );
  }

  Widget _buildImageThumbnail(String url) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: url,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => setState(() => _imageUrlsList.remove(url)),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha:0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadingPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
          child: SizedBox(
              width: 24,
              height: 24,
              child:
                  CircularProgressIndicator(strokeWidth: 2, color: kNeonCyan))),
    );
  }

  Widget _buildAddPhotoButton() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: kNeonCyan.withValues(alpha:0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_a_photo, color: kNeonCyan, size: 20),
            const SizedBox(height: 4),
            Text("${_imageUrlsList.length}/10",
                style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoUploader() {
    // ... (Implementasi UI untuk upload video)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Video Promo / Demo Produk (Maks. 30s)",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 6),
        Card(
          color: Theme.of(context).colorScheme.surface.withValues(alpha:0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: kNeonCyan.withValues(alpha:0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                if (_videoUrl != null)
                  _buildVideoPreview()
                else
                  Text(
                    "Belum ada video produk. Tambahkan video promosi (maksimal 30 detik) yang akan diputar otomatis pada gambar produk.",
                    style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant
                            .withValues(alpha:0.8)),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _pickVideo,
                        icon: const Icon(Icons.video_library, size: 16),
                        label: const Text("Pilih Video",
                            style: TextStyle(fontSize: 11)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => setState(() => _videoUrl =
                            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"),
                        icon: const Icon(Icons.movie, size: 16),
                        label: const Text("Video Sampel",
                            style: TextStyle(fontSize: 11)),
                      ),
                    ),
                  ],
                ),
                if (_isSavingVideo)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2)),
                          SizedBox(width: 8),
                          Text("Mengecek & memproses...",
                              style: TextStyle(fontSize: 11, color: kNeonCyan)),
                        ]),
                  ),
                if (_videoError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(_videoError!,
                        style: const TextStyle(
                            color: kRadiantRose,
                            fontSize: 11,
                            fontWeight: FontWeight.w500)),
                  ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildVideoPreview() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Video Terpasang:",
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: kNeonCyan)),
              Text(
                _videoUrl!.startsWith('/')
                    ? "Berkas Lokal: ${_videoUrl!.split('/').last}"
                    : _videoUrl!,
                style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => setState(() => _videoUrl = null),
          icon: const Icon(Icons.delete, color: kRadiantRose, size: 20),
        ),
      ],
    );
  }
}

class ProductQrDialog extends StatefulWidget {
  final Product product;
  const ProductQrDialog({super.key, required this.product});

  @override
  State<ProductQrDialog> createState() => _ProductQrDialogState();
}

class _ProductQrDialogState extends State<ProductQrDialog> {
  String _labelSize = "50x30 mm";
  bool _highContrast = false;
  bool _isSimulatingPrint = false;
  bool _printSuccess = false;

  void _simulatePrint() {
    setState(() {
      _isSimulatingPrint = true;
      _printSuccess = false;
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isSimulatingPrint = false;
          _printSuccess = true;
        });
        Provider.of<AppProvider>(context, listen: false).triggerNotification(
          "Cetak QR Selesai 🖨️",
          "Label QR Code untuk ${widget.product.name} berhasil dicetak ukuran $_labelSize.",
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppProvider>(context, listen: false);
    final qrText = widget.product.sku.isEmpty
        ? "PROD-${widget.product.id}"
        : widget.product.sku;

    return AlertDialog(
      backgroundColor: const Color(0xFF0B0F19),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(children: [
        Icon(Icons.qr_code, color: kNeonCyan, size: 24),
        SizedBox(width: 8),
        Text("Cetak Label & QR Code",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white)),
      ]),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pratinjau Stiker Thermal (Siap Cetak)",
                style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            // Label Preview
            Card(
              color: _highContrast ? Colors.white : const Color(0xFFF1F5F9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                    color: Colors.black.withValues(alpha:0.3), width: 1.5),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    const Text("SS SELLER SPHERE",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
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
                    Text(widget.product.name.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w900),
                        textAlign: TextAlign.center,
                        maxLines: 1),
                    Text("SKU: $qrText",
                        style: const TextStyle(
                            color: Colors.black87,
                            fontFamily: 'monospace',
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(viewModel.formatRupiah(widget.product.sellingPrice),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Configs
            _buildConfigRow(
              "Ukuran Kertas:",
              Row(
                children: ["50x30 mm", "40x40 mm", "30x30 mm"].map((size) {
                  final isSel = _labelSize == size;
                  return GestureDetector(
                    onTap: () => setState(() => _labelSize = size),
                    child: Container(
                      margin: const EdgeInsets.only(left: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSel
                            ? kNeonCyan.withValues(alpha:0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            color: isSel
                                ? kNeonCyan
                                : Colors.grey.withValues(alpha:0.5)),
                      ),
                      child: Text(size,
                          style: TextStyle(
                              fontSize: 10,
                              color: isSel ? kNeonCyan : Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  );
                }).toList(),
              ),
            ),
            _buildConfigRow(
              "Kontras Tinggi",
              Switch(
                value: _highContrast,
                onChanged: (v) => setState(() => _highContrast = v),
                activeThumbColor: kNeonCyan,
                activeTrackColor: kNeonCyan.withValues(alpha:0.3),
              ),
            ),
            if (_isSimulatingPrint)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: kNeonCyan)),
                    SizedBox(width: 8),
                    Text("Mencetak via Bluetooth...",
                        style: TextStyle(
                            fontSize: 11,
                            color: kNeonCyan,
                            fontWeight: FontWeight.bold)),
                  ]),
                ),
              )
            else if (_printSuccess)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("✓ Sukses mencetak!",
                      style: TextStyle(
                          color: kSoftTeal,
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed:
                _isSimulatingPrint ? null : () => Navigator.of(context).pop(),
            child: const Text("Tutup", style: TextStyle(color: Colors.white))),
        ElevatedButton.icon(
          onPressed: _isSimulatingPrint ? null : _simulatePrint,
          icon: const Icon(Icons.print, size: 16, color: Colors.black),
          label: const Text("Cetak QR Label",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(backgroundColor: kSoftTeal),
        ),
      ],
    );
  }

  Widget _buildConfigRow(String title, Widget control) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 12, color: Colors.white)),
          control,
        ],
      ),
    );
  }
}

class ProductGalleryDialog extends StatefulWidget {
  final Product product;
  const ProductGalleryDialog({super.key, required this.product});

  @override
  State<ProductGalleryDialog> createState() => _ProductGalleryDialogState();
}

class _ProductGalleryDialogState extends State<ProductGalleryDialog> {
  late int _activeIndex;

  @override
  void initState() {
    super.initState();
    _activeIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final urls = widget.product.imageUrls;

    return AlertDialog(
      backgroundColor: const Color(0xFF0B0F19),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text("Foto Produk - ${widget.product.name}",
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Large Image
          Container(
            height: 240,
            width: double.maxFinite,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color:
                      Theme.of(context).colorScheme.outline.withValues(alpha:0.3)),
            ),
            child: (urls.isNotEmpty && _activeIndex < urls.length)
                ? CachedNetworkImage(
                    imageUrl: urls[_activeIndex],
                    fit: BoxFit.contain,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, color: Colors.white),
                  )
                : const Center(
                    child: Text("Tidak ada gambar",
                        style: TextStyle(color: Colors.white))),
          ),
          const SizedBox(height: 16),
          // Thumbnails
          if (urls.length > 1)
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: urls.length,
                itemBuilder: (context, index) {
                  final isSelected = index == _activeIndex;
                  return GestureDetector(
                    onTap: () => setState(() => _activeIndex = index),
                    child: Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isSelected
                              ? kNeonCyan
                              : Theme.of(context)
                                  .colorScheme
                                  .outline
                                  .withValues(alpha:0.3),
                          width: isSelected ? 2.0 : 1.0,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          imageUrl: urls[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Tutup",
              style: TextStyle(fontWeight: FontWeight.bold, color: kNeonCyan)),
        ),
      ],
    );
  }
}

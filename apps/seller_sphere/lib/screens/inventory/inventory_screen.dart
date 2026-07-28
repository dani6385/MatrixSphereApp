import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:firebase_database/firebase_database.dart';
import 'widgets/inventory_body.dart';
import 'widgets/inventory_dialogs.dart';
import 'widgets/scanner_screen.dart';

// New widget for the sales tab content
class SalesBody extends StatefulWidget {
  final DatabaseReference productsRef;
  final String? scannedBarcode;

  const SalesBody({
    super.key,
    required this.productsRef,
    this.scannedBarcode,
  });

  @override
  State<SalesBody> createState() => _SalesBodyState();
}

class _SalesBodyState extends State<SalesBody> {
  final Map<String, Product> _cartItems = {};
  List<Product> _allProducts = [];

  @override
  void initState() {
    super.initState();
    _loadAllProducts();
  }

  @override
  void didUpdateWidget(covariant SalesBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scannedBarcode != null &&
        widget.scannedBarcode != oldWidget.scannedBarcode) {
      _addProductToCartByBarcode(widget.scannedBarcode!);
    }
  }

  Future<void> _loadAllProducts() async {
    final snapshot = await widget.productsRef.get();
    if (snapshot.exists && snapshot.value != null) {
      final productsMap = Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        _allProducts = productsMap.entries.map((entry) {
          return Product.fromMap(
              Map<String, dynamic>.from(entry.value), entry.key);
        }).toList();
      });
    }
  }

  void _addProductToCartByBarcode(String barcode) {
    if (barcode == '-1') return; // Scan dibatalkan

    try {
      final productToAdd = _allProducts.firstWhere((p) => p.sku == barcode);

      setState(() {
        if (_cartItems.containsKey(productToAdd.name)) {
          // Jika sudah ada, bisa tambahkan logika untuk menambah jumlah
          // Untuk saat ini, kita biarkan saja
        } else {
          _cartItems[productToAdd.name] = productToAdd;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('${productToAdd.name} ditambahkan ke keranjang.')),
      );
    } catch (e) {
      // firstWhere akan melempar error jika tidak ditemukan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Produk dengan barcode $barcode tidak ditemukan.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cartItems.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.point_of_sale, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Keranjang Penjualan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Scan barcode produk untuk menambahkannya ke sini.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: _cartItems.values.map((product) {
        return Card(
          child: ListTile(
            title: Text(product.name),
            subtitle: Text('Stok: ${product.stock}'),
            trailing: Text('Rp ${product.price.toStringAsFixed(0)}'),
          ),
        );
      }).toList(),
    );
  }
}

class InventoryScreen extends StatefulWidget {
  // Asumsikan shopUid didapat dari user yang sedang login atau dari halaman sebelumnya.
  // Untuk contoh ini, kita akan hardcode. Dalam aplikasi nyata, ini harus dinamis.
  final String shopUid;

  const InventoryScreen({super.key, required this.shopUid});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with TickerProviderStateMixin {
  // Add TickerProviderStateMixin
  // Gunakan service layer untuk interaksi database
  final FirebaseRtdbService _rtdbService = FirebaseRtdbService();
  late final DatabaseReference _productsRef;
  late TabController _tabController; // Declare TabController
  String? _lastScannedBarcode;

  @override
  void initState() {
    super.initState();
    // Initialize TabController with 2 tabs
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {})); // Untuk re-render AppBar
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Tentukan path yang benar untuk produk toko ini
    _productsRef =
        FirebaseDatabase.instance.ref('seller_sphere/${widget.shopUid}/produk');
  }

  // Callback untuk menyimpan produk (tambah atau edit)
  Future<void> _handleSaveProduct(Product productData) async {
    // Ensure productData.name is not empty or null before using it as a key
    if (productData.name.isEmpty) {
      // Handle error or provide a default name
      debugPrint('Product name cannot be empty.');
      return;
    }
    await _rtdbService.updateData(
      _productsRef.path,
      {productData.name: productData.toMap()},
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Produk berhasil ${productData.id.isNotEmpty ? 'diperbarui' : 'ditambahkan'}!'),
      ),
    );
  }

  // Logika untuk menghapus produk dari Firebase
  Future<void> _deleteProduct(String productName) async {
    try {
      final success =
          await _rtdbService.deleteData('${_productsRef.path}/$productName');

      // Periksa apakah widget masih ada sebelum menggunakan BuildContext.
      if (!mounted || !success) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil dihapus!')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus produk: $e')),
      );
    }
  }

  void _showProductFormDialog({Product? product}) {
    showProductFormModal(
        context: context, product: product, onSaveCallback: _handleSaveProduct);
  }

  // Fungsi untuk memulai proses scan barcode
  Future<void> _scanBarcode() async {
    // Buka halaman scanner dan tunggu hasilnya
    final barcodeScanRes = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const ScannerScreen()),
    );

    if (!mounted) return;

    // Jika pengguna kembali tanpa memindai, hasilnya akan null
    if (barcodeScanRes == null || barcodeScanRes.isEmpty) {
      return;
    }

    // Logika berdasarkan tab yang aktif
    if (_tabController.index == 0) {
      // Tab Inventaris: Buka form dengan SKU terisi
      _showProductFormDialog(
        product: Product(
          id: '',
          name: '',
          price: 0,
          stock: 0,
          sku: barcodeScanRes,
          purchasePrice: 0.0,
          sellingPrice: 0.0,
          minStockThreshold: 0,
          ageRating: 0,
          imageUrls: const [],
          // Isi field lain dengan nilai default jika diperlukan
        ),
      );
    } else {
      // Tab Penjualan: Kirim barcode ke SalesBody untuk ditambahkan ke keranjang
      setState(() {
        _lastScannedBarcode = barcodeScanRes + DateTime.now().toIso8601String();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // Wrap with DefaultTabController
      length: 2, // Two tabs: Inventory and Sales
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Manajemen Toko',
            style: TextStyle(
              color: kDarkTextPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Menggunakan warna latar putih bersih agar tidak suram
          backgroundColor: kDarkAppBar,
          elevation: 1, // Memberikan sedikit bayangan tipis agar elegan
          iconTheme: const IconThemeData(color: kDarkBorder),
          actions: [
            // Tombol Scan Barcode, selalu terlihat
            IconButton(
              icon: const Icon(Icons.qr_code_scanner),
              onPressed: _scanBarcode,
              tooltip: 'Scan Barcode',
            ),
            // Hanya tampilkan tombol 'Tambah' manual di tab Inventaris
            if (_tabController.index == 0)
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showProductFormDialog(
                  product: Product(
                    id: '',
                    name: '',
                    price: 0,
                    stock: 0,
                    sku: '',
                    purchasePrice: 0,
                    sellingPrice: 0,
                    minStockThreshold: 0,
                    ageRating: 0,
                    imageUrls: const [],
                  ),
                ),
                tooltip: 'Tambah Produk Manual',
              ),
          ],
          bottom: TabBar(
            // Add TabBar to the AppBar's bottom
            controller: _tabController, // Assign the controller
            tabs: const [
              Tab(text: 'Inventaris', icon: Icon(Icons.inventory)),
              Tab(text: 'Penjualan', icon: Icon(Icons.point_of_sale)),
            ],
            labelColor: kBrandPrimary, // Customize tab colors
            unselectedLabelColor: Colors.grey,
            indicatorColor: kBrandPrimary,
            indicatorWeight: 3.0, // Ketebalan garis indikator agar lebih tegas
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
        body: TabBarView(
          // Use TabBarView for tab content
          controller: _tabController, // Assign the controller
          children: [
            InventoryBody(
              productsRef: _productsRef,
              onSaveProduct: _handleSaveProduct,
              onDeleteProduct: _deleteProduct,
            ),
            SalesBody(
              productsRef: _productsRef,
              scannedBarcode: _lastScannedBarcode,
            ),
          ],
        ),
      ),
    );
  }
}

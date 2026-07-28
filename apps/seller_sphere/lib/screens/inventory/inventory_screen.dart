import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:firebase_database/firebase_database.dart';

class InventoryScreen extends StatefulWidget {
  // Asumsikan shopUid didapat dari user yang sedang login atau dari halaman sebelumnya.
  // Untuk contoh ini, kita akan hardcode. Dalam aplikasi nyata, ini harus dinamis.
  final String shopUid;

  const InventoryScreen({super.key, required this.shopUid});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  // Gunakan service layer untuk interaksi database
  final FirebaseRtdbService _rtdbService = FirebaseRtdbService();
  late final DatabaseReference _productsRef;

  @override
  void initState() {
    super.initState();
    // Tentukan path yang benar untuk produk toko ini
    _productsRef =
        FirebaseDatabase.instance.ref('seller_sphere/${widget.shopUid}/produk');
  }

  // Menampilkan dialog untuk menambah produk baru
  void _showAddProductDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Tambah Produk Baru',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 20),
                TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nama Produk'),
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
                TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Harga'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
                TextFormField(
                    controller: stockController,
                    decoration: const InputDecoration(labelText: 'Stok'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
                TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Deskripsi')),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final newProduct = Product(
                        id: '', // ID akan dibuat oleh Firebase key
                        name: nameController.text,
                        price: double.tryParse(priceController.text) ?? 0,
                        stock: int.tryParse(stockController.text) ?? 0,
                        description: descriptionController.text,
                        imageUrl: '',
                        purchasePrice: 0.0,
                        sellingPrice: 0.0,
                        minStockThreshold: 0,
                        ageRating: 0, // Default to 0 or a suitable integer
                        imageUrls: [], // Bisa ditambahkan nanti
                        // Isi properti lain dengan nilai default jika perlu
                      );

                      // Gunakan service untuk update data
                      await _rtdbService.updateData(
                        _productsRef.path,
                        {newProduct.name: newProduct.toMap()},
                      );

                      // Periksa apakah widget masih ada sebelum menggunakan BuildContext.
                      if (!context.mounted) return;

                      Navigator.pop(context); // Tutup bottom sheet
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Produk berhasil ditambahkan!')),
                      );
                    }
                  },
                  child: const Text('Simpan Produk'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventaris Toko'),
        backgroundColor: kLightTextPrimary,
      ),
      body: StreamBuilder(
        stream: _productsRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('Belum ada produk.'));
          }

          // Konversi data dari Firebase ke List<Product>
          final productsMap =
              Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
          final List<Product> products = productsMap.entries.map((entry) {
            // Key adalah nama produk, value adalah detail produk
            return Product.fromMap(
                Map<String, dynamic>.from(entry.value), entry.key);
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: ListTile(
                  leading: const Icon(Icons.inventory_2_outlined,
                      color: kLightTextPrimary),
                  title: Text(product.name, style: Theme.of(context).textTheme.headlineSmall),
                  subtitle: Text(
                      'Harga: Rp ${product.price.toStringAsFixed(0)} | Stok: ${product.stock}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: kAlertRed),
                    onPressed: () => _deleteProduct(product.name),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddProductDialog,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Produk'),
        backgroundColor: kLightBorder,
      ),
    );
  }

  // Hapus produk berdasarkan namanya (karena nama produk adalah key di Firebase)
  Future<void> _deleteProduct(String productName) async {
    try {
      // Gunakan service untuk menghapus data
      await _rtdbService.deleteData('${_productsRef.path}/$productName');
      final success = await _rtdbService.deleteData('${_productsRef.path}/$productName');

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
}

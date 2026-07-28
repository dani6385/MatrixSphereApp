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

  // Menampilkan dialog form untuk menambah atau mengedit produk.
  // Jika [product] null, maka mode 'Tambah'. Jika tidak, mode 'Edit'.
  void _showProductFormDialog({Product? product}) {
    final bool isEditing = product != null;
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    if (isEditing) {
      nameController.text = product.name;
      priceController.text = product.price.toStringAsFixed(0);
      stockController.text = product.stock.toString();
      descriptionController.text = product.description!;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kLightBackground,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: AppSpacing.lg,
            left: AppSpacing.md,
            right: AppSpacing.md),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isEditing ? 'Edit Produk' : 'Tambah Produk Baru',
                    style: AppStyles.primaryTitle(Theme.of(context).textTheme)),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                    controller: nameController,
                    // Nama produk tidak bisa diubah karena digunakan sebagai key di Firebase
                    readOnly: isEditing,
                    decoration: const InputDecoration(labelText: 'Nama Produk'),
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Harga'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                    controller: stockController,
                    decoration: const InputDecoration(labelText: 'Stok'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Deskripsi')),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: kLightBackground,
                    foregroundColor: kLightTextPrimary,
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final productData = Product(
                        id: product?.id ?? '',
                        name: nameController.text,
                        price: double.tryParse(priceController.text) ?? 0,
                        stock: int.tryParse(stockController.text) ?? 0,
                        description: descriptionController.text,
                        imageUrl: product?.imageUrl ?? '',
                        purchasePrice: 0.0,
                        sellingPrice: 0.0,
                        minStockThreshold: 0,
                        ageRating: 0,
                        imageUrls: [],
                      );

                      // Gunakan service untuk update data.
                      // Nama produk digunakan sebagai key unik.
                      await _rtdbService.updateData(
                        _productsRef.path,
                        {productData.name: productData.toMap()},
                      );

                      if (!context.mounted) return;

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Produk berhasil ${isEditing ? 'diperbarui' : 'ditambahkan'}!')),
                      );
                    }
                  },
                  child: const Text('Simpan Produk'),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk membangun daftar produk dari data snapshot Firebase
  Widget _buildProductList(List<Product> products) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductTile(product);
      },
    );
  }

  // Widget untuk satu item/tile produk dalam daftar
  Widget _buildProductTile(Product product) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: ListTile(
        leading: const Icon(Icons.inventory_2_outlined, color: kLightBackground),
        title: Text(product.name,
            style: AppStyles.primaryTitle(Theme.of(context).textTheme)),
        subtitle: Text(
            'Harga: Rp ${product.price.toStringAsFixed(0)} | Stok: ${product.stock}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: kLightTextSecondary),
              onPressed: () => _showProductFormDialog(product: product),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: kAlertRed),
              onPressed: () => _confirmDeleteProduct(product.name),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventaris Toko'),
        backgroundColor: kLightBackground,
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

          return _buildProductList(products);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showProductFormDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Produk'),
        backgroundColor: kLightBackground,
      ),
    );
  }

  // Menampilkan dialog konfirmasi sebelum menghapus produk
  Future<void> _confirmDeleteProduct(String productName) async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Produk'),
          content: Text('Anda yakin ingin menghapus produk "$productName"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: kAlertRed),
              child: const Text('Hapus'),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _deleteProduct(productName);
              },
            ),
          ],
        );
      },
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
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus produk: $e')),
      );
    }
  }
}

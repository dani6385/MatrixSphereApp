import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

/// Widget untuk menampilkan satu item produk dalam daftar inventaris.
/// Memungkinkan pengguna untuk memperbarui stoknya langsung.
class InventoryItemCard extends StatefulWidget {
  final Product product;
  // Removed onEdit callback as per user request to remove "inventory detail produk" from this view.
  final Function(Product product, int newStock) onStockUpdate;

  const InventoryItemCard({
    super.key,
    required this.product,
    required this.onStockUpdate,
  });

  @override
  State<InventoryItemCard> createState() => _InventoryItemCardState();
}

class _InventoryItemCardState extends State<InventoryItemCard> {
  late TextEditingController _stockController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _stockController = TextEditingController(text: widget.product.stock.toString());
  }

  @override
  void didUpdateWidget(covariant InventoryItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller text if the product's stock changes from outside (e.g., after a successful update)
    if (oldWidget.product.stock != widget.product.stock) {
      _stockController.text = widget.product.stock.toString();
    }
  }

  @override
  void dispose() {
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: AppStyles.primaryTitle(context.textTheme),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Harga: Rp ${widget.product.sellingPrice}',
                    style: AppStyles.dateDisplay(context.textTheme),
                  ),
                  const SizedBox(height: 8),
                  Form(
                    key: _formKey,
                    child: SizedBox(
                      width: 120, // Adjust width as needed
                      child: TextFormField(
                        controller: _stockController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Stok Baru', // Changed label
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Wajib diisi';
                          if (int.tryParse(value) == null) return 'Harus angka';
                          if (int.parse(value) < 0) return 'Tidak boleh negatif';
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Removed IconButton for editing product details
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final int newStock = int.parse(_stockController.text);
                  widget.onStockUpdate(widget.product, newStock);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
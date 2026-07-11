
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_ui/shared_ui.dart';
import '../viewmodels/app_view_model.dart';

class LabelPrinterScreen extends StatefulWidget {
  const LabelPrinterScreen({super.key});

  @override
  _LabelPrinterScreenState createState() => _LabelPrinterScreenState();
}

class _LabelPrinterScreenState extends State<LabelPrinterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Label Studio Pro"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              // Single column layout for small screens
              return _SingleColumnLayout();
            } else {
              // Two-panel layout for larger screens
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(child: _ControlsPanel()),
                  const SizedBox(width: 16),
                  Expanded(child: _PreviewPanel()),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class _SingleColumnLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        _PreviewPanel(),
        SizedBox(height: 24),
        _ControlsPanel(),
      ],
    );
  }
}

class _ControlsPanel extends StatefulWidget {
  const _ControlsPanel();

  @override
  __ControlsPanelState createState() => __ControlsPanelState();
}

class __ControlsPanelState extends State<_ControlsPanel> {
  bool _showProductDropdown = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppViewModel>();

    return ListView(
      // Removed NeverScrollableScrollPhysics to allow scrolling in single-column layout
      // physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        const Text("Pengaturan Label", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),

        // 1. Product Selection
        _buildSectionCard(
          title: "1. Pilih Barang",
          child: Column(
            children: [
              InkWell(
                onTap: () => setState(() => _showProductDropdown = !_showProductDropdown),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).colorScheme.outline),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          viewModel.selectedProductForLabel?.name ?? "Pilih dari inventaris...",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              if (_showProductDropdown)
                _ProductSelectionDropdown(onProductSelected: () => setState(() => _showProductDropdown = false)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        // 2. Customization (only if product is selected)
        if (viewModel.selectedProductForLabel != null)
            _buildSectionCard(
              title: "2. Atur Desain",
              child: _CustomizationFields(),
            ),
        const SizedBox(height: 12),

        // 3. Printer Connection
        _buildSectionCard(
          title: "3. Printer Bluetooth",
          child: _PrinterConnectionWidget(),
        ),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _ProductSelectionDropdown extends StatelessWidget {
    final VoidCallback onProductSelected;
    const _ProductSelectionDropdown({required this.onProductSelected});

    @override
    Widget build(BuildContext context) {
        final viewModel = context.watch<AppViewModel>();
        final products = viewModel.products;

        return Container(
            margin: const EdgeInsets.only(top: 8),
            height: 180,
            decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.outline),
                borderRadius: BorderRadius.circular(8),
            ),
            child: products.isEmpty
                ? const Center(child: Text("Tidak ada produk."))
                : ListView.separated(
                    itemCount: products.length,
                    separatorBuilder: (_, __) => Divider(height: 1, color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
                    itemBuilder: (context, index) {
                        final product = products[index];
                        return ListTile(
                            title: Text(product.name, style: const TextStyle(fontSize: 14)),
                            onTap: () {
                                context.read<AppViewModel>().selectProductForLabel(product);
                                onProductSelected();
                            },
                        );
                    },
                ),
        );
    }
}

class _CustomizationFields extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        final viewModel = context.watch<AppViewModel>();
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                TextField(
                    controller: TextEditingController(text: viewModel.customStoreName),
                    onChanged: (value) => viewModel.updateCustomStoreName(value),
                    decoration: const InputDecoration(labelText: "Nama Toko", border: OutlineInputBorder()),
                    style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                const Text("Template Desain", style: TextStyle(fontSize: 12)),
                const SizedBox(height: 4),
                _HorizontalChipSelector(
                    options: const ["Minimalis Modern", "Diskon/Promo", "Grosir", "Barcode Klasik", "QR Code"],
                    selectedValue: viewModel.selectedTemplate,
                    onSelected: (value) => viewModel.updateLabelTemplate(value),
                ),
                const SizedBox(height: 16),
                if (viewModel.selectedTemplate == "Diskon/Promo") ...[
                    TextField(
                        controller: TextEditingController(text: viewModel.promoDiscountPercent.toString()),
                        onChanged: (value) => viewModel.updatePromoDiscount(int.tryParse(value) ?? 0),
                        decoration: const InputDecoration(labelText: "Persentase Diskon %", border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                ],
                const Text("Ukuran Kertas", style: TextStyle(fontSize: 12)),
                const SizedBox(height: 4),
                 _HorizontalChipSelector(
                    options: const ["50x30 mm", "40x30 mm", "30x20 mm"],
                    selectedValue: viewModel.labelSize,
                    onSelected: (value) => viewModel.updateLabelSize(value),
                    selectedColor: Theme.of(context).colorScheme.secondary,
                ),
            ],
        );
    }
}

class _PrinterConnectionWidget extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        final viewModel = context.watch<AppViewModel>();
        final printerState = viewModel.printerConnectionState;
        final isConnected = printerState.contains("Terhubung");

        return Column(
            children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text("Status: $printerState", style: TextStyle(fontSize: 12, color: isConnected ? kSoftTeal : null, fontWeight: isConnected ? FontWeight.bold : FontWeight.normal)),
                        if (isConnected)
                            TextButton(onPressed: viewModel.disconnectPrinter, child: const Text("Putus", style: TextStyle(color: kRadiantRose)))
                        else
                            ElevatedButton(onPressed: viewModel.startPrinterDiscovery, child: const Text("Cari", style: TextStyle(fontSize: 12)))
                    ],
                ),
                if (printerState == "Mencari...")
                    const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Center(child: CircularProgressIndicator()),
                    ),
                if (viewModel.availablePrinters.isNotEmpty && printerState == "Pilih Printer")
                    Container(
                         margin: const EdgeInsets.only(top: 8),
                         height: 120,
                         decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).colorScheme.outline),
                            borderRadius: BorderRadius.circular(8),
                         ),
                         child: ListView.builder(
                            itemCount: viewModel.availablePrinters.length,
                            itemBuilder: (context, index) {
                                final printer = viewModel.availablePrinters[index];
                                return ListTile(title: Text(printer, style: const TextStyle(fontSize: 12)), onTap: () => viewModel.connectToPrinter(printer));
                            },
                         ),
                    )
            ],
        );
    }
}

class _HorizontalChipSelector extends StatelessWidget {
    final List<String> options;
    final String selectedValue;
    final Function(String) onSelected;
    final Color? selectedColor;

    const _HorizontalChipSelector({required this.options, required this.selectedValue, required this.onSelected, this.selectedColor});

    @override
    Widget build(BuildContext context) {
        return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: options.map((option) {
                    return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                            label: Text(option, style: const TextStyle(fontSize: 11)),
                            selected: selectedValue == option,
                            onSelected: (selected) => onSelected(option),
                            selectedColor: selectedColor?.withValues(alpha: 0.2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: selectedColor ?? Theme.of(context).primaryColor)),
                        ),
                    );
                }).toList(),
            ),
        );
    }
}

class _PreviewPanel extends StatelessWidget {
    const _PreviewPanel();

    @override
    Widget build(BuildContext context) {
        final viewModel = context.watch<AppViewModel>();
        final selectedProduct = viewModel.selectedProductForLabel;
        final isPrinting = viewModel.isPrinting;

        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                 const Text("Pratinjau Stiker Label", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                 const SizedBox(height: 12),
                 SizedBox(
                    width: 240,
                    height: 180,
                    child: Card(
                        color: Colors.white,
                        elevation: 8,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: selectedProduct == null
                            ? const Center(child: Text("Pilih produk untuk pratinjau", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)))
                            : _LabelPreview(product: selectedProduct, template: viewModel.selectedTemplate, storeName: viewModel.customStoreName, discount: viewModel.promoDiscountPercent),
                    ),
                 ),
                 const SizedBox(height: 20),
                 Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        ElevatedButton.icon(
                            onPressed: selectedProduct != null && viewModel.printerConnectionState.contains("Terhubung") && !isPrinting
                                ? viewModel.simulatePrintLabel
                                : null,
                            icon: isPrinting ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.print, size: 16),
                            label: Text(isPrinting ? "Mencetak..." : "Cetak"),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                            onPressed: selectedProduct != null ? () => viewModel.triggerNotification("PDF Tersimpan", "Format label telah diekspor.") : null,
                            icon: const Icon(Icons.picture_as_pdf, size: 16),
                            label: const Text("PDF"),
                        ),
                    ],
                 ),
            ],
        );
    }
}

class _LabelPreview extends StatelessWidget {
    final Product product;
    final String template;
    final String storeName;
    final int discount;

    const _LabelPreview({required this.product, required this.template, required this.storeName, required this.discount});

    @override
    Widget build(BuildContext context) {
        if (template == "QR Code") {
            return _QrCodeLabel(product: product, storeName: storeName);
        }

        return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Text(storeName.toUpperCase(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11)),
                    Container(height: 1.5, color: Colors.black),
                    Text(product.name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                    _buildPriceSection(),
                    SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: CustomPaint(painter: _BarcodePainter()),
                    ),
                    Text(product.sku.isNotEmpty ? product.sku : "PROD-${product.id}", style: const TextStyle(color: Colors.black, fontFamily: 'monospace', fontSize: 9)),
                ],
            ),
        );
    }

    Widget _buildPriceSection() {
        final formattedPrice = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(product.sellingPrice);

        if (template == "Diskon/Promo") {
            final finalPrice = product.sellingPrice * (100 - discount) / 100;
            final formattedFinalPrice = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(finalPrice);
            return Column(
                children: [
                    Text(formattedPrice, style: const TextStyle(color: Colors.grey, fontSize: 10, decoration: TextDecoration.lineThrough)),
                    Text(formattedFinalPrice, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
            );
        }

        return Text(formattedPrice, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16));
    }
}

class _QrCodeLabel extends StatelessWidget {
    final Product product;
    final String storeName;
    const _QrCodeLabel({required this.product, required this.storeName});

    @override
    Widget build(BuildContext context) {
        final qrText = product.sku.isNotEmpty ? product.sku : "PROD-${product.id}";
        final formattedPrice = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(product.sellingPrice);

        return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                     Text(storeName.toUpperCase(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
                     Container(height: 1, color: Colors.black),
                     QrImageView(data: qrText, version: QrVersions.auto, size: 75, gapless: false),
                     Column(
                         children: [
                             Text(product.name.toUpperCase(), style: const TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                             Text(formattedPrice, style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                         ],
                     ),
                ],
            ),
        );
    }
}

class _BarcodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    final pattern = [2, 4, 1, 3, 2, 1, 4, 2, 3, 1, 2, 4, 1, 3, 2, 1, 4, 2, 3, 1, 2];
    double currentX = 0;
    int patternIndex = 0;
    final barWidthBase = size.width / (pattern.length * 4); 

    while (currentX < size.width) {
      final widthMultiplier = pattern[patternIndex % pattern.length];
      final barWidth = barWidthBase * widthMultiplier;
      canvas.drawRect(Rect.fromLTWH(currentX, 0, barWidth, size.height), paint);
      currentX += barWidth + (barWidthBase * 1.5);
      patternIndex++;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

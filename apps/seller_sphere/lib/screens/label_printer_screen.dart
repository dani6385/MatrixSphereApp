//import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_sphere/data/local/app_database.dart';
import 'package:seller_sphere/viewmodel/app_view_model.dart';
import 'package:shared_ui/shared_ui.dart';

class LabelPrinterScreen extends ConsumerWidget {
  const LabelPrinterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _SettingsPanel()),
            SizedBox(width: 16),
            Expanded(child: _CanvasAndOutputPanel()),
          ],
        ),
      ),
    );
  }
}

class _SettingsPanel extends ConsumerWidget {
  const _SettingsPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final viewModel = ref.watch(appViewModelProvider);

    return ListView(
      children: [
        Text("Label Studio Pro", style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        _ProductSelectionCard(),
        const SizedBox(height: 12),
        if (viewModel.selectedProductForLabel != null)
          const _CustomizeLabelCard(),
        const SizedBox(height: 12),
        const _BluetoothPrintingCard(),
      ],
    );
  }
}

class _ProductSelectionCard extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ProductSelectionCard> createState() =>
      _ProductSelectionCardState();
}

class _ProductSelectionCardState extends ConsumerState<_ProductSelectionCard> {
  bool _showDropdown = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = ref.watch(appViewModelProvider);
    final selectedProduct = viewModel.selectedProductForLabel;
    final productsStream = ref.watch(productsProvider);

    return Card(
      color: theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("1. Pilih Barang", style: theme.textTheme.labelMedium),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => setState(() => _showDropdown = !_showDropdown),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border.all(color: theme.colorScheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  selectedProduct?.name ?? "Pilih barang dari stok...",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: selectedProduct != null
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant.withAlpha(6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            if (_showDropdown)
              productsStream.when(
                data: (products) => Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: 180,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    border: Border.all(
                      color: theme.colorScheme.outline.withAlpha(5),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: products.isEmpty
                      ? const Center(
                          child: Text("Tidak ada barang di inventaris"),
                        )
                      : ListView.separated(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ListTile(
                              title: Text(
                                product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                viewModel.selectProductForLabel(product);
                                setState(() => _showDropdown = false);
                              },
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: theme.colorScheme.outline.withAlpha(2),
                          ),
                        ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text("Error: $err")),
              ),
          ],
        ),
      ),
    );
  }
}

class _CustomizeLabelCard extends ConsumerWidget {
  const _CustomizeLabelCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final viewModel = ref.watch(appViewModelProvider);

    return Card(
      color: theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("2. Atur Desain", style: theme.textTheme.labelMedium),
            const SizedBox(height: 12),
            TextField(
              controller: TextEditingController(
                text: viewModel.customStoreName,
              ),
              onChanged: viewModel.updateCustomStoreName,
              decoration: const InputDecoration(
                labelText: "Nama Toko",
                border: OutlineInputBorder(),
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 10),
            _buildPicker(
              context: context,
              title: "Template Desain",
              options: [
                "Minimalis Modern",
                "Diskon/Promo",
                "Grosir",
                "Barcode Klasik",
              ],
              selectedValue: viewModel.selectedTemplate,
              onSelected: viewModel.updateLabelTemplate,
              selectedColor: theme.colorScheme.primary,
            ),
            if (viewModel.selectedTemplate == "Diskon/Promo") ...[
              const SizedBox(height: 10),
              TextField(
                controller: TextEditingController(
                  text: viewModel.promoDiscountPercent.toString(),
                ),
                onChanged: (val) =>
                    viewModel.updatePromoDiscount(int.tryParse(val) ?? 0),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Persentase Diskon %",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 10),
            _buildPicker(
              context: context,
              title: "Ukuran Kertas",
              options: ["50x30 mm", "40x30 mm", "30x20 mm"],
              selectedValue: viewModel.labelSize,
              onSelected: viewModel.updateLabelSize,
              selectedColor: theme.colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPicker({
    required BuildContext context,
    required String title,
    required List<String> options,
    required String selectedValue,
    required Function(String) onSelected,
    required Color selectedColor,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withAlpha(7),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: options.map((opt) {
            final isSelected = selectedValue == opt;
            return Expanded(
              child: GestureDetector(
                onTap: () => onSelected(opt),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? selectedColor.withAlpha(2)
                        : theme.colorScheme.surface,
                    border: Border.all(
                      color: isSelected
                          ? selectedColor
                          : theme.colorScheme.outline.withAlpha(5),
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      opt.split('/').first,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? selectedColor
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _BluetoothPrintingCard extends ConsumerWidget {
  const _BluetoothPrintingCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final viewModel = ref.watch(appViewModelProvider);
    final printerState = viewModel.printerConnectionState;
    final isConnected = printerState.contains("Terhubung");

    return Card(
      color: theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isConnected ? Icons.bluetooth_connected : Icons.bluetooth,
                      color: isConnected
                          ? kSuccessColor
                          : theme.colorScheme.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Koneksi Printer Bluetooth",
                      style: theme.textTheme.labelMedium,
                    ),
                  ],
                ),
                if (isConnected)
                  GestureDetector(
                    onTap: viewModel.disconnectPrinter,
                    child: const Text(
                      "Putus",
                      style: TextStyle(
                        color: kRadiantRose,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Status: $printerState",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isConnected
                        ? kSuccessColor
                        : theme.colorScheme.onSurfaceVariant.withAlpha(8),
                    fontWeight: isConnected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                if (printerState == "Terputus" ||
                    printerState == "Pilih Printer")
                  ElevatedButton(
                    onPressed: viewModel.startPrinterDiscovery,
                    child: const Text("Cari Printer"),
                  ),
              ],
            ),
            if (printerState == "Mencari...")
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 8),
                    Text("Mencari printer...", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            if (viewModel.availablePrinters.isNotEmpty &&
                printerState == "Pilih Printer")
              Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border.all(
                    color: theme.colorScheme.outline.withAlpha(5),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: viewModel.availablePrinters
                      .map(
                        (p) => ListTile(
                          title: Text(p, style: const TextStyle(fontSize: 12)),
                          onTap: () => viewModel.connectToPrinter(p),
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CanvasAndOutputPanel extends ConsumerWidget {
  const _CanvasAndOutputPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final viewModel = ref.watch(appViewModelProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Pratinjau Stiker Label",
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            width: 240,
            height: 180,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black.withAlpha(2)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: viewModel.selectedProductForLabel == null
                ? const Center(
                    child: Text(
                      "[ Pilih barang di panel kiri ]\nuntuk melihat pratinjau label",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  )
                : _LabelCanvas(product: viewModel.selectedProductForLabel!),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 240,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: viewModel.isPrinting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.print, size: 16),
                  label: const Text("Cetak"),
                  onPressed:
                      viewModel.selectedProductForLabel != null &&
                          viewModel.printerConnectionState.contains(
                            "Terhubung",
                          ) &&
                          !viewModel.isPrinting
                      ? viewModel.simulatePrintLabel
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.upload_file, size: 16),
                  label: const Text("PDF"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    foregroundColor: theme.colorScheme.onSecondary,
                  ),
                  onPressed: viewModel.selectedProductForLabel != null
                      ? () => viewModel.triggerNotification(
                          "PDF Tersimpan",
                          "Label PDF diekspor.",
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
        if (viewModel.isPrinting)
          Card(
            margin: const EdgeInsets.only(top: 16),
            color: theme.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Mengirim perintah...",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _LabelCanvas extends ConsumerWidget {
  final Product product;
  const _LabelCanvas({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(appViewModelProvider);
    final customStoreName = viewModel.customStoreName;
    final selectedTemplate = viewModel.selectedTemplate;
    final promoDiscount = viewModel.promoDiscountPercent;

    return Stack(
      children: [
        CustomPaint(painter: _BarcodePainter(), size: const Size(240, 180)),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                customStoreName.toUpperCase(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Container(
                height: 1.5,
                color: Colors.black,
                width: double.infinity,
              ),
              const SizedBox(height: 4),
              Text(
                product.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              _buildPriceSection(
                context,
                viewModel,
                selectedTemplate,
                product,
                promoDiscount,
              ),
              const Spacer(),
              Text(
                product.sku.isEmpty ? "0000000" : product.sku,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 8,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection(
    BuildContext context,
    AppViewModel viewModel,
    String template,
    Product product,
    int discount,
  ) {
    switch (template) {
      case "Diskon/Promo":
        final originalPrice = product.sellingPrice;
        final finalPrice = originalPrice * (100 - discount) / 100;
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  viewModel.formatRupiah(originalPrice),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 1,
                  ),
                  color: Colors.black,
                  child: Text(
                    "PROMO $discount%",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 7,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              viewModel.formatRupiah(finalPrice),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        );
      case "Grosir":
        return Column(
          children: [
            const Text(
              "HARGA GROSIR",
              style: TextStyle(
                color: Colors.black,
                fontSize: 8,
                fontWeight: FontWeight.w800,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  viewModel.formatRupiah(product.sellingPrice),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  "(Min. 3 Pcs)",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        );
      case "Barcode Klasik":
        return Text(
          viewModel.formatRupiah(product.sellingPrice),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        );
      default: // Minimalis Modern
        return Text(
          viewModel.formatRupiah(product.sellingPrice),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        );
    }
  }
}

class _BarcodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    final barcodeTop = size.height * 0.65;
    final barcodeHeight = size.height * 0.22;
    final pattern = [
      2,
      4,
      1,
      3,
      2,
      1,
      4,
      2,
      3,
      1,
      2,
      4,
      1,
      3,
      2,
      1,
      4,
      2,
      3,
      1,
      2,
    ];
    var currentX = size.width * 0.15;
    final barWidthBase = size.width * 0.008;
    final maxBarX = size.width * 0.85;
    var pIdx = 0;

    while (currentX < maxBarX) {
      final barWidth = barWidthBase * pattern[pIdx % pattern.length];
      canvas.drawRect(
        Rect.fromLTWH(currentX, barcodeTop, barWidth, barcodeHeight),
        paint,
      );
      currentX += barWidth + barWidthBase * 1.5;
      pIdx++;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

final productsProvider = StreamProvider<List<Product>>((ref) {
  final viewModel = ref.watch(appViewModelProvider);
  return viewModel.products;
});

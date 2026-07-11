
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/shared_ui.dart';
import '../viewmodels/app_view_model.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  SaleTransaction? _selectedTransactionForInvoice;
  // PDF generation simulation state
  double? _pdfProgress;
  bool _pdfGenerated = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppViewModel>();
    final transactions = viewModel.transactions;

    // Auto-select the first transaction if none is selected
    if (_selectedTransactionForInvoice == null && transactions.isNotEmpty) {
      _selectedTransactionForInvoice = transactions.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan Keuangan"),
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _PerformanceOverviewCard(),
          const SizedBox(height: 12),
          _LowStockPdfCard(
            progress: _pdfProgress,
            isGenerated: _pdfGenerated,
            onGenerate: () async {
              if (viewModel.lowStockProducts.isEmpty) {
                viewModel.triggerNotification("Laporan PDF", "Tidak ada produk stok menipis.");
                return;
              }
              setState(() => _pdfProgress = 0.0);
              // Simulate PDF generation
              for (int i = 1; i <= 10; i++) {
                await Future.delayed(const Duration(milliseconds: 150));
                setState(() => _pdfProgress = i / 10.0);
              }
              setState(() {
                _pdfProgress = null;
                _pdfGenerated = true;
              });
              viewModel.triggerNotification("Unduh PDF Selesai", "Laporan Stok Menipis berhasil diunduh.");
            },
            onOpen: () {
               viewModel.triggerNotification("Membuka PDF", "Membuka laporan stok menipis...");
            },
            onRegenerate: () => setState(() => _pdfGenerated = false),
          ),
          const SizedBox(height: 12),
          if (_selectedTransactionForInvoice != null)
            _DigitalInvoiceCard(transaction: _selectedTransactionForInvoice!),
          const SizedBox(height: 16),
          Text("Riwayat Penjualan (${transactions.length})", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          _TransactionHistoryList(onSelectTransaction: (trans) {
            setState(() {
              _selectedTransactionForInvoice = trans;
            });
          }),
        ],
      ),
    );
  }
}

class _PerformanceOverviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppViewModel>();
    final transactions = viewModel.transactions;

    final totalSales = transactions.fold<double>(0, (sum, t) => sum + t.totalAmount);
    final totalProfit = transactions.fold<double>(0, (sum, t) => sum + t.totalProfit);
    final totalExpenses = totalSales - totalProfit;
    final averageTransactionVal = transactions.isNotEmpty ? totalSales / transactions.length : 0.0;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ringkasan Performa Toko",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 10),
            _StatRow(label1: "Total Omzet", value1: viewModel.formatRupiah(totalSales), label2: "Laba Bersih", value2: viewModel.formatRupiah(totalProfit), value2Color: kSoftTeal),
            const Divider(height: 20),
            _StatRow(label1: "Total HPP", value1: viewModel.formatRupiah(totalExpenses), label2: "Rata-rata Penjualan", value2: viewModel.formatRupiah(averageTransactionVal)),
             const SizedBox(height: 12),
            Row(
                children: [
                    Expanded(
                        child: ElevatedButton.icon(
                            onPressed: () => viewModel.triggerNotification("Excel Diekspor", "Data produk diunduh."),
                            icon: const Icon(Icons.file_download, size: 16),
                            label: const Text("Excel Produk", style: TextStyle(fontSize: 12)),
                        ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                        child: ElevatedButton.icon(
                            onPressed: () => viewModel.triggerNotification("Excel Diekspor", "Data transaksi diunduh."),
                            icon: const Icon(Icons.download, size: 16),
                            label: const Text("Excel Transaksi", style: TextStyle(fontSize: 12)),
                            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
                        ),
                    ),
                ],
            )
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
    final String label1, value1, label2, value2;
    final Color? value2Color;
    const _StatRow({required this.label1, required this.value1, required this.label2, required this.value2, this.value2Color});

    @override
    Widget build(BuildContext context) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                _StatItem(label: label1, value: value1),
                _StatItem(label: label2, value: value2, color: value2Color, alignment: CrossAxisAlignment.end),
            ],
        );
    }
}

class _StatItem extends StatelessWidget {
    final String label, value;
    final Color? color;
    final CrossAxisAlignment alignment;
    const _StatItem({required this.label, required this.value, this.color, this.alignment = CrossAxisAlignment.start});

    @override
    Widget build(BuildContext context) {
        return Column(
            crossAxisAlignment: alignment,
            children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
            ],
        );
    }
}

class _LowStockPdfCard extends StatelessWidget {
  final double? progress;
  final bool isGenerated;
  final VoidCallback onGenerate;
  final VoidCallback onOpen;
  final VoidCallback onRegenerate;

  const _LowStockPdfCard({this.progress, required this.isGenerated, required this.onGenerate, required this.onOpen, required this.onRegenerate});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppViewModel>();
    final hasLowStock = viewModel.lowStockProducts.isNotEmpty;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(hasLowStock ? Icons.warning_amber : Icons.assignment, color: hasLowStock ? kWarmOrange : kSoftTeal),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Laporan Stok Menipis (PDF)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(hasLowStock ? "${viewModel.lowStockProducts.length} produk di bawah batas" : "Stok produk aman", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  if(progress != null) Text("Memproses... ${(progress! * 100).toInt()}%", style: const TextStyle(fontSize: 10, color: kNeonCyan)),
                ],
              ),
            ),
            if (progress != null)
              CircularProgressIndicator(value: progress, strokeWidth: 2,)
            else if (isGenerated)
              Row(
                  children: [
                      TextButton(onPressed: onOpen, child: const Text("Buka", style: TextStyle(fontSize: 12))),
                      TextButton(onPressed: onRegenerate, child: const Text("Ulang", style: TextStyle(fontSize: 12))),
                  ],
              )
            else
               ElevatedButton.icon(
                   onPressed: onGenerate,
                   icon: const Icon(Icons.picture_as_pdf, size: 16),
                   label: const Text("Unduh", style: TextStyle(fontSize: 12)),
               )
          ],
        ),
      ),
    );
  }
}

class _DigitalInvoiceCard extends StatelessWidget {
    final SaleTransaction transaction;
    const _DigitalInvoiceCard({required this.transaction});

    @override
    Widget build(BuildContext context) {
      final viewModel = context.read<AppViewModel>();
      final formattedDate = DateFormat("yyyy/MM/dd HH:mm").format(DateTime.fromMillisecondsSinceEpoch(transaction.timestamp));

      return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                  children: [
                      const Text("Lembar Nota Digital", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        height: 320,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black.withValues(alpha: 0.15))
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(viewModel.customStoreName.toUpperCase(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Trans: #${transaction.id}", style: const TextStyle(color: Colors.black, fontSize: 9)), Text(formattedDate, style: const TextStyle(color: Colors.black, fontSize: 9))]),
                            const Divider(color: Colors.black, thickness: 1),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Item", style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold)), const Text("Total", style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold))]),
                            const Divider(color: Colors.black26, thickness: 0.5),
                            // Simplified item list for preview
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Item SSphere Pro", style: TextStyle(color: Colors.black, fontSize: 9)), Text(viewModel.formatRupiah(transaction.totalAmount), style: const TextStyle(color: Colors.black, fontSize: 9))]),
                            const Spacer(),
                            const Divider(color: Colors.black, thickness: 1),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("TOTAL BAYAR:", style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)), Text(viewModel.formatRupiah(transaction.totalAmount), style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold))]),
                          ],
                        ),
                      ),
                       const SizedBox(height: 10),
                       SizedBox(
                         width: double.infinity,
                         child: ElevatedButton.icon(
                          onPressed: () => viewModel.triggerNotification("PDF Nota Dicetak", "Nota untuk transaksi #${transaction.id} telah dicetak."),
                          icon: const Icon(Icons.receipt_long, size: 18),
                          label: const Text("Cetak Nota / PDF"),
                         ),
                       )
                  ],
              ),
          ),
      );
    }
}

class _TransactionHistoryList extends StatefulWidget {
  final Function(SaleTransaction) onSelectTransaction;
  const _TransactionHistoryList({required this.onSelectTransaction});

  @override
  __TransactionHistoryListState createState() => __TransactionHistoryListState();
}

class __TransactionHistoryListState extends State<_TransactionHistoryList> {
  int? _selectedId;

  @override
  Widget build(BuildContext context) {
    final transactions = context.watch<AppViewModel>().transactions;

    if (transactions.isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.all(32.0), child: Text("Belum ada transaksi.")));
    }

    if (_selectedId == null && transactions.isNotEmpty) {
      _selectedId = transactions.first.id;
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final trans = transactions[index];
        final isSelected = _selectedId == trans.id;
        return _TransactionHistoryRow(
          transaction: trans,
          isSelected: isSelected,
          onSelect: () {
            widget.onSelectTransaction(trans);
            setState(() {
              _selectedId = trans.id;
            });
          },
        );
      },
    );
  }
}


class _TransactionHistoryRow extends StatelessWidget {
  final SaleTransaction transaction;
  final bool isSelected;
  final VoidCallback onSelect;

  const _TransactionHistoryRow({required this.transaction, required this.isSelected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<AppViewModel>();
    final dateStr = DateFormat("dd MMM, HH:mm", "id_ID").format(DateTime.fromMillisecondsSinceEpoch(transaction.timestamp));
    final isCash = transaction.paymentMethod == "Tunai";

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: isSelected ? Theme.of(context).primaryColor : Colors.transparent, width: 1.5)
      ),
      color: isSelected ? Theme.of(context).primaryColor.withValues(alpha: 0.15) : Theme.of(context).colorScheme.surfaceContainerHighest,
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.receipt, color: isCash ? kWarmOrange : kSoftTeal),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Transaksi #${transaction.id}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text("$dateStr • ${transaction.paymentMethod}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(viewModel.formatRupiah(transaction.totalAmount), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: kNeonCyan)),
                  Text("Laba: ${viewModel.formatRupiah(transaction.totalProfit)}", style: const TextStyle(fontSize: 11, color: kSoftTeal)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

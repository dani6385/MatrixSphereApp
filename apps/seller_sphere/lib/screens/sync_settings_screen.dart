import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/shared_ui.dart';
import '../viewmodels/app_view_model.dart';

class SyncSettingsScreen extends StatelessWidget {
  const SyncSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sinkronisasi & Konfigurasi"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          _RealtimeSyncCard(),
          SizedBox(height: 16),
          _SyncLoggerCard(),
          SizedBox(height: 16),
          _CsvImportExportCard(),
        ],
      ),
    );
  }
}

class _RealtimeSyncCard extends StatefulWidget {
  const _RealtimeSyncCard();

  @override
  __RealtimeSyncCardState createState() => __RealtimeSyncCardState();
}

class __RealtimeSyncCardState extends State<_RealtimeSyncCard> {
  final _joinCodeController = TextEditingController();

  @override
  void dispose() {
    _joinCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppViewModel>();
    final syncCode = viewModel.syncCode ?? "------";
    final isSyncing = viewModel.isSyncing;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.cloud_sync, color: kNeonCyan, size: 24),
                SizedBox(width: 10),
                Text("Sinkronisasi Real-time", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Gunakan kode unik di bawah untuk menyinkronkan data secara instan di antara berbagai perangkat toko Anda.",
              style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.8)),
            ),
            const SizedBox(height: 16),
            _buildSyncCodeDisplay(context, syncCode, viewModel),
            const SizedBox(height: 14),
            _buildJoinCodeInput(viewModel),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: isSyncing ? null : viewModel.triggerManualSync,
                icon: isSyncing 
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.sync, size: 16),
                label: Text(isSyncing ? "Menyinkronkan..." : "Sinkronkan Sekarang"),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncCodeDisplay(BuildContext context, String syncCode, AppViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Kode Sinkronisasi Perangkat", style: TextStyle(fontSize: 11, color: Colors.grey[400])),
              Text(syncCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kNeonCyan, fontFamily: 'monospace')),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.content_copy, size: 20),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: syncCode));
                  viewModel.triggerNotification("Kode Disalin", "Kode sinkronisasi berhasil disalin.");
                },
                tooltip: "Salin Kode",
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: kWarmOrange, size: 20),
                onPressed: viewModel.generateSyncCode,
                tooltip: "Buat Kode Baru",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJoinCodeInput(AppViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: TextField(
              controller: _joinCodeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Masukkan kode lain",
                contentPadding: EdgeInsets.symmetric(horizontal: 12)
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              if (_joinCodeController.text.isNotEmpty) {
                viewModel.pullDataFromRtdb(_joinCodeController.text);
                _joinCodeController.clear();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
            child: const Text("Hubungkan"),
          ),
        ),
      ],
    );
  }
}

class _SyncLoggerCard extends StatelessWidget {
  const _SyncLoggerCard();

  @override
  Widget build(BuildContext context) {
    final syncLogs = context.watch<AppViewModel>().syncLogs;
    return Card(
      color: const Color(0xFF020617),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "LOG AKTIVITAS SINKRONISASI REAL-TIME",
              style: TextStyle(fontSize: 10, color: kSoftTeal, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
            ),
            const Divider(color: kSoftTeal, height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: syncLogs.length,
                itemBuilder: (context, index) {
                  return Text(
                    syncLogs[index],
                    style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.8), fontFamily: 'monospace'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CsvImportExportCard extends StatefulWidget {
  const _CsvImportExportCard();

  @override
  __CsvImportExportCardState createState() => __CsvImportExportCardState();
}

class __CsvImportExportCardState extends State<_CsvImportExportCard> {
  final _csvController = TextEditingController();

   @override
  void dispose() {
    _csvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<AppViewModel>();
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const Row(
              children: [
                Icon(Icons.library_add, color: kWarmOrange, size: 22),
                SizedBox(width: 10),
                Text("Impor Barang dari CSV Excel", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Tempel teks CSV di bawah untuk memasukkan produk sekaligus ke inventaris toko.",
              style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.8)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _csvController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Tempel CSV di sini...",
              ),
              maxLines: 4,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _csvController.text.isNotEmpty
                        ? () {
                            final success = viewModel.importProductsFromCsv(_csvController.text);
                            if (success) {
                              _csvController.clear();
                            } else {
                              viewModel.triggerNotification("Format Salah", "Gagal memproses baris CSV.");
                            }
                          }
                        : null,
                    icon: const Icon(Icons.cloud_upload, size: 16),
                    label: const Text("Impor CSV", style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final csvData = viewModel.exportProductsToCsv();
                      Clipboard.setData(ClipboardData(text: csvData));
                      viewModel.triggerNotification("CSV Disalin", "Katalog barang disalin ke clipboard.");
                    },
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text("Salin Katalog", style: TextStyle(fontSize: 12)),
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

// lib/services/transaction_export_service.dart
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// Import model Transaction milikmu
import '../models/transaction.dart';

class TransactionExportService {
  // Fungsi untuk mengekspor data ke CSV
  static Future<void> exportToCsv(
    BuildContext context,
    List<Transaction> transactions,
  ) async {
    if (transactions.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada data untuk diekspor')),
      );
      return;
    }

    List<List<dynamic>> rows = [];
    // Header CSV
    rows.add(['ID', 'Tanggal', 'Tipe', 'Status', 'Jumlah']);

    // Memasukkan data transaksi
    for (var transaction in transactions) {
      rows.add([
        transaction.id,
        DateFormat('yyyy-MM-dd HH:mm').format(transaction.timestamp.toLocal()),
        transaction.type,
        transaction.status,
        transaction.amount,
      ]);
    }
    
    // Gunakan ListToCsvConverter tanpa const jika terjadi error
    final csvConverter = ListToCsvConverter();
    String csvData = csvConverter.convert(rows);

    await _saveAndOpenFile(
        context, 'transactions.csv', csvData.codeUnits, 'CSV');
  }

  // Fungsi untuk mengekspor data ke PDF
  static Future<void> exportToPdf(
    BuildContext context,
    List<Transaction> transactions,
  ) async {
    if (transactions.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada data untuk diekspor')),
      );
      return;
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Text(
                'Laporan Transaksi',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray( // Menggunakan pw.Table.fromTextArray untuk kemudahan
              headers: ['ID', 'Tanggal', 'Tipe', 'Status', 'Jumlah'],
              data: transactions.map((transaction) {
                return [
                  transaction.id,
                  DateFormat('dd-MM-yyyy').format(transaction.timestamp.toLocal()),
                  transaction.type,
                  transaction.status,
                  transaction.amount.toString(),
                ];
              }).toList(),
            ),
          ];
        },
      ),
    );

    final bytes = await pdf.save();
    if (!context.mounted) return;
    await _saveAndOpenFile(context, 'transactions.pdf', bytes, 'PDF');
  }

  // Helper function untuk menyimpan file dan membukanya
  static Future<void> _saveAndOpenFile(
    BuildContext context,
    String fileName,
    List<int> data,
    String fileType,
  ) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/$fileName';
      final file = File(path);
      await file.writeAsBytes(data, flush: true);

      if (!context.mounted) return;
      
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(content: Text('Data $fileType berhasil diekspor ke $path')),
      );

      final result = await OpenFile.open(path);
      if (result.type != ResultType.done) {
        debugPrint('Error opening file: ${result.message}');
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengekspor data $fileType: $e')),
      );
    }
  }

  // Fungsi untuk mendapatkan direktori penyimpanan aplikasi
  static Future<String> _getAppDirectoryPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  // Fungsi untuk menghapus semua file ekspor yang dibuat oleh layanan ini
  static Future<void> clearExportedFiles(BuildContext context) async {
    try {
      final directoryPath = await _getAppDirectoryPath();
      final directory = Directory(directoryPath);

      if (!await directory.exists()) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Direktori ekspor tidak ditemukan.')),
        );
        return;
      }

      final files = directory.listSync();
      int deletedCount = 0;

      for (var fileSystemEntity in files) {
        if (fileSystemEntity is File) {
          final fileName = fileSystemEntity.path.split('/').last;
          if (fileName.startsWith('transactions') &&
              (fileName.endsWith('.csv') || fileName.endsWith('.pdf'))) {
            await fileSystemEntity.delete();
            deletedCount++;
          }
        }
      }

      if (!context.mounted) return;
      if (deletedCount > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$deletedCount file ekspor berhasil dihapus.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak ada file ekspor yang ditemukan untuk dihapus.')),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus file ekspor: $e')),
      );
    }
    return;
  }
}

import 'dart:io';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../viewmodels/app_view_model.dart'; // For Product model

class PdfReportUtil {
  /// Generates a PDF report for low stock products, saves it, and opens it.
  static Future<String?> generateLowStockPdfReport(
    List<Product> lowStockProducts,
    Function(double) onProgress,
  ) async {
    if (kIsWeb) {
      // PDF generation on web requires a different approach (e.g., using printing package)
      // This implementation is for mobile.
      debugPrint(
        "PDF generation is not supported on web in this implementation.",
      );
      return null;
    }

    final pdf = pw.Document();
    onProgress(0.1);

    // --- Define Styles ---
    final titleStyle = pw.TextStyle(
      fontSize: 18,
      fontWeight: pw.FontWeight.bold,
    );
    final subtitleStyle = pw.TextStyle(
      fontSize: 10,
      fontStyle: pw.FontStyle.italic,
      color: PdfColors.grey700,
    );
    final headerStyle = pw.TextStyle(
      fontSize: 11,
      fontWeight: pw.FontWeight.bold,
    );
    final bodyStyle = const pw.TextStyle(fontSize: 9);
    final redBodyStyle = pw.TextStyle(
      fontSize: 9,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.red,
    );

    onProgress(0.3);

    // --- Prepare Table Data ---
    final headers = ['NAMA PRODUK', 'SKU', 'KATEGORI', 'MIN', 'STOK SAAT INI'];
    final data = lowStockProducts.map((prod) {
      return [
        prod.name,
        prod.sku.isEmpty ? '-' : prod.sku,
        prod.category,
        prod.minStockThreshold.toString(),
        prod.stock.toString(),
      ];
    }).toList();

    // Combine headers and data for manual table creation
    final List<List<String>> allRows = [headers, ...data];

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Top Banner
              pw.Container(height: 5, color: PdfColor.fromHex("#0A96B4")),
              pw.SizedBox(height: 25),

              // Header
              pw.Text('SS SELLER SPHERE', style: titleStyle),
              pw.SizedBox(height: 10),
              pw.Text(
                'LAPORAN RINGKASAN STOK MENIPIS',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Tanggal Dibuat: ${DateFormat('EEEE, dd MMMM yyyy HH:mm', 'id_ID').format(DateTime.now())}',
                style: subtitleStyle,
              ),
              pw.SizedBox(height: 15),
              pw.Divider(thickness: 1.5, color: PdfColors.black),
              pw.SizedBox(height: 15),

              // Summary Box
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex("#F0F4F8"), // light grey bg
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'RINGKASAN STATUS INVENTARIS:',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 9,
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      'Total item dalam sistem yang memerlukan restock segera: ${lowStockProducts.length} item.',
                      style: redBodyStyle,
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 25),

              // Table
              pw.Table(
                border: pw.TableBorder.all(
                  color: PdfColors.grey400,
                  width: 0.5,
                ),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(2),
                  3: const pw.FlexColumnWidth(1),
                  4: const pw.FlexColumnWidth(1.5),
                },
                children: List<pw.TableRow>.generate(
                  allRows.length,
                  (rowIndex) {
                    final row = allRows[rowIndex];
                    final isHeader = rowIndex == 0;
                    final isOddRow = rowIndex % 2 != 0;

                    return pw.TableRow(
                      decoration: isHeader
                          ? pw.BoxDecoration(color: PdfColor.fromHex("#F5F5F5"))
                          : isOddRow
                              ? pw.BoxDecoration(color: PdfColor.fromHex("#FAFCFE"))
                              : null,
                      children: List<pw.Widget>.generate(
                        row.length,
                        (colIndex) {
                          final text = row[colIndex];
                          final isLastCol = colIndex == row.length - 1;

                          return pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text(
                              text,
                              style: isHeader
                                  ? headerStyle
                                  : isLastCol
                                      ? redBodyStyle
                                      : bodyStyle,
                              textAlign: colIndex > 2
                                  ? pw.TextAlign.center
                                  : pw.TextAlign.left,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              // Footer at the bottom
              pw.Spacer(),
              pw.Divider(color: PdfColors.grey400),
              pw.SizedBox(height: 5),
              pw.Text(
                "Laporan ini dibuat otomatis oleh sistem SS Seller Sphere untuk mendukung efisiensi operasional.",
                style: subtitleStyle,
              ),
              pw.Text(
                "Dokumen Resmi Digital - Tidak memerlukan tanda tangan basah.",
                style: subtitleStyle,
              ),
            ],
          );
        },
      ),
    );
    onProgress(0.6);

    // --- Save and Open PDF ---
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filename =
          'Laporan_Stok_Menipis_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${dir.path}/$filename');
      onProgress(0.8);

      await file.writeAsBytes(await pdf.save());
      onProgress(1.0);

      // Attempt to open the file.
      // On mobile, this will usually prompt the user with a list of PDF viewers.
      // final result = await OpenFile.open(file.path);
      // debugPrint("OpenFile result: ${result.message}");

      return file.path; // Return the path for the caller to handle
    } catch (e) {
      debugPrint("Failed to save or open PDF: $e");
      return null;
    }
  }
}

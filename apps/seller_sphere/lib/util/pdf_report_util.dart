import 'dart:io';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:seller_sphere/data/dao.dart';

final logger = Logger();

class PdfReportUtil {
  static Future<File?> generateLowStockPdfReport(
    List<Product> lowStockProducts,
    void Function(double) onProgress,
  ) async {
    onProgress(0.1);
    final pdf = pw.Document();

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

    final boldBodyStyle = pw.TextStyle(
      fontSize: 9,
      fontWeight: pw.FontWeight.bold,
    );

    final redBodyStyle = pw.TextStyle(
      fontSize: 9,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.red,
    );

    onProgress(0.3);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                height: 5,
                width: double.infinity,
                color: PdfColor.fromHex("#0A96B4"),
              ),
              pw.SizedBox(height: 20),
              pw.Text('SS SELLER SPHERE', style: titleStyle),
              pw.SizedBox(height: 5),
              pw.Text(
                'LAPORAN RINGKASAN STOK MENIPIS',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Tanggal Dibuat: ${DateFormat('EEEE, dd MMMM yyyy HH:mm', 'id_ID').format(DateTime.now())}',
                style: subtitleStyle,
              ),
              pw.Divider(thickness: 1.5, color: PdfColors.black),
              pw.SizedBox(height: 15),
              pw.Container(
                padding: const pw.EdgeInsets.all(15),
                color: PdfColor.fromHex("#F0F4F8"),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('RINGKASAN STATUS INVENTARIS:',
                        style: boldBodyStyle),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Total item dalam sistem yang memerlukan restock segera: ${lowStockProducts.length} item.',
                      style: redBodyStyle,
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(2),
                  3: const pw.FlexColumnWidth(1),
                  4: const pw.FlexColumnWidth(1.5),
                },
                children: [
                  pw.TableRow(
                    decoration:
                        pw.BoxDecoration(color: PdfColor.fromHex("#F5F5F5")),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('NAMA PRODUK', style: headerStyle),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('SKU', style: headerStyle),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('KATEGORI', style: headerStyle),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('MIN', style: headerStyle),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child:
                            pw.Text('STOK SEKARANG', style: headerStyle),
                      ),
                    ],
                  ),
                  ...lowStockProducts.map(
                    (prod) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                              prod.name.length > 28
                                  ? '${prod.name.substring(0, 25)}...'
                                  : prod.name,
                              style: bodyStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(prod.sku.isEmpty ? '-' : prod.sku,
                              style: bodyStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(prod.category, style: bodyStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(prod.minStockThreshold.toString(),
                              style: bodyStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(prod.stock.toString(),
                              style: redBodyStyle),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.Spacer(),
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 5),
              pw.Text(
                'Laporan ini dibuat otomatis oleh sistem SS Seller Sphere untuk mendukung efisiensi operasional.',
                style: subtitleStyle,
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'Dokumen Resmi Digital - Tidak memerlukan tanda tangan basah.',
                style: subtitleStyle,
              ),
            ],
          );
        },
      ),
    );

    onProgress(0.6);
    try {
      final output = await getTemporaryDirectory();
      final file = File(
          '${output.path}/Laporan_Stok_Menipis_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());
      onProgress(1.0);
      return file;
    } catch (e) {
      Logger.defaultPrinter();
      return null;
    }
  }
}
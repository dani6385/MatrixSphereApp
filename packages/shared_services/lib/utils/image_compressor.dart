// lib/utils/image_compressor.dart

import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sys_paths;

/// Fungsi untuk mengompres dan memperkecil ukuran file gambar
Future<XFile?> compressAndResizeImage(File originalImageFile) async {
  try {
    // 1. Mendapatkan direktori penyimpanan sementara di perangkat
    final dir = await sys_paths.getTemporaryDirectory();
    final targetPath = path.join(
      dir.absolute.path,
      'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    // 2. Melakukan proses kompresi & resize ukuran gambar
    // minWidth dan minHeight membatasi resolusi maksimum (misal: max 1080px)
    // quality: 70 berarti kualitas diturunkan sedikit ke 70% untuk menghemat ukuran file
    final XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
      originalImageFile.absolute.path,
      targetPath,
      minWidth: 1080,
      minHeight: 1080,
      quality: 70,
      format: CompressFormat.jpeg, // Mengubah format ke JPEG agar ukuran lebih padat
    );

    // Mengembalikan file hasil kompresi
    return compressedFile;
  } catch (e) {
    // Tangani error jika kompresi gagal
    print('Gagal mengompres gambar: $e');
    return null;
  }
}
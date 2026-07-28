import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// Service untuk mengunggah gambar ke ImgBB.
class ImageUploadService {
  // API key ImgBB Anda akan ditempatkan di sini.
  // PENTING: Untuk aplikasi produksi, API key sebaiknya tidak di-hardcode
  // dan disimpan di tempat yang lebih aman (misalnya, environment variables).
  static const String _imgbbApiKey = 'f601727fed32cf7a175833d01d8a10ff';
  static const String _imgbbUploadUrl = 'https://api.imgbb.com/1/upload';

  /// Mengunggah file gambar ke ImgBB dan mengembalikan URL gambar yang diunggah.
  ///
  /// [imageFile]: File gambar yang akan diunggah.
  /// Mengembalikan URL gambar jika berhasil, atau `null` jika gagal.
  Future<String?> uploadImageToImgBB(File imageFile) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_imgbbUploadUrl));
      request.fields['key'] = _imgbbApiKey;
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decodedResponse = json.decode(responseBody);
        if (decodedResponse['success'] == true) {
          debugPrint('Gambar berhasil diunggah: ${decodedResponse['data']['url']}');
          return decodedResponse['data']['url'];
        }
      }
      debugPrint('Gagal mengunggah gambar. Status: ${response.statusCode}');
      final errorBody = await response.stream.bytesToString();
      debugPrint('Response body: $errorBody');
      return null;
    } catch (e) {
      debugPrint('Error saat mengunggah gambar ke ImgBB: $e');
      return null;
    }
  }
}
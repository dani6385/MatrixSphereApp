import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_services/constants/api_constants.dart';

/// Service untuk mengunggah gambar ke ImgBB.
class ImageUploadService {
  static const String _imgbbUploadUrl = 'https://api.imgbb.com/1/upload';

  /// Mengunggah file gambar ke ImgBB dan mengembalikan URL gambar yang diunggah.
  ///
  /// [imageFile]: File gambar yang akan diunggah.
  /// Mengembalikan URL gambar jika berhasil, atau `null` jika gagal.
  Future<String?> uploadImageToImgBB(File imageFile) async {
    try {
      // 1. Ambil API key dari konstanta terpusat.
      const apiKey = ApiConstants.imgbbApiKey;
      if (apiKey.isEmpty) {
        throw Exception(
            'IMGBB_API_KEY tidak ditemukan. Pastikan Anda menjalankan build dengan --dart-define=IMGBB_API_KEY=YOUR_KEY');
      }

      // 2. Konversi gambar ke Base64 untuk dikirim
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // 3. Buat request ke API ImgBB
      final request = http.MultipartRequest('POST', Uri.parse(_imgbbUploadUrl));
      request.fields['key'] = apiKey;
      request.fields['image'] = base64Image;

      // 4. Kirim request
      final response = await request.send();

      // 5. Proses response
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);
        // Ambil URL gambar dari response JSON
        return jsonResponse['data']['url'] as String?;
      }

      debugPrint('Gagal mengunggah gambar. Status: ${response.statusCode}');
      debugPrint('Response: ${await response.stream.bytesToString()}');
      return null;
    } catch (e) {
      debugPrint('Error saat mengunggah gambar ke ImgBB: $e');
      return null;
    }
  }
}
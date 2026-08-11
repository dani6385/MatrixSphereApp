import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// Service untuk mengunggah gambar ke ImgBB.
class ImageUploadService {
  // API key ImgBB Anda akan ditempatkan di sini.
  static const String _imgbbUploadUrl = 'https://api.imgbb.com/1/upload';

  // PERBAIKAN: Gunakan nama variabel environment untuk API key.
  static const String _imgbbApiKeyEnv = 'f601727fed32cf7a175833d01d8a10ff';

  /// Mengunggah file gambar ke ImgBB dan mengembalikan URL gambar yang diunggah.
  ///
  /// [imageFile]: File gambar yang akan diunggah.
  /// Mengembalikan URL gambar jika berhasil, atau `null` jika gagal.
  Future<String?> uploadImageToImgBB(File imageFile) async {
    try {
      // 1. Ambil API key dari environment variable.
      const apiKey = String.fromEnvironment(_imgbbApiKeyEnv);
      if (apiKey.isEmpty) {
        throw Exception(
            'IMGBB_API_KEY tidak ditemukan. Pastikan Anda menjalankannya dengan --dart-define');
      }

      // 2. Konversi gambar ke Base64 untuk dikirim
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // 3. Buat request ke API ImgBB
      final request = http.MultipartRequest('POST', Uri.parse(_imgbbUploadUrl));
      request.fields['key'] = apiKey; // Gunakan API key yang aman
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
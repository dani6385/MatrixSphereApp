import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class MikrotikService {
  // Ganti dengan IP Gateway Mikrotik Anda
  static const String baseUrl = "http://192.168.20.1/login";

  static Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'username': username,
          'password': password,
          'dst': 'http://www.google.com', // Redirect tujuan setelah login
          'popup': 'true',
        },
      ).timeout(const Duration(seconds: 5));

      // Mikrotik biasanya mengembalikan status 200 jika berhasil
      // Anda mungkin perlu mengecek isi body response untuk memastikan login berhasil
      return response.statusCode == 200;
    } catch (e) {
      final logger = Logger(
        printer: PrettyPrinter(
          methodCount: 0, // Mengurangi info detail method agar tampilan bersih
          errorMethodCount: 5, // Detail error tetap muncul
          lineLength: 80,
          colors: true,
          printEmojis: true,
        ),
      );
      logger.e('Mikrotik login error', error: e);
      return false;
    }
  }
}

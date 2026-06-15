import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class MikrotikAuth {
  final Logger _logger = Logger();
   DatabaseReference get _dbRef =>
      FirebaseDatabase.instance.ref('mikrotik_member/matrixsphere/config/mikrotik_ip');

  Future<String> getLoginUrl() async {
    final snapshot = await _dbRef.get();
    
    if (snapshot.exists) {
      String ip = snapshot.value.toString();
      return "http://$ip/login";
    }
    
    throw Exception("IP Mikrotik tidak ditemukan di rtdb.");
  }

Stream<String> getLoginUrlStream() {
    return _dbRef.onValue.map((event) {
      String ip = event.snapshot.value.toString();
      return "http://$ip/login";
    });
  }

  Future<void> doLogin(
    String username,
    String password,
    String challenge,
    String chapId,
  ) async {
    final url = await getLoginUrl();

    final response = await http.post(Uri.parse(url), body: {
      'username': username,
      'password': password,
      'challenge': challenge,
      'chap-id': chapId,
    });

    _logger.i('Login response status: ${response.statusCode}');
  }
}


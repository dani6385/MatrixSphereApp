import 'dart:async';
import 'package:logger/logger.dart';

// Placeholder class for RouterOS API interaction. 
// This is created to resolve the build error, but in a real app, 
// this should come from the 'routeros_api' package.
class RouterOSAPI {
  RouterOSAPI._(); // Private constructor
  static final Logger _logger = Logger();

  // Static method to simulate a connection
  static Future<RouterOSAPI> connect({
    required String host, 
    required String user, 
    required String pass
  }) async {
    _logger.d('Connecting to $host with user $user...');
    await Future.delayed(const Duration(milliseconds: 100)); // Simulate network delay
    _logger.d('Connection successful.');
    return RouterOSAPI._();
  }

  // Method to simulate an API command call
  Future<List<Map<String, dynamic>>> call(String command, {List<String>? queries}) async {
    _logger.d('Executing command: $command');
    // If the command is to get active users, return mock data
    if (command == '/ip/hotspot/active/print') {
      return [
        {
          'server': 'hotspot1',
          'user': 'testuser', // The user we are looking for
          'address': '192.168.30.111',
          'mac-address': 'AA:BB:CC:DD:EE:FF',
          'uptime': '1d 0h 5m 10s',
          'bytes-in': '1500000', // ~1.5 MB
          'bytes-out': '25000000', // ~25 MB
          'limit-bytes-total': '1073741824', // 1 GB
        }
      ];
    }
    return [];
  }

  // Method to close the connection
  void close() {
    _logger.d('Connection closed.');
  }
}


// A simple data class to hold user data from the hotspot
class HotspotActiveUser {
  final String server;
  final String user;
  final String address;
  final String macAddress;
  final String uptime;
  final String bytesIn;
  final String bytesOut;
  final String limitBytesTotal;

  HotspotActiveUser.fromMap(Map<String, dynamic> map)
    : server = map['server'] ?? '',
      user = map['user'] ?? '',
      address = map['address'] ?? '',
      macAddress = map['mac-address'] ?? '',
      uptime = map['uptime'] ?? '0s',
      bytesIn = map['bytes-in'] ?? '0',
      bytesOut = map['bytes-out'] ?? '0',
      limitBytesTotal = map['limit-bytes-total'] ?? '0';

  // Helper to format bytes into a readable string (MB/GB)
  static String formatBytes(String bytesStr) {
    final bytes = double.tryParse(bytesStr) ?? 0;
    if (bytes == 0) return '0 B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}

class MikroTikService {
  RouterOSAPI? _api;
  bool _isConnected = false;
  final Logger _logger = Logger();

  // --- CONNECTION DETAILS - Replace with your actual credentials ---
  final String _host = '192.168.30.1'; // Or your router's IP
  final String _user = 'user1234';
  final String _pass = 'user1234';

  bool get isConnected => _isConnected;

  Future<void> connect() async {
    try {
      _api = await RouterOSAPI.connect(host: _host, user: _user, pass: _pass);
      _isConnected = true;
      _logger.d('Successfully connected to MikroTik router.');
    } catch (e) {
      _logger.e('Error connecting to MikroTik: $e');
      _isConnected = false;
      // Rethrow the exception to be handled by the UI
      rethrow;
    }
  }

  Future<HotspotActiveUser?> getActiveUserStats({
    required String username,
  }) async {
    if (!_isConnected || _api == null) {
      throw Exception('Not connected to the router. Call connect() first.');
    }

    try {
      // Fetch the list of active hotspot users
      final response = await _api!.call(
        '/ip/hotspot/active/print',
        queries: [
          '.proplist=server,user,address,mac-address,uptime,bytes-in,bytes-out,limit-bytes-total',
        ],
      );

      // Find the specific user from the list
      final userMap = response.cast<Map<String, dynamic>>().firstWhere(
        (map) => map['user'] == username,
        orElse: () => <String, dynamic>{}, // Return empty map if not found
      );

      if (userMap.isNotEmpty) {
        return HotspotActiveUser.fromMap(userMap);
      }
      return null; // User not found
    } catch (e) {
      _logger.e('Error fetching active user stats: $e');
      rethrow;
    }
  }

  void disconnect() {
    _api?.close();
    _isConnected = false;
    _logger.d('Disconnected from MikroTik router.');
  }
}

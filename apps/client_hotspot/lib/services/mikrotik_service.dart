import 'dart:async';
import 'dart:math';
import 'package:logger/logger.dart';

// Placeholder class for RouterOS API interaction.
class RouterOSAPI {
  RouterOSAPI._(); // Private constructor
  static final Logger _logger = Logger();

  static Future<RouterOSAPI> connect(
      {required String host, required String user, required String pass}) async {
    _logger.d('Connecting to $host with user $user...');
    await Future.delayed(const Duration(milliseconds: 100));
    _logger.d('Connection successful.');
    return RouterOSAPI._();
  }

  Future<List<Map<String, dynamic>>> call(String command,
      {List<String>? queries}) async {
    _logger.d('Executing command: $command with queries: $queries');

    if (command == '/ip/hotspot/active/print') {
      return [
        {
          'user': 'user1234',
          'mac-address': 'AA:BB:CC:DD:EE:FF',
          'uptime': '3h 45m',
          'limit-bytes-total': '10737418240',
          'bytes-in': '1825361100',
          'bytes-out': '2040109465',
          'session-time-left': '5d 12h',
          'comment': 'monthly-usage:25.3 GB;current-speed:50 Mbps / 10 Mbps'
        }
      ];
    } else if (command == '/interface/wireless/registration-table/print') {
      return [
        {
          'mac-address': 'AA:BB:CC:DD:EE:FF',
          'interface': 'wlan-hotspot-1',
          'signal-strength': '-58dBm@6Mbps',
          'tx-rate': '54Mbps',
        },
      ];
    } else if (command == '/interface/wireless/print') {
        return [
            { 'ssid': 'MyAwesomeHotspot' }
        ];
    } else if (command == '/interface/wireless/scan') {
      return [
        {'ssid': 'MyHome-5G', 'address': '00:11:22:AA:BB:CC', 'signal-strength': '-55'},
        {'ssid': 'Neighbor-WiFi', 'address': 'DD:EE:FF:00:11:22', 'signal-strength': '-78'},
      ];
    }
    return [];
  }

  void close() { _logger.d('Connection closed.'); }
}

class HotspotActiveUser {
  final String user, uptime, bytesIn, bytesOut, limitBytesTotal, sessionTimeLeft, monthlyUsage, currentSpeed, macAddress, signalStrength, ssid;

  HotspotActiveUser.fromMap(Map<String, dynamic> map)
      : user = map['user'] ?? '',
        uptime = map['uptime'] ?? '0s',
        bytesIn = map['bytes-in'] ?? '0',
        bytesOut = map['bytes-out'] ?? '0',
        limitBytesTotal = map['limit-bytes-total'] ?? '0',
        sessionTimeLeft = map['session-time-left'] ?? 'N/A',
        monthlyUsage = _parseComment(map['comment'], 'monthly-usage'),
        currentSpeed = _parseComment(map['comment'], 'current-speed'),
        macAddress = map['mac-address'] ?? '',
        signalStrength = map['signal-strength'] ?? 'N/A',
        ssid = map['ssid'] ?? 'N/A';
        
  int get totalBytesUsed {
    return (int.tryParse(bytesIn) ?? 0) + (int.tryParse(bytesOut) ?? 0);
  }

  int get remainingBytes {
    final limit = int.tryParse(limitBytesTotal) ?? 0;
    if (limit == 0) return 0;
    final used = totalBytesUsed;
    return limit > used ? limit - used : 0;
  }

  static String _parseComment(String? comment, String key) {
    if (comment == null) return 'N/A';
    try {
      final parts = comment.split(';');
      for (var part in parts) {
        final kv = part.split(':');
        if (kv.length == 2 && kv[0].trim() == key) {
          return kv[1].trim();
        }
      }
    } catch (e) { return 'N/A'; }
    return 'N/A';
  }
  
  static String formatBytes(String bytesStr, {int decimals = 2}) {
    final bytes = int.tryParse(bytesStr);
    if (bytes == null || bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
   }
}

class WifiNetwork {
  final String ssid;
  final String address;
  final String signalStrength;

  WifiNetwork.fromMap(Map<String, dynamic> map)
      : ssid = map['ssid'] ?? '',
        address = map['address'] ?? '',
        signalStrength = map['signal-strength'] ?? '-100';
}

class MikroTikService {
  RouterOSAPI? _api;
  bool _isConnected = false;
  final Logger _logger = Logger();

  final String _host = '192.168.30.1';
  final String _user = 'user1234';
  final String _pass = 'user1234';

  bool get isConnected => _isConnected;

  Future<void> connect() async {
    try {
      _api = await RouterOSAPI.connect(host: _host, user: _user, pass: _pass);
      _isConnected = true;
    } catch (e) {
      _isConnected = false;
      rethrow;
    }
  }

  Future<HotspotActiveUser?> getActiveUserStats({required String username}) async {
    if (!_isConnected || _api == null) throw Exception('Not connected.');
    try {
      final userResponse = await _api!.call(
        '/ip/hotspot/active/print',
        queries: ['.proplist=user,mac-address,uptime,bytes-in,bytes-out,limit-bytes-total,session-time-left,comment','?user=$username'],
      );
      if (userResponse.isEmpty) return null;

      final userMap = userResponse.first;
      final macAddress = userMap['mac-address'];

      if (macAddress != null) {
        final regResponse = await _api!.call(
          '/interface/wireless/registration-table/print',
          queries: ['.proplist=signal-strength,interface', '?mac-address=$macAddress'],
        );
        if (regResponse.isNotEmpty) {
          final regMap = regResponse.first;
          userMap['signal-strength'] = regMap['signal-strength'];
          final interface = regMap['interface'];

          if (interface != null) {
            final interfaceResponse = await _api!.call(
              '/interface/wireless/print',
              queries: ['.proplist=ssid', '?name=$interface'],
            );
            if (interfaceResponse.isNotEmpty) {
              userMap['ssid'] = interfaceResponse.first['ssid'];
            }
          }
        }
      }
      return HotspotActiveUser.fromMap(userMap);
    } catch (e) {
      _logger.e('Error fetching user stats: $e');
      rethrow;
    }
  }

  Future<List<WifiNetwork>> scanWifiNetworks({String interface = 'wlan1'}) async {
    if (!_isConnected || _api == null) throw Exception('Not connected.');
    try {
      final response = await _api!.call(
        '/interface/wireless/scan',
        queries: ['.proplist=ssid,address,signal-strength', '?interface=$interface'],
      );
      return response.map((net) => WifiNetwork.fromMap(net)).toList();
    } catch (e) {
      _logger.e('Error scanning wifi networks: $e');
      rethrow;
    }
  }

  Future<void> connectToWifi(String ssid) async {
    await Future.delayed(const Duration(seconds: 2));
    _logger.d('Attempting to connect to $ssid');
  }

  void disconnect() { _api?.close(); _isConnected = false; }
}

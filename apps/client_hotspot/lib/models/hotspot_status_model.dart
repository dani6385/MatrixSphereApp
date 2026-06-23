
// Model untuk merepresentasikan data dari halaman status hotspot Mikrotik
class HotspotStatus {
  final String username;
  final String? profile; // Nama paket/profil voucher
  final String ipAddress;
  final String macAddress;
  final DateTime sessionStartTime; // Kapan sesi dimulai
  final double bytesUp; // Data upload dalam bytes
  final double bytesDown; // Data download dalam bytes

  HotspotStatus({
    required this.username,
    this.profile,
    required this.ipAddress,
    required this.macAddress,
    required this.sessionStartTime,
    required this.bytesUp,
    required this.bytesDown,
  });

  // --- Getters untuk mempermudah tampilan di UI ---

  // Menghitung durasi sesi berjalan (uptime)
  Duration get uptime => DateTime.now().difference(sessionStartTime);

  // Helper untuk format bytes menjadi string yang mudah dibaca (KB, MB, GB)
  static String formatBytes(double bytes, [int decimals = 2]) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (bytes == 0) ? 0 : ( (bytes > 0 ? bytes : -bytes).floor() & 0x3FF) > 0 ? 1 : 0;
    while(i < suffixes.length -1 && bytes >= 1024){
      bytes /= 1024;
      i++;
    }
    return '${bytes.toStringAsFixed(decimals)} ${suffixes[i]}';
  }
  
  String get bytesUpFormatted => formatBytes(bytesUp);
  String get bytesDownFormatted => formatBytes(bytesDown);

  // --- Factory & Map Methods (Simulasi) ---

  // Simulasi data dari Mikrotik API/RTDB
  factory HotspotStatus.fromMap(Map<String, dynamic> map) {
    return HotspotStatus(
      username: map['username'] ?? 'N/A',
      profile: map['profile'],
      ipAddress: map['ipAddress'] ?? 'N/A',
      macAddress: map['macAddress'] ?? 'N/A',
      // Timestamp dari RTDB biasanya int
      sessionStartTime: DateTime.fromMillisecondsSinceEpoch((map['sessionStartTime'] ?? 0) as int),
      bytesUp: (map['bytesUp'] ?? 0.0).toDouble(),
      bytesDown: (map['bytesDown'] ?? 0.0).toDouble(),
    );
  }

  // Contoh data untuk simulasi
  static HotspotStatus get mockData {
     return HotspotStatus(
      username: 'user_123',
      profile: 'Paket Gaming 50GB',
      ipAddress: '192.168.88.112',
      macAddress: 'AA:BB:CC:DD:EE:FF',
      sessionStartTime: DateTime.now().subtract(const Duration(hours: 1, minutes: 25)),
      bytesUp: 150 * 1024 * 1024, // 150 MB
      bytesDown: 1.2 * 1024 * 1024 * 1024, // 1.2 GB
    );
  }
}

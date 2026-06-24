class HotspotStatus {
  final String username;
  final String ipAddress;
  final String macAddress;
  final int sessionStartTime; // Simpan sebagai Unix timestamp (milidetik)
  final int bytesUp;
  final int bytesDown;

  HotspotStatus({
    required this.username,
    required this.ipAddress,
    required this.macAddress,
    required this.sessionStartTime,
    required this.bytesUp,
    required this.bytesDown,
  });

  factory HotspotStatus.fromMap(Map<String, dynamic> map) {
    return HotspotStatus(
      username: map['username'] ?? 'N/A',
      ipAddress: map['ipAddress'] ?? 'N/A',
      macAddress: map['macAddress'] ?? 'N/A',
      sessionStartTime: (map['sessionStartTime'] is int) ? map['sessionStartTime'] : 0,
      bytesUp: (map['bytesUp'] is int) ? map['bytesUp'] : 0,
      bytesDown: (map['bytesDown'] is int) ? map['bytesDown'] : 0,
    );
  }

  factory HotspotStatus.defaultStatus({String ipAddress = 'N/A', String message = 'Tidak ada data'}) {
    return HotspotStatus(
      username: 'N/A',
      ipAddress: ipAddress,
      macAddress: message,
      sessionStartTime: 0,
      bytesUp: 0,
      bytesDown: 0,
    );
  }

  DateTime get sessionStartDateTime => DateTime.fromMillisecondsSinceEpoch(sessionStartTime);

  String get sessionDuration {
    if (sessionStartTime == 0) return "00:00:00";
    final duration = DateTime.now().difference(sessionStartDateTime);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  String get formattedBytesUp {
    if (bytesUp < 1024) return '$bytesUp B'; // PERBAIKAN: Menghapus kurung kurawal
    if (bytesUp < 1024 * 1024) return '${(bytesUp / 1024).toStringAsFixed(2)} KB';
    if (bytesUp < 1024 * 1024 * 1024) return '${(bytesUp / (1024 * 1024)).toStringAsFixed(2)} MB';
    return '${(bytesUp / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  String get formattedBytesDown {
    if (bytesDown < 1024) return '$bytesDown B'; // PERBAIKAN: Menghapus kurung kurawal
    if (bytesDown < 1024 * 1024) return '${(bytesDown / 1024).toStringAsFixed(2)} KB';
    if (bytesDown < 1024 * 1024 * 1024) return '${(bytesDown / (1024 * 1024)).toStringAsFixed(2)} MB';
    return '${(bytesDown / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}

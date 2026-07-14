/// Versi web dari SystemResource yang tidak mengimpor dart:io.
class SystemResource {
  final String uptime;
  final String version;
  final String boardName;
  final String? ipAddress;
  final String? macAddress;

  // ... (sisa properti simulasi)
  final String serialNumber;
  final String username;
  final String packageName;
  final double quotaUsedPercent;
  final int quotaUsedMB;
  final int quotaTotalMB;
  final String expiresAt;
  final double simulatedTx;
  final double simulatedRx;

  SystemResource({
    required this.uptime,
    required this.version,
    required this.boardName,
    this.ipAddress,
    this.macAddress,
    required this.serialNumber,
    required this.username,
    required this.packageName,
    required this.quotaUsedPercent,
    required this.quotaUsedMB,
    required this.quotaTotalMB,
    required this.expiresAt,
    required this.simulatedTx,
    required this.simulatedRx,
  });

  factory SystemResource.fromJson(Map<String, dynamic> json) {
    return SystemResource(
      uptime: json['uptime'] ?? 'N/A',
      version: json['version'] ?? 'N/A',
      boardName: json['board-name'] ?? 'N/A',
      ipAddress: json['ip-address'],
      macAddress: json['mac-address'],
      serialNumber: json['serial-number'] ?? 'N/A',
      username: json['username'] ?? 'N/A',
      packageName: json['package-name'] ?? 'N/A',
      quotaUsedPercent: (json['quota-used-percent'] as num?)?.toDouble() ?? 0.0,
      quotaUsedMB: (json['quota-used-mb'] as num?)?.toInt() ?? 0,
      quotaTotalMB: (json['quota-total-mb'] as num?)?.toInt() ?? 0,
      expiresAt: json['expires-at'] ?? 'N/A',
      simulatedTx: (json['simulated-tx'] as num?)?.toDouble() ?? 0.0,
      simulatedRx: (json['simulated-rx'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

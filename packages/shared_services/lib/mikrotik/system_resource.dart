import 'package:equatable/equatable.dart';

/// Model data yang kuat untuk merepresentasikan respons dari endpoint
/// `/rest/system/resource` dari MikroTik, dengan tambahan data simulasi.
class SystemResource extends Equatable {
  final String ipAddress;
  final String macAddress;
  final String uptime;
  final String version;
  final String boardName;
  final String serialNumber;
  final String username;
  final String packageName;
  final double quotaUsedPercent;
  final int quotaUsedMb;
  final int quotaTotalMb;
  final String expiresAt;
  final double simulatedTx;
  final double simulatedRx;

  const SystemResource({
    required this.ipAddress,
    required this.macAddress,
    required this.uptime,
    required this.version,
    required this.boardName,
    required this.serialNumber,
    required this.username,
    required this.packageName,
    required this.quotaUsedPercent,
    required this.quotaUsedMb,
    required this.quotaTotalMb,
    required this.expiresAt,
    required this.simulatedTx,
    required this.simulatedRx,
  });

  /// Factory constructor untuk membuat instance [SystemResource] dari JSON map.
  factory SystemResource.fromJson(Map<String, dynamic> json) {
    return SystemResource(
      ipAddress: json['ip-address'] as String? ?? 'N/A',
      macAddress: json['mac-address'] as String? ?? 'N/A',
      uptime: json['uptime'] as String? ?? 'N/A',
      version: json['version'] as String? ?? 'N/A',
      boardName: json['board-name'] as String? ?? 'N/A',
      serialNumber: json['serial-number'] as String? ?? 'N/A',
      username: json['username'] as String? ?? 'N/A',
      packageName: json['package-name'] as String? ?? 'N/A',
      quotaUsedPercent: (json['quota-used-percent'] as num? ?? 0).toDouble(),
      quotaUsedMb: json['quota-used-mb'] as int? ?? 0,
      quotaTotalMb: json['quota-total-mb'] as int? ?? 0,
      expiresAt: json['expires-at'] as String? ?? 'N/A',
      simulatedTx: (json['simulated-tx'] as num? ?? 0).toDouble(),
      simulatedRx: (json['simulated-rx'] as num? ?? 0).toDouble(),
    );
  }

  /// Mengonversi instance [SystemResource] menjadi JSON map.
  Map<String, dynamic> toJson() {
    return {
      'ip-address': ipAddress,
      'mac-address': macAddress,
      'uptime': uptime,
      'version': version,
      'board-name': boardName,
      'serial-number': serialNumber,
      'username': username,
      'package-name': packageName,
      'quota-used-percent': quotaUsedPercent,
      'quota-used-mb': quotaUsedMb,
      'quota-total-mb': quotaTotalMb,
      'expires-at': expiresAt,
      'simulated-tx': simulatedTx,
      'simulated-rx': simulatedRx,
    };
  }

  @override
  List<Object?> get props => [
        ipAddress,
        macAddress,
        uptime,
        version,
        boardName,
        serialNumber,
        username,
        packageName,
        quotaUsedPercent,
        quotaUsedMb,
        quotaTotalMb,
        expiresAt,
        simulatedTx,
        simulatedRx,
      ];
}
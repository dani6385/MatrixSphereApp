/// Model untuk menampung data sesi pengguna yang sedang aktif.
class SessionData {
  final String username;
  final String packageName;
  final double quotaUsedPercent;
  final int quotaUsedMB;
  final int quotaTotalMB;
  final String uptime;
  final String sessionTime;
  final double downloadSpeed;
  final double uploadSpeed;
  final String ipAddress;
  final String macAddress;
  final String ssid;
  final String expiresAt;

  const SessionData({
    required this.username,
    required this.packageName,
    required this.quotaUsedPercent,
    required this.quotaUsedMB,
    required this.quotaTotalMB,
    required this.uptime,
    required this.sessionTime,
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.ipAddress,
    required this.macAddress,
    required this.ssid,
    required this.expiresAt,
  });
}

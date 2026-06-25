import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../main.dart'; // Impor ThemeProvider
import '../providers/device_provider.dart'; // Menggunakan relative path yang benar

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _statTimer;
  int _tickCount = 0;

  // Router States
  bool _isConnected = true;
  bool _isRebooting = false;
  int _rebootCountdown = 5;
  String _connectionStatus = 'Connected';

  // System Resources Stats
  double _cpuUsage = 14.0;
  double _ramUsage = 482.0; // MB
  final double _ramMax = 1024.0; // MB
  final double _diskUsage = 24.8; // GB
  final double _diskMax = 64.0; // GB
  double _cpuTemp = 42.5; // °C

  // Traffic Stats
  List<FlSpot> _txSpots = []; // Upload
  List<FlSpot> _rxSpots = []; // Download

  // Log Terminal Stats
  List<Map<String, dynamic>> _logs = [];
  bool _isAutoScrollEnabled = true;
  bool _isLogPaused = false;
  final ScrollController _logScrollController = ScrollController();

  // Dialog & Tool States
  bool _isPingRunning = false;
  List<String> _pingOutputs = [];
  Timer? _pingTimer;

  bool _isSpeedTestRunning = false;
  double _speedTestProgress = 0.0;
  double _speedTestDownload = 0.0;
  double _speedTestUpload = 0.0;
  String _speedTestPhase =
      'Idle'; // Idle, Testing Download, Testing Upload, Finished

  @override
  void initState() {
    super.initState();

    // Pulse Animation untuk Indikator Koneksi
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Inisialisasi data grafik awal (15 titik)
    for (int i = 0; i < 15; i++) {
      _txSpots.add(
        FlSpot(
          i.toDouble(),
          1.0 + (i % 3) * 0.4 + math.Random().nextDouble() * 0.5,
        ),
      );
      _rxSpots.add(
        FlSpot(
          i.toDouble(),
          3.0 + (i % 4) * 0.7 + math.Random().nextDouble() * 1.2,
        ),
      );
    }

    // Inisialisasi Log Awal
    _logs = [
      {
        'time': '17:35:10',
        'type': 'system,info',
        'msg': 'RouterOS v7.12 boot completed successfully',
      },
      {
        'time': '17:35:14',
        'type': 'interface,info',
        'msg': 'ether1-wan link up (speed 1Gbps, full duplex)',
      },
      {
        'time': '17:35:15',
        'type': 'interface,info',
        'msg': 'bridge-lan link up (speed 1Gbps)',
      },
      {
        'time': '17:36:20',
        'type': 'dhcp,info',
        'msg': 'dhcp_server1 assigned 192.168.88.254 to 00:0C:29:E4:12:F1',
      },
      {
        'time': '17:37:05',
        'type': 'hotspot,info,debug',
        'msg': 'dani (192.168.88.254): logging in...',
      },
      {
        'time': '17:37:07',
        'type': 'hotspot,info',
        'msg':
            'dani (192.168.88.254): logged in, ip 192.168.88.254, mac 00:0C:29:E4:12:F1',
      },
      {
        'time': '17:38:00',
        'type': 'system,info,account',
        'msg': 'user admin logged in via WinBox from 192.168.88.100',
      },
      {
        'time': '17:42:15',
        'type': 'firewall,info',
        'msg':
            'rule forward drop: in:ether1-wan out:bridge-lan, proto TCP, 198.51.100.42:443->192.168.88.254:58210',
      },
    ];

    // Mulai generator data berkala
    _startLocalSimulatedData();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _statTimer?.cancel();
    _pingTimer?.cancel();
    _logScrollController.dispose();
    super.dispose();
  }

  // Timer ini sekarang hanya untuk data yang belum ada di provider (CPU, RAM, dll)
  void _startLocalSimulatedData() {
    final deviceProvider = Provider.of<DeviceProvider>(context, listen: false);

    _statTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_isRebooting || !_isConnected) return;
      setState(() {
        _tickCount++;

        // Simulasikan Fluktuasi CPU (Base 8-30% dengan sesekali spike)
        double targetCpu =
            8.0 + (22.0 * (0.5 + 0.5 * math.sin(_tickCount * 0.15)));
        if (_tickCount % 13 == 0) {
          targetCpu += 45.0; // Network spike
        }
        _cpuUsage = double.parse(
          (targetCpu + math.Random().nextDouble() * 3).toStringAsFixed(1),
        );
        if (_cpuUsage > 100.0) _cpuUsage = 98.5;

        // Simulasikan RAM (Sekitar 480-495 MB)
        _ramUsage = double.parse(
          (480.0 +
                  (12.0 * math.sin(_tickCount * 0.08)) +
                  math.Random().nextDouble() * 2)
              .toStringAsFixed(1),
        );

        // Simulasikan CPU Temp (Sekitar 41.5 - 43.5 °C)
        _cpuTemp = double.parse(
          (42.0 +
                  (1.2 * math.cos(_tickCount * 0.05)) +
                  math.Random().nextDouble() * 0.3)
              .toStringAsFixed(1),
        );

        // Data traffic (hanya untuk grafik, angka diambil dari provider)
        final deviceInfo = deviceProvider.deviceInfo;
        // Geser data grafik ke kiri
        _txSpots.removeAt(0);
        _rxSpots.removeAt(0);

        for (int i = 0; i < _txSpots.length; i++) {
          _txSpots[i] = FlSpot(i.toDouble(), _txSpots[i].y); // Keep old spots
          _rxSpots[i] = FlSpot(i.toDouble(), _rxSpots[i].y); // Keep old spots
        }

        _txSpots.add(FlSpot(14.0, deviceInfo?.tx ?? 0.0));
        _rxSpots.add(FlSpot(14.0, deviceInfo?.rx ?? 0.0));

        // Tambah log baru secara acak setiap beberapa detik
        if (_tickCount % 6 == 0 && !_isLogPaused) {
          _generateRandomLog();
        }
      });
    });
  }

  void _generateRandomLog() {
    final now = DateTime.now();
    final timeStr =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

    final List<Map<String, dynamic>> logTemplates = [
      {
        'type': 'dhcp,info',
        'msg':
            'dhcp_server1 assigned 192.168.88.${math.Random().nextInt(150) + 10} to ${_randomMac()}',
      },
      {
        'type': 'hotspot,info',
        'msg':
            'user_active_${math.Random().nextInt(15) + 1} (192.168.88.220): logged in',
      },
      {
        'type': 'hotspot,info,debug',
        'msg':
            'user_active_${math.Random().nextInt(15) + 1}: keepalive timeout, logging out',
      },
      {
        'type': 'system,info,account',
        'msg': 'user admin checked system resources via WebFig',
      },
      {
        'type': 'firewall,info',
        'msg':
            'rule forward drop: in:ether1-wan out:bridge-lan, proto UDP, 8.8.8.8:53->192.168.88.210:50130',
      },
      {
        'type': 'wireless,info',
        'msg':
            'cap-wlan1: client ${_randomMac()} associated, signal strength -71dBm',
      },
      {
        'type': 'critical,error',
        'msg': 'dns dynamic update failed: connection timeout',
      },
      {
        'type': 'system,info',
        'msg': 'ntp status: synchronized to pool.ntp.org',
      },
    ];

    final selected = logTemplates[math.Random().nextInt(logTemplates.length)];
    setState(() {
      _logs.add({
        'time': timeStr,
        'type': selected['type'],
        'msg': selected['msg'],
      });

      if (_logs.length > 60) {
        _logs.removeAt(0);
      }
    });

    // Auto-scroll ke log terbawah
    if (_isAutoScrollEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_logScrollController.hasClients) {
          _logScrollController.animateTo(
            _logScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  String _randomMac() {
    final rand = math.Random();
    return "00:0C:29:${rand.nextInt(90) + 10}:${rand.nextInt(90) + 10}:${rand.nextInt(90) + 10}";
  }

  String _formatUptime(int totalSeconds) {
    int days = totalSeconds ~/ (24 * 3600);
    int hours = (totalSeconds % (24 * 3600)) ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    String daysStr = days > 0 ? '${days}d ' : '';
    return '$daysStr${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // --- LOGIKA SIMULASI REBOOT ---
  void _simulateReboot() {
    setState(() {
      _isRebooting = true;
      _connectionStatus = 'Rebooting';
      _rebootCountdown = 5;
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _rebootCountdown--;
      });

      if (_rebootCountdown <= 0) {
        timer.cancel();
        // Selesai reboot, ubah ke status menghubungkan kembali
        setState(() {
          _connectionStatus = 'Connecting';
          _cpuUsage = 0.0;
          _ramUsage = 0.0;
        });

        // 2 detik kemudian terhubung
        Timer(const Duration(seconds: 2), () {
          if (!mounted) return;
          setState(() {
            _isRebooting = false;
            _isConnected = true;
            _connectionStatus = 'Connected';
            // Uptime akan di-reset oleh provider
            _cpuUsage = 15.0;
            _ramUsage = 478.0;

            // Tambahkan log sistem reboot
            final now = DateTime.now();
            final timeStr =
                "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
            _logs.add({
              'time': timeStr,
              'type': 'system,info',
              'msg': 'Router rebooted by admin request. Starting services...',
            });
            _logs.add({
              'time': timeStr,
              'type': 'interface,info',
              'msg': 'ether1-wan link up (speed 1Gbps, full duplex)',
            });
          });
        });
      }
    });
  }

  // --- DIALOGS & SHEET PANDEL ---
  void _showInterfacesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Interfaces List (WinBox Mode)',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  children: [
                    _buildInterfaceTile(
                      'ether1-wan',
                      'WAN - Connected',
                      '1 Gbps',
                      true,
                      Provider.of<DeviceProvider>(context, listen: false).deviceInfo?.rx ?? 0.0,
                      Provider.of<DeviceProvider>(context, listen: false).deviceInfo?.tx ?? 0.0,
                      isDark,
                    ),
                    _buildInterfaceTile(
                      'bridge-lan',
                      'LAN - Local Bridge',
                      '1 Gbps',
                      true,
                      (Provider.of<DeviceProvider>(context, listen: false).deviceInfo?.tx ?? 0.0) * 0.9,
                      (Provider.of<DeviceProvider>(context, listen: false).deviceInfo?.rx ?? 0.0) * 0.9,
                      isDark,
                    ),
                    _buildInterfaceTile(
                      'cap-wlan1',
                      'Wireless 2.4GHz',
                      '300 Mbps',
                      true,
                      0.4,
                      1.2,
                      isDark,
                    ),
                    _buildInterfaceTile(
                      'cap-wlan2',
                      'Wireless 5GHz',
                      '867 Mbps',
                      true,
                      1.5,
                      3.4,
                      isDark,
                    ),
                    _buildInterfaceTile(
                      'ether2-local',
                      'Disabled Port',
                      'Down',
                      false,
                      0.0,
                      0.0,
                      isDark,
                    ),
                    _buildInterfaceTile(
                      'ether3-local',
                      'Unplugged Port',
                      'Down',
                      false,
                      0.0,
                      0.0,
                      isDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInterfaceTile(
    String name,
    String desc,
    String speed,
    bool isUp,
    double rxMbps,
    double txMbps,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: Row(
        children: [
          Icon(
            isUp ? Icons.settings_ethernet : Icons.dangerous,
            color: isUp ? const Color(0xFF0EA5E9) : Colors.red,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  desc,
                  style: GoogleFonts.openSans(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isUp
                      ? const Color(0xFF10B981).withAlpha(51) // 0.2 * 255
                      : Colors.red.withAlpha(51), // 0.2 * 255
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isUp ? 'Running' : 'Down',
                  style: GoogleFonts.roboto(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isUp ? const Color(0xFF10B981) : Colors.red,
                  ),
                ),
              ),
              if (isUp) ...[
                const SizedBox(height: 6),
                Text(
                  'Rx: ${rxMbps.toStringAsFixed(1)} Mbps',
                  style: GoogleFonts.shareTechMono(
                    fontSize: 10,
                    color: const Color(0xFFF97316),
                  ),
                ),
                Text(
                  'Tx: ${txMbps.toStringAsFixed(1)} Mbps',
                  style: GoogleFonts.shareTechMono(
                    fontSize: 10,
                    color: const Color(0xFF0EA5E9),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _showIpServicesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'IP Services Control',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  children: [
                    _buildServiceRow('api', 8728, true, isDark),
                    _buildServiceRow('api-ssl', 8729, false, isDark),
                    _buildServiceRow('ftp', 21, false, isDark),
                    _buildServiceRow('ssh', 22, true, isDark),
                    _buildServiceRow('telnet', 23, false, isDark),
                    _buildServiceRow('winbox', 8291, true, isDark),
                    _buildServiceRow('www (WebFig)', 80, true, isDark),
                    _buildServiceRow('www-ssl', 443, true, isDark),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceRow(String name, int port, bool enabled, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.dns,
                color: enabled ? const Color(0xFF10B981) : Colors.grey,
                size: 22,
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Port: $port',
                    style: GoogleFonts.shareTechMono(
                      fontSize: 12,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Switch(
            value: enabled,
            activeThumbColor: const Color(0xFF10B981),
            onChanged: (val) {
              // Simulasi toggle
              setState(() {
                final now = DateTime.now();
                final timeStr =
                    "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
                _logs.add({
                  'time': timeStr,
                  'type': 'system,info',
                  'msg':
                      'service $name ${val ? 'enabled' : 'disabled'} by admin',
                });
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Service $name ${val ? 'Enabled' : 'Disabled'}',
                  ),
                  backgroundColor: val ? const Color(0xFF10B981) : Colors.red,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showHotspotUsersSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Active Hotspot Users (WinBox Active)',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  children: [
                    _buildHotspotUserRow(
                      'dani',
                      '192.168.88.254',
                      '00:0C:29:E4:12:F1',
                      '01:24:12',
                      '124.5 MB',
                      '342.1 MB',
                      isDark,
                    ),
                    _buildHotspotUserRow(
                      'budi_gaming',
                      '192.168.88.240',
                      'BC:D1:D3:5F:AA:02',
                      '00:45:10',
                      '45.1 MB',
                      '789.0 MB',
                      isDark,
                    ),
                    _buildHotspotUserRow(
                      'lisa_work',
                      '192.168.88.221',
                      '70:F1:A1:C3:99:9F',
                      '03:12:55',
                      '389.2 MB',
                      '145.7 MB',
                      isDark,
                    ),
                    _buildHotspotUserRow(
                      'guest_room2',
                      '192.168.88.210',
                      'A0:B1:C2:D3:E4:F5',
                      '00:15:30',
                      '12.0 MB',
                      '18.4 MB',
                      isDark,
                    ),
                    _buildHotspotUserRow(
                      'rachel_m',
                      '192.168.88.201',
                      '32:88:E2:0F:7D:C1',
                      '02:08:44',
                      '94.2 MB',
                      '241.9 MB',
                      isDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHotspotUserRow(
    String user,
    String ip,
    String mac,
    String uptime,
    String tx,
    String rx,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.person, color: Color(0xFF10B981), size: 18),
                  const SizedBox(width: 8),
                  Text(
                    user,
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Text(
                uptime,
                style: GoogleFonts.shareTechMono(
                  fontSize: 12,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'IP: $ip',
                    style: GoogleFonts.shareTechMono(
                      fontSize: 11,
                      color: isDark ? Colors.white38 : Colors.black45,
                    ),
                  ),
                  Text(
                    'MAC: $mac',
                    style: GoogleFonts.shareTechMono(
                      fontSize: 11,
                      color: isDark ? Colors.white38 : Colors.black45,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Upload: $tx',
                        style: GoogleFonts.shareTechMono(
                          fontSize: 11,
                          color: const Color(0xFF0EA5E9),
                        ),
                      ),
                      Text(
                        'Download: $rx',
                        style: GoogleFonts.shareTechMono(
                          fontSize: 11,
                          color: const Color(0xFFF97316),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- INTERACTIVE PING TOOL ---
  void _showPingToolDialog() {
    _pingOutputs.clear();
    _pingOutputs.add('Console Ready. Target: google.com (8.8.8.8)');
    _isPingRunning = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              title: Text(
                'WinBox Diagnostic: Ping Tool',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 320,
                child: Column(
                  children: [
                    Container(
                      height: 220,
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        itemCount: _pingOutputs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              _pingOutputs[index],
                              style: GoogleFonts.shareTechMono(
                                color: _pingOutputs[index].contains('timeout')
                                    ? Colors.red
                                    : _pingOutputs[index].contains('Ready')
                                    ? Colors.cyan
                                    : Colors.greenAccent,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _isPingRunning
                              ? null
                              : () {
                                  setDialogState(() {
                                    _isPingRunning = true;
                                  });
                                  int count = 0;
                                  _pingTimer = Timer.periodic(
                                    const Duration(milliseconds: 800),
                                    (t) {
                                      count++;
                                      if (count > 10) {
                                        t.cancel();
                                        if (mounted) {
                                          setDialogState(() {
                                            _isPingRunning = false;
                                            _pingOutputs.add(
                                              'Ping complete. 10 packets sent, 10 received.',
                                            );
                                          });
                                        }
                                        return;
                                      }
                                      if (mounted) {
                                        setDialogState(() {
                                          _pingOutputs.add(
                                            'seq=$count host=8.8.8.8 bytes=56 ttl=57 time=${22 + math.Random().nextInt(15)}ms',
                                          );
                                        });
                                      }
                                    },
                                  );
                                },
                          icon: const Icon(Icons.play_arrow, size: 16),
                          label: const Text('Start Ping'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            _pingTimer?.cancel();
                            setDialogState(() {
                              _isPingRunning = false;
                              _pingOutputs.clear();
                              _pingOutputs.add(
                                'Console Ready. Target: google.com (8.8.8.8)',
                              );
                            });
                          },
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text('Clear'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isDark
                                ? Colors.white70
                                : Colors.black87,
                            side: BorderSide(
                              color: isDark ? Colors.white24 : Colors.black26,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _pingTimer?.cancel();
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- INTERACTIVE SPEEDTEST TOOL ---
  void _showSpeedTestDialog() {
    _isSpeedTestRunning = false;
    _speedTestProgress = 0.0;
    _speedTestDownload = 0.0;
    _speedTestUpload = 0.0;
    _speedTestPhase = 'Idle';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              title: Text(
                'Bandwidth Test (SpeedTest)',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 280,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _speedTestPhase,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF0EA5E9),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: _speedTestProgress,
                            strokeWidth: 8,
                            backgroundColor: isDark
                                ? Colors.white10
                                : Colors.black12,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _speedTestPhase.contains('Upload')
                                  ? const Color(0xFFF97316)
                                  : const Color(0xFF0EA5E9),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _speedTestPhase == 'Testing Download'
                                  ? '${_speedTestDownload.toStringAsFixed(1)}'
                                  : _speedTestPhase == 'Testing Upload'
                                  ? '${_speedTestUpload.toStringAsFixed(1)}'
                                  : _speedTestPhase == 'Finished'
                                  ? '${_speedTestDownload.toStringAsFixed(1)}'
                                  : '0.0',
                              style: GoogleFonts.shareTechMono(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'Mbps',
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                color: isDark ? Colors.white60 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.arrow_downward,
                                  color: Color(0xFF0EA5E9),
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text('Download'),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_speedTestDownload.toStringAsFixed(1)} Mbps',
                              style: GoogleFonts.shareTechMono(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.arrow_upward,
                                  color: Color(0xFFF97316),
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text('Upload'),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_speedTestUpload.toStringAsFixed(1)} Mbps',
                              style: GoogleFonts.shareTechMono(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                if (!_isSpeedTestRunning && _speedTestPhase != 'Finished')
                  ElevatedButton(
                    onPressed: () {
                      setDialogState(() {
                        _isSpeedTestRunning = true;
                        _speedTestPhase = 'Testing Download';
                      });

                      // Mulai simulasi speedtest
                      double dSpeed = 0.0;
                      double uSpeed = 0.0;
                      int steps = 0;

                      Timer.periodic(const Duration(milliseconds: 150), (
                        timer,
                      ) {
                        steps++;
                        if (!mounted) {
                          timer.cancel();
                          return;
                        }

                        if (steps <= 20) {
                          // Fase Download
                          dSpeed = 20.0 + math.Random().nextDouble() * 55.0;
                          if (steps == 20) {
                            // Selesai Download
                            dSpeed = 74.2; // Final download speed
                          }
                          setDialogState(() {
                            _speedTestProgress = steps / 40.0;
                            _speedTestDownload = dSpeed;
                          });
                        } else if (steps <= 40) {
                          // Fase Upload
                          if (steps == 21) {
                            setDialogState(() {
                              _speedTestPhase = 'Testing Upload';
                            });
                          }
                          uSpeed = 5.0 + math.Random().nextDouble() * 25.0;
                          if (steps == 40) {
                            // Selesai Upload
                            uSpeed = 28.5; // Final upload speed
                          }
                          setDialogState(() {
                            _speedTestProgress = steps / 40.0;
                            _speedTestUpload = uSpeed;
                          });
                        } else {
                          timer.cancel();
                          setDialogState(() {
                            _isSpeedTestRunning = false;
                            _speedTestProgress = 1.0;
                            _speedTestPhase = 'Finished';
                          });

                          // Tambahkan ke log sistem
                          setState(() {
                            final now = DateTime.now();
                            final timeStr =
                                "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
                            _logs.add({
                              'time': timeStr,
                              'type': 'system,info',
                              'msg':
                                  'bandwidth speedtest completed: DL 74.2 Mbps / UL 28.5 Mbps',
                            });
                          });
                        }
                      });
                    },
                    child: const Text('Start Test'),
                  ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- POPUP DIALOG REBOOT ---
  void _showRebootConfirm() {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          title: Row(
            children: [
              const Icon(Icons.warning, color: Colors.orange),
              const SizedBox(width: 10),
              Text(
                'Reboot Router?',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: Text(
            'Apakah Anda yakin ingin melakukan reboot pada perangkat router MatrixSphere? Koneksi internet klien akan terputus selama proses reboot berlangsung (sekitar 5-7 detik).',
            style: GoogleFonts.openSans(
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _simulateReboot();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Ya, Reboot'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final deviceProvider = Provider.of<DeviceProvider>(context);
    final deviceInfo = deviceProvider.deviceInfo;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Skema Warna Dashboard
    final Color bgColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF1F5F9);
    final Color cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final Color textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final Color textSecondary = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark
            ? const Color(0xFF1E293B)
            : Theme.of(context).colorScheme.primary,
        title: Row(
          children: [
            const Icon(Icons.dns, size: 24),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MatrixSphere WebFig',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  deviceInfo != null ? '${deviceInfo.deviceModel} (v${deviceInfo.osVersion})' : 'Loading...',
                  style: GoogleFonts.roboto(
                    fontSize: 11,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Indikator Koneksi Pulsing
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    Color pulseColor = const Color(
                      0xFF10B981,
                    ); // Green connected
                    if (_connectionStatus == 'Rebooting') {
                      pulseColor = Colors.red;
                    }
                    if (_connectionStatus == 'Connecting') {
                      pulseColor = Colors.orange;
                    }

                    return Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: pulseColor,
                        boxShadow: [
                          BoxShadow(
                            color: pulseColor.withAlpha((_pulseController.value * 153).clamp(0, 255).toInt()),
                            blurRadius: 6.0 * _pulseController.value,
                            spreadRadius: 3.0 * _pulseController.value,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(width: 6),
                Text(
                  _connectionStatus,
                  style: GoogleFonts.roboto(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Tampilkan konten utama atau indikator loading
          deviceProvider.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: isDark ? Colors.white : Theme.of(context).primaryColor,
                  ),
                )
              : deviceProvider.errorMessage != null
                  ? Center(
                      child: Text(
                        'Error: ${deviceProvider.errorMessage}',
                        style: TextStyle(color: textSecondary),
                      ),
                    )
                  : SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- TOP WELCOME / UPTIME CARD ---
                  _buildUptimeCard(deviceInfo!, cardColor, textPrimary, textSecondary),
                  const SizedBox(height: 16),

                  // --- SYSTEM HEALTH GRID (CPU, RAM, TEMP, STORAGE) ---
                  Text(
                    'System Health Resources',
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildHealthGrid(cardColor, textPrimary, textSecondary),
                  const SizedBox(height: 20),

                  // --- TRAFFIC MONITOR (GRAPH) ---
                  _buildTrafficCard(
                    cardColor,
                    deviceInfo,
                    textPrimary,
                    textSecondary,
                    isDark,
                  ),
                  const SizedBox(height: 20),

                  // --- STATS OVERVIEW GRID (HOTSPOT USERS, LEASES) ---
                  Text(
                    'Active Connections Summary',
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildStatsGrid(cardColor, textPrimary, textSecondary),
                  const SizedBox(height: 20),

                  // --- QUICK ACTIONS / WINBOX MENU GRID ---
                  Text(
                    'Quick Control (WinBox Menu)',
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildQuickActionsGrid(cardColor, textPrimary, textSecondary),
                  const SizedBox(height: 20),

                  // --- SIMULATED LOG TERMINAL ---
                  _buildLogTerminalCard(
                    cardColor,
                    textPrimary,
                    textSecondary,
                    isDark,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // --- REBOOT OVERLAY ---
          if (_isRebooting)
            Container(
              color: Colors.black.withAlpha(217), // 0.85 * 255
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Card(
                  color: const Color(0xFF1E293B),
                  margin: const EdgeInsets.all(24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            strokeWidth: 6,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Router Rebooting...',
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mohon tunggu sejenak, sistem sedang dimuat ulang.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            fontSize: 13,
                            color: Colors.white60,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withAlpha(51), // 0.2 * 255
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Estimasi terhubung kembali: $_rebootCountdown s',
                            style: GoogleFonts.shareTechMono(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // --- UI BUILDING BLOCKS ---

  Widget _buildUptimeCard(
    DeviceInfo deviceInfo,
    Color cardColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0EA5E9).withAlpha(26), // 0.1 * 255
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.dns,
                  color: Color(0xFF0EA5E9),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'IP Address: ${deviceInfo.ipAddress}',
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  Text(
                    'WinBox Session: admin (mac/local)',
                    style: GoogleFonts.openSans(
                      fontSize: 12,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'UPTIME',
                style: GoogleFonts.roboto(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: textSecondary,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                _formatUptime(deviceInfo.uptimeSeconds),
                style: GoogleFonts.shareTechMono(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthGrid(
    Color cardColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.6,
      children: [
        _buildHealthItemCard(
          'CPU Usage',
          '$_cpuUsage %',
          _cpuUsage / 100,
          Colors.teal,
          cardColor,
          textPrimary,
          textSecondary,
          '4 Cores @ 1.4GHz',
        ),
        _buildHealthItemCard(
          'RAM (Memory)',
          '${_ramUsage.toInt()} MB',
          _ramUsage / _ramMax,
          Colors.purple,
          cardColor,
          textPrimary,
          textSecondary,
          'Max: ${_ramMax.toInt()} MB',
        ),
        _buildHealthItemCard(
          'CPU Temperature',
          '$_cpuTemp °C',
          _cpuTemp / 100,
          Colors.orange,
          cardColor,
          textPrimary,
          textSecondary,
          'Alert Limit: 85 °C',
        ),
        _buildHealthItemCard(
          'Storage (Disk)',
          '${_diskUsage.toStringAsFixed(1)} GB',
          _diskUsage / _diskMax,
          Colors.blue,
          cardColor,
          textPrimary,
          textSecondary,
          'Used of ${_diskMax.toInt()} GB',
        ),
      ],
    );
  }

  Widget _buildHealthItemCard(
    String label,
    String value,
    double percent,
    Color accentColor,
    Color cardColor,
    Color textPrimary,
    Color textSecondary,
    String detail,
  ) {
    // Tentukan warna progress bar berdasarkan persentase
    Color progressColor = accentColor;
    if (percent > 0.8) {
      progressColor = Colors.red;
    } else if (percent > 0.6) {
      progressColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: textSecondary,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.shareTechMono(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: progressColor.withAlpha(26), // 0.1 * 255
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            detail,
            style: GoogleFonts.openSans(fontSize: 10, color: textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildTrafficCard(
    Color cardColor,
    DeviceInfo deviceInfo,
    Color textPrimary,
    Color textSecondary,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Real-time Bandwidth Interface',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  Text(
                    'Active monitoring of wan-ether1 & bridge-lan',
                    style: GoogleFonts.openSans(
                      fontSize: 11,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildTrafficLegend('Tx (Up)', const Color(0xFF0EA5E9)),
                  const SizedBox(width: 10),
                  _buildTrafficLegend('Rx (Down)', const Color(0xFFF97316)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Indikator Trafik Angka Saat Ini
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upload speed (Tx):',
                style: GoogleFonts.openSans(fontSize: 12, color: textSecondary),
              ),
              Text(
                '${deviceInfo.tx.toStringAsFixed(1)} Mbps',
                style: GoogleFonts.shareTechMono(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0EA5E9),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Download speed (Rx):',
                style: GoogleFonts.openSans(fontSize: 12, color: textSecondary),
              ),
              Text(
                '${deviceInfo.rx.toStringAsFixed(1)} Mbps',
                style: GoogleFonts.shareTechMono(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFF97316),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Area Chart FL Chart
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 5,
                  verticalInterval: 2,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: isDark ? Colors.white10 : Colors.black12,
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: isDark ? Colors.white10 : Colors.black12,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: 3,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            '${value.toInt()}s',
                            style: GoogleFonts.shareTechMono(
                              color: isDark ? Colors.white30 : Colors.black38,
                              fontSize: 9,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}M',
                          style: GoogleFonts.shareTechMono(
                            color: isDark ? Colors.white30 : Colors.black38,
                            fontSize: 9,
                          ),
                        );
                      },
                      reservedSize: 24,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: isDark ? Colors.white10 : Colors.black12,
                  ),
                ),
                minX: 0,
                maxX: 14,
                minY: 0,
                maxY: 35,
                lineBarsData: [
                  LineChartBarData(
                    spots: _txSpots,
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
                    ),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF0EA5E9).withAlpha(38), // 0.15 * 255
                          const Color(0xFF2563EB).withAlpha(0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  LineChartBarData(
                    spots: _rxSpots,
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF97316), Color(0xFFEA580C)],
                    ),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFF97316).withAlpha(38), // 0.15 * 255
                          const Color(0xFFEA580C).withAlpha(0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrafficLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.roboto(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(
    Color cardColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.2,
      children: [
        _buildStatItemCard(
          'Active Hotspots',
          '42 Clients',
          Icons.wifi,
          const Color(0xFF10B981),
          cardColor,
          textPrimary,
          textSecondary,
        ),
        _buildStatItemCard(
          'DHCP Leases',
          '128 Active',
          Icons.lan,
          const Color(0xFF0EA5E9),
          cardColor,
          textPrimary,
          textSecondary,
        ),
        _buildStatItemCard(
          'PPPoE Tunnels',
          '15 Connected',
          Icons.vpn_lock,
          const Color(0xFF8B5CF6),
          cardColor,
          textPrimary,
          textSecondary,
        ),
        _buildStatItemCard(
          'Firewall Dropped',
          '1,492 Blocks',
          Icons.shield,
          const Color(0xFFEF4444),
          cardColor,
          textPrimary,
          textSecondary,
        ),
      ],
    );
  }

  Widget _buildStatItemCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
    Color cardColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(26), // 0.1 * 255
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.shareTechMono(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(
    Color cardColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.15,
      children: [
        _buildQuickActionBtn(
          'Interfaces',
          Icons.settings_ethernet,
          Colors.cyan,
          _showInterfacesSheet,
          cardColor,
          textPrimary,
        ),
        _buildQuickActionBtn(
          'IP Services',
          Icons.dns,
          Colors.amber,
          _showIpServicesSheet,
          cardColor,
          textPrimary,
        ),
        _buildQuickActionBtn(
          'Hotspots',
          Icons.wifi_tethering,
          Colors.green,
          _showHotspotUsersSheet,
          cardColor,
          textPrimary,
        ),
        _buildQuickActionBtn(
          'Ping Tool',
          Icons.terminal,
          Colors.purple,
          _showPingToolDialog,
          cardColor,
          textPrimary,
        ),
        _buildQuickActionBtn(
          'Speed Test',
          Icons.speed,
          Colors.pink,
          _showSpeedTestDialog,
          cardColor,
          textPrimary,
        ),
        _buildQuickActionBtn(
          'Reboot',
          Icons.restart_alt,
          Colors.red,
          _showRebootConfirm,
          cardColor,
          textPrimary,
        ),
      ],
    );
  }

  Widget _buildQuickActionBtn(
    String label,
    IconData icon,
    Color activeColor,
    VoidCallback onTap,
    Color cardColor,
    Color textPrimary,
  ) {
    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withAlpha(15)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: activeColor.withAlpha(38), // 0.15 * 255
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: activeColor, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.roboto(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogTerminalCard(
    Color cardColor,
    Color textPrimary,
    Color textSecondary,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Log Terminal
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 8.0,
              top: 12.0,
              bottom: 8.0,
            ),
            key: const ValueKey('log_header'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.receipt_long,
                      color: Color(0xFF0EA5E9),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'MikroTik System Logs',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isLogPaused ? Icons.play_arrow : Icons.pause,
                        size: 18,
                        color: textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _isLogPaused = !_isLogPaused;
                        });
                      },
                      tooltip: _isLogPaused ? 'Resume Logs' : 'Pause Logs',
                    ),
                    IconButton(
                      icon: Icon(
                        _isAutoScrollEnabled
                            ? Icons.arrow_downward
                            : Icons.vertical_align_bottom,
                        size: 18,
                        color: _isAutoScrollEnabled
                            ? const Color(0xFF10B981)
                            : textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _isAutoScrollEnabled = !_isAutoScrollEnabled;
                        });
                      },
                      tooltip: 'Auto Scroll Toggle',
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_sweep,
                        size: 18,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        setState(() {
                          _logs.clear();
                        });
                      },
                      tooltip: 'Clear Terminal',
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Area Terminal Hitam
          Container(
            height: 180,
            width: double.infinity,
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black26,
              ),
            ),
            child: _logs.isEmpty
                ? Center(
                    child: Text(
                      'No system logs available.',
                      style: GoogleFonts.shareTechMono(
                        color: Colors.white30,
                        fontSize: 13,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _logScrollController,
                    itemCount: _logs.length,
                    itemBuilder: (context, index) {
                      final item = _logs[index];
                      // Menentukan warna tulisan log berdasarkan jenis
                      Color logColor = Colors.white70;
                      if (item['type'].toString().contains('critical') ||
                          item['type'].toString().contains('error')) {
                        logColor = Colors.redAccent;
                      } else if (item['type'].toString().contains('hotspot')) {
                        logColor = Colors.cyanAccent;
                      } else if (item['type'].toString().contains('dhcp')) {
                        logColor = Colors.greenAccent;
                      } else if (item['type'].toString().contains('firewall')) {
                        logColor = Colors.orangeAccent;
                      } else if (item['type'].toString().contains('wireless')) {
                        logColor = Colors.purpleAccent;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${item['time']} ',
                              style: GoogleFonts.shareTechMono(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 0.5,
                              ),
                              margin: const EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                color: logColor.withAlpha(38), // 0.15 * 255
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                item['type'],
                                style: GoogleFonts.shareTechMono(
                                  color: logColor,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                item['msg'],
                                style: GoogleFonts.shareTechMono(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

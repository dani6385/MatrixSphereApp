import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_services/shared_services.dart';
import '../auth/mikrotik_auth.dart';
import '../dialog/member_dialog.dart';
import '../dialog/qr_dialog.dart';
import '../dialog/scan_dialog.dart';
import '../dialog/voucher_dialog.dart';
import 'navigation_layout.dart';
import 'package:shared_assets/shared_assets.dart';
import '../services/hotspot_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Logger _logger = Logger();
  final HotspotService _hotspotService = HotspotService();
  final MikrotikAuth _auth =
      MikrotikAuth(loginUrl: 'http://192.168.30.1/login');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatusAndNavigate();
    });
  }

  void _checkLoginStatusAndNavigate() async {
    final isLocallyLoggedIn = await AuthService.isLoggedIn();
    if (!isLocallyLoggedIn) {
      _logger.i("User belum login (tidak ada data sesi lokal).");
      return;
    }

    final username = await AuthService.getUsername();
    if (username == null || username.isEmpty) {
      _logger.w(
          "Status login lokal true, tapi tidak ada username. Sesi dibersihkan.");
      await AuthService.setLoggedIn(false, '');
      return;
    }

    _logger.i(
        "Sesi lokal ditemukan untuk user '$username'. Memverifikasi dengan Firebase RTDB...");

    final isRtdbLoggedIn = await _auth.checkLoginStatus(username);

    if (isRtdbLoggedIn && mounted) {
      _logger
          .i("User '$username' terverifikasi di RTDB. Navigasi ke dashboard.");
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const NavigationLayout()),
        (Route<dynamic> route) => false,
      );
    } else {
      _logger.w(
          "User '$username' tidak ditemukan di RTDB. Sesi lokal dibersihkan.");
      await AuthService.setLoggedIn(false, '');
    }
  }

  Future<void> _handleLogin(
      {required String username, String password = ''}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    bool success = false;
    String? errorMessage;

    try {
      success = await _auth.login(username: username, password: password);
    } catch (e) {
      errorMessage = e.toString();
    }

    if (!mounted) return;

    Navigator.pop(context);

    if (success) {
      _logger.i(
          "Login berhasil, menyimpan status & navigasi ke NavigationLayout.");
      await AuthService.setLoggedIn(true, username);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Berhasil!'),
          backgroundColor: AppColors.secondaryColor,
        ),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const NavigationLayout()),
        (Route<dynamic> route) => false,
      );
    } else {
      _logger.w("Login gagal. Pesan error: $errorMessage");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(errorMessage ?? 'Login Gagal. Periksa kembali data Anda.'),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }

  void _scanQR() async {
    final result = await showScanDialog(context);
    if (result != null) {
      await _handleLogin(username: result);
    }
  }

  void _bayarQR() {
    showQrDialog(context);
  }

  void _showTrialDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coba Gratis'),
        content: const Text(
            'Anda akan mendapatkan akses internet gratis selama 1 jam. Lanjutkan?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Mulai'),
            onPressed: () {
              Navigator.of(context).pop();
              final trialUsername =
                  'TRIAL-${DateTime.now().millisecondsSinceEpoch}';
              _handleLogin(username: trialUsername);
            },
          ),
        ],
      ),
    );
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _hotspotService.getWaitingUsersStream(),
        builder: (context, snapshot) {
          // Logika: Jika ada data di folder 'wait', kita bisa beri notifikasi atau tombol khusus
          bool hasWaitingUsers = snapshot.hasData && snapshot.data!.snapshot.value != null;
          return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3D2F8), Color(0xFFF0E5F8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Icon(Icons.wifi, size: 64, color: AppColors.wifiColor),
            const SizedBox(height: 20),
            if (hasWaitingUsers)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      color: Colors.amber[100],
                      child: ListTile(
                        leading: const Icon(Icons.notifications_active),
                        title: const Text("Ada perangkat baru terdeteksi!"),
                        onTap: () async {
                          String macAddress = snapshot.data!.snapshot.value.toString();
                          // Arahkan ke dialog atau fungsi aktivasi
                          await _hotspotService.activateTrial("92:21:50:C3:A7:11");
                          await _handleLogin(username: "T-$macAddress");
                        },
                      ),
                    ),
                  ),
            const Text(
              'Selamat Datang',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const Text(
              'Silakan pilih metode login Anda',
              style: TextStyle(fontSize: 16, color: AppColors.textColor),
            ),
            const SizedBox(height: 40),
            Table(
              children: [
                TableRow(
                  children: [
                    _buildLoginButton(
                      text: 'Login Voucher',
                      icon: Icons.confirmation_number,
                      color: AppColors.voucherColor,
                      onPressed: () => showVoucherDialog(context, _handleLogin),
                    ),
                    _buildLoginButton(
                      text: 'Login Member',
                      icon: Icons.person,
                      color: AppColors.memberColor,
                      onPressed: () => showMemberDialog(context, _handleLogin),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    _buildLoginButton(
                      text: 'Scan QR',
                      icon: Icons.qr_code_scanner,
                      color: AppColors.scanQrColor,
                      onPressed: _scanQR,
                    ),
                    _buildLoginButton(
                      text: 'Bayar QR',
                      icon: Icons.qr_code_2,
                      color: AppColors.payQrColor,
                      onPressed: _bayarQR,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            _buildLoginButton(
              text: 'Coba Gratis',
              icon: Icons.timer_outlined,
              color: AppColors.trialColor,
              onPressed: _showTrialDialog,
              isTrial: true,
            ),
            const Spacer(),
          ],
        ),
      );
    },
  ),
 );
  }
}

Widget _buildLoginButton({
  required String text,
  required IconData icon,
  required VoidCallback onPressed,
  bool isTrial = false,
  Color? color, // Tambahkan parameter warna di sini
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        // Gunakan parameter color, jika null gunakan warna default (misal: primary)
        backgroundColor: color ?? Colors.blue,
        foregroundColor: AppColors.foregroundColor,
        padding: const EdgeInsets.symmetric(vertical: 20,),
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: onPressed,
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(height: 8),
          Text(text),
        ],
      ),
    ),
  );
}
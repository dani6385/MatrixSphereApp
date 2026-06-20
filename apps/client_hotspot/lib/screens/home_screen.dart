import 'package:flutter/material.dart';
// Import library MikroTik API Anda di sini
// Import library Iklan (contoh: google_mobile_ads) di sini

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variabel untuk menyimpan data dari MikroTik
  String _sisaKuota = "24.7 GB";
  String _masaAktif = "21 Hari";
  double _persenKuota = 0.75; // Contoh 75%

  // Logika Iklan (Pseudo-code)
  // BannerAd? _bannerAd;
  // bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    // 1. Panggil fungsi untuk mengambil data dari MikroTik API
    // 2. Inisialisasi Iklan Banner
  }

  @override
  Widget build(BuildContext context) {
    // Definisi Warna Tema (Elegance & Professional)
    final Color primaryColor = const Color(0xFF0D1E40); // Deep Sapphire
    final Color accentColor = const Color(0xFF2196F3); // Modern Blue
    final Color cardColor = Colors.white;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA), // Light Gray Background
      appBar: AppBar(
        title: const Text(
          'NetLink Hotspot',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Memungkinkan Scroll
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // 1. DASHBOARD STATUS (Elegant Card)
            // ==========================================
            _buildStatusCard(primaryColor, accentColor, cardColor),

            const SizedBox(height: 24),

            // ==========================================
            // 2. TOMBOL AKSI UTAMA (Modern Icons)
            // ==========================================
            Text(
              'Aksi Cepat',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildActionButtons(accentColor, cardColor),

            const SizedBox(height: 24),

            // ==========================================
            // 3. MADING INFORMASI (List of Cards)
            // ==========================================
            Text(
              'Mading Informasi & Promo',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildMadingSection(cardColor, accentColor),

            const SizedBox(height: 16),

            // ==========================================
            // 4. INTEGRASI IKLAN (Halus & Scrollable)
            // ==========================================
            // Contoh penempatan iklan banner yang menyatu dengan list
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: Text(
                  "IKLAN SPONSOR - Promo Kopi Lokal (AdMob)",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar (Opsional, untuk navigasi antar screen)
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: accentColor,
        unselectedItemColor: Colors.grey,
        currentIndex: 0, // Home selected
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // WIDGET BUILDER HELPER (Untuk Kode yang Bersih)
  // =========================================================================

  Widget _buildStatusCard(
    Color primaryColor,
    Color accentColor,
    Color cardColor,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SISA KUOTA',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _sisaKuota,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Circular Progress (Elegant)
                SizedBox(
                  height: 60,
                  width: 60,
                  child: CircularProgressIndicator(
                    value: _persenKuota,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                    strokeWidth: 8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusInfo(
                  'Masa Aktif',
                  _masaAktif,
                  Icons.timer_outlined,
                  accentColor,
                ),
                _buildStatusInfo(
                  'Status',
                  'Aktif',
                  Icons.check_circle_outline,
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusInfo(
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Color(0xFF0D1E40),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Color accentColor, Color cardColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(
          Icons.qr_code_scanner,
          'Scan Voucher',
          accentColor,
          cardColor,
          () {
            // Navigasi ke Scan Screen
          },
        ),
        _buildActionButton(
          Icons.account_balance_wallet_outlined,
          'Bayar QRIS',
          accentColor,
          cardColor,
          () {
            // Navigasi ke Payment Screen
          },
        ),
        // TOMBOL TRIAL BERBASIS IKLAN (Highlighted)
        _buildActionButton(
          Icons.play_circle_fill,
          'Trial (Iklan)',
          Colors.orange,
          cardColor,
          () {
            // Pemicu Rewarded Ad
          },
          isHighlighted: true,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    Color color,
    Color cardColor,
    VoidCallback onPressed, {
    bool isHighlighted = false,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: isHighlighted ? color.withAlpha(5) : color,
              borderRadius: BorderRadius.circular(16),
              border: isHighlighted ? Border.all(color: color, width: 2) : null,
            ),
            child: Icon(
              icon,
              color: isHighlighted ? color : Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0D1E40),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMadingSection(Color cardColor, Color accentColor) {
    // Contoh data Mading (Bisa diambil dari comment user MikroTik)
    final List<Map<String, String>> madingMessages = [
      {'title': 'Promo Paket Hebat!', 'desc': 'Hemat 30% Bulan Ini'},
      {'title': 'Jaringan Stabil', 'desc': 'Semua Sistem OK'},
      {'title': 'Event Spesial', 'desc': 'WiFi Gratis @ Alun-Alun Sabtu Ini'},
    ];

    return Column(
      children: madingMessages
          .map(
            (msg) => _buildMadingCard(
              msg['title']!,
              msg['desc']!,
              cardColor,
              accentColor,
            ),
          )
          .toList(),
    );
  }

  Widget _buildMadingCard(
    String title,
    String desc,
    Color cardColor,
    Color accentColor,
  ) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: cardColor,
      child: ListTile(
        leading: Icon(Icons.info_outline, color: accentColor),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          desc,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey,
        ),
        onTap: () {
          // Detail Mading
        },
      ),
    );
  }
}

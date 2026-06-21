import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widget/home/detailed_quota.dart';

void main() {
  runApp(const MatrixSphere());
}

class MatrixSphere extends StatelessWidget {
  const MatrixSphere({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quota Viewer',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF0F5F9), // Warna latar belakang terang
        useMaterial3: true,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variabel untuk navigasi bottom bar
  int _selectedIndex = 0;

  // Data Contoh (Mock Data)
  final double totalMainQuotaGB = 50.0;
  final double remainingMainQuotaGB = 36.2;
  final double totalBonusMalamGB = 10.0;
  final double remainingBonusMalamGB = 9.1;

  @override
  Widget build(BuildContext context) {
    // Perhitungan persentase
    double mainQuotaPercent = remainingMainQuotaGB / totalMainQuotaGB;
    double bonusMalamPercent = remainingBonusMalamGB / totalBonusMalamGB;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const HeaderWidget(userName: 'Budi'),
              const SizedBox(height: 20),

              // Paket Utama Card
              MainQuotaCard(
                totalQuotaGB: totalMainQuotaGB,
                remainingQuotaGB: remainingMainQuotaGB,
                percent: mainQuotaPercent,
                validUntil: '15 November 2023',
              ),
              const SizedBox(height: 20),

              // Bonus Kuota Malam Card
              BonusQuotaCard(
                title: 'Bonus Kuota Malam (00-06)',
                totalQuotaGB: totalBonusMalamGB,
                remainingQuotaGB: remainingBonusMalamGB,
                percent: bonusMalamPercent,
              ),
              const SizedBox(height: 20),

              // Kuota Aplikasi Card
              const AppQuotaCard(),
              const SizedBox(height: 20),

              // Kuota Roaming Card
              const RoamingQuotaCard(),
              const SizedBox(height: 80), // Jarak untuk tombol
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ElevatedButton(
          onPressed: () {
            // Aksi untuk tombol beli paket
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C89A3), // Warna tombol abu-abu biru
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Beli Paket Data Baru', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

// Widget Header (Halo, Nama User)
class HeaderWidget extends StatelessWidget {
  final String userName;
  const HeaderWidget({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, $userName!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Cek Sisa Kuota Anda Hari Ini',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        const Icon(Icons.notifications_none, size: 28),
      ],
    );
  }
}

// Widget Card Utama dengan Circular Progress
class MainQuotaCard extends StatelessWidget {
  final double totalQuotaGB;
  final double remainingQuotaGB;
  final double percent;
  final String validUntil;

  const MainQuotaCard({
    super.key,
    required this.totalQuotaGB,
    required this.remainingQuotaGB,
    required this.percent,
    required this.validUntil,
  });

  @override
  Widget build(BuildContext context) {
    final double usedQuotaGB = totalQuotaGB - remainingQuotaGB;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DetailedQuotaPage(),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue.withAlpha(2), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paket Utama: Super Data 50GB',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Circular Progress
                Expanded(
                  child: SizedBox(
                    height: 180,
                    width: 180,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: percent,
                          strokeWidth: 15,
                          color: const Color(0xFF00C853), // Warna hijau sisa
                          backgroundColor: const Color(0xFFE0E0E0), // Warna abu-abu total
                          strokeCap: StrokeCap.round,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${(percent * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF00C853)),
                            ),
                            Text(
                              '${remainingQuotaGB.toStringAsFixed(1)} GB',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'dari total ${totalQuotaGB.toStringAsFixed(0)} GB',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 20,
                          right: 20,
                          child: Text(
                            '${((1 - percent) * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Detail Penggunaan
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailRow(label: 'Tersisa:', value: '${remainingQuotaGB.toStringAsFixed(1)} GB'),
                    const SizedBox(height: 10),
                    DetailRow(label: 'Digunakan:', value: '${usedQuotaGB.toStringAsFixed(1)} GB'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Masa Aktif:'),
                Text(
                  'Hingga $validUntil',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget Baris Detail untuk Card Utama
class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// Widget Card Bonus Kuota dengan Linear Progress
class BonusQuotaCard extends StatelessWidget {
  final String title;
  final double totalQuotaGB;
  final double remainingQuotaGB;
  final double percent;

  const BonusQuotaCard({
    super.key,
    required this.title,
    required this.totalQuotaGB,
    required this.remainingQuotaGB,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 3,
      shadowColor: Colors.black.withAlpha(1),
      child: InkWell(
        onTap: () {
          // --- INI ADALAH CARA MEMANGGILNYA ---
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DetailedQuotaPage(),
            ),
          );
          // -------------------------------------
        },
        borderRadius: BorderRadius.circular(15),
        child: QuotaInfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${remainingQuotaGB.toStringAsFixed(1)} GB dari ${totalQuotaGB.toStringAsFixed(0)} GB',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  Text('${(percent * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 5),
              LinearProgressIndicator(
                value: percent,
                color: const Color(0xFFFFC107), // Warna kuning
                backgroundColor: const Color(0xFFE0E0E0),
                minHeight: 8,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget Card Kuota Aplikasi (Sosmed)
class AppQuotaCard extends StatelessWidget {
  const AppQuotaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return QuotaInfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Kuota Aplikasi Media Sosial', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const AppUsageIcon(icon: Icons.facebook, label: 'Facebook', usage: '1.2 GB'),
              const AppUsageIcon(icon: Icons.camera_alt, label: 'Instagram', usage: '1.3 GB'), // Ganti dengan icon IG asli jika perlu asset
              const AppUsageIcon(icon: Icons.chat_bubble, label: 'WhatsApp', usage: '3 %'),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget Card Kuota Roaming (Non-aktif)
class RoamingQuotaCard extends StatelessWidget {
  const RoamingQuotaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return QuotaInfoCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Kuota Roaming Internasional', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Row(
            children: [
              const Text('0 MB dari 1 GB (Belum Aktif)', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(width: 5),
              const Icon(Icons.check_circle_outline, size: 16, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}

// Kontainer Umum untuk Card Info
class QuotaInfoCard extends StatelessWidget {
  final Widget child;
  const QuotaInfoCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(3),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

// Widget Icon Penggunaan Aplikasi (Row di AppQuotaCard)
class AppUsageIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final String usage;

  const AppUsageIcon({super.key, required this.icon, required this.label, required this.usage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.blue),
        const SizedBox(height: 5),
        Text(usage, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// Widget Navigasi Bottom Bar Kustom
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF6C89A3),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.view_agenda_outlined), label: 'Paket'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Transaksi'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widget/home/detailed_quota.dart';
import '../widget/home/mading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Data Contoh (Mock Data)
  final double totalMainQuotaGB = 50.0;
  final double remainingMainQuotaGB = 36.2;
  final double totalBonusMalamGB = 10.0;
  final double remainingBonusMalamGB = 9.1;

  void _navigateToDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedQuotaPage(
          totalMainQuotaGB: totalMainQuotaGB,
          remainingMainQuotaGB: remainingMainQuotaGB,
          totalBonusMalamGB: totalBonusMalamGB,
          remainingBonusMalamGB: remainingBonusMalamGB,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double mainQuotaPercent = remainingMainQuotaGB / totalMainQuotaGB;
    double bonusMalamPercent = remainingBonusMalamGB / totalBonusMalamGB;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderWidget(userName: 'Budi'),
              const SizedBox(height: 20),
              MainQuotaCard(
                totalQuotaGB: totalMainQuotaGB,
                remainingQuotaGB: remainingMainQuotaGB,
                percent: mainQuotaPercent,
                validUntil: '15 November 2023',
                onTap: _navigateToDetail,
              ),
              const SizedBox(height: 20),
              BonusQuotaCard(
                title: 'Bonus Kuota Malam (00-06)',
                totalQuotaGB: totalBonusMalamGB,
                remainingQuotaGB: remainingBonusMalamGB,
                percent: bonusMalamPercent,
                onTap: _navigateToDetail,
              ),
              const SizedBox(height: 20),
              const MadingWidget(),
              const SizedBox(height: 20),
              const AppQuotaCard(),
              const SizedBox(height: 20),
              const RoamingQuotaCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

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
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
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

class MainQuotaCard extends StatelessWidget {
  final double totalQuotaGB;
  final double remainingQuotaGB;
  final double percent;
  final String validUntil;
  final VoidCallback onTap;

  const MainQuotaCard({
    super.key,
    required this.totalQuotaGB,
    required this.remainingQuotaGB,
    required this.percent,
    required this.validUntil,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double usedQuotaGB = totalQuotaGB - remainingQuotaGB;

    return InkWell(
      onTap: onTap,
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
            Text(
              'Paket Utama: Super Data 50GB',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 220,
                  width: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 220,
                        width: 220,
                        child: CircularProgressIndicator(
                          value: percent,
                          strokeWidth: 20,
                          color: const Color(0xFF00C853),
                          backgroundColor: const Color(0xFFE0E0E0),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${remainingQuotaGB.toStringAsFixed(1)} GB',
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'dari ${totalQuotaGB.toStringAsFixed(0)} GB',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailRow(
                      label: 'Tersisa:',
                      value: '${remainingQuotaGB.toStringAsFixed(1)} GB',
                    ),
                    const SizedBox(height: 10),
                    DetailRow(
                      label: 'Digunakan:',
                      value: '${usedQuotaGB.toStringAsFixed(1)} GB',
                    ),
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
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class BonusQuotaCard extends StatelessWidget {
  final String title;
  final double totalQuotaGB;
  final double remainingQuotaGB;
  final double percent;
  final VoidCallback onTap;

  const BonusQuotaCard({
    super.key,
    required this.title,
    required this.totalQuotaGB,
    required this.remainingQuotaGB,
    required this.percent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 3,
      shadowColor: Colors.black.withAlpha(1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: QuotaInfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${remainingQuotaGB.toStringAsFixed(1)} GB dari ${totalQuotaGB.toStringAsFixed(0)} GB',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    '${(percent * 100).toStringAsFixed(0)}%',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              LinearProgressIndicator(
                value: percent,
                color: const Color(0xFFFFC107),
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
              Text(
                'Kuota Aplikasi Media Sosial',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppUsageIcon(
                icon: Icons.facebook,
                label: 'Facebook',
                usage: '1.2 GB',
              ),
              AppUsageIcon(
                icon: Icons.camera_alt,
                label: 'Instagram',
                usage: '1.3 GB',
              ),
              AppUsageIcon(
                icon: Icons.chat_bubble,
                label: 'WhatsApp',
                usage: '3 %',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RoamingQuotaCard extends StatelessWidget {
  const RoamingQuotaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return QuotaInfoCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Kuota Roaming Internasional',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              const Text(
                '0 MB dari 1 GB (Belum Aktif)',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.check_circle_outline,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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

class AppUsageIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final String usage;

  const AppUsageIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.usage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.blue),
        const SizedBox(height: 5),
        Text(
          usage,
          style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

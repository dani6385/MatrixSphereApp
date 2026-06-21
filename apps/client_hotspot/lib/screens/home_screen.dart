import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import 'widgets/home/detailed_quota.dart';
import 'widgets/status_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Define colors and data based on the theme
    final Color cardColor = isDarkMode ? const Color(0xFF2B2B2B) : Colors.white;
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color accentColor = Theme.of(context).colorScheme.secondary;
    const String sisaKuota = '15.2 GB';
    const double persenKuota = 0.6;
    const String masaAktif = '25 Hari';

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang,',
                      style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white70 : Colors.black54),
                    ),
                    Text(
                      'Nama Pengguna', // Replace with actual user name
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none, size: 28),
                  onPressed: () {
                    // Handle notification tap
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Status Card
            StatusCard(
              sisaKuota: sisaKuota,
              persenKuota: persenKuota,
              masaAktif: masaAktif,
              primaryColor: primaryColor,
              accentColor: accentColor,
              cardColor: cardColor,
            ),
            const SizedBox(height: 24),

            // Permissions Section
            const DetailedQuota(),

            const SizedBox(height: 24),

            // Mading Informasi Section (Temporarily Removed)
            // Text(
            //   'Mading Informasi & Promo',
            //   style: Theme.of(context).textTheme.titleMedium?.copyWith(
            //         fontWeight: FontWeight.bold,
            //       ),
            // ),
            // const SizedBox(height: 12),
            // MadingSection(cardColor: cardColor, accentColor: accentColor),
            // const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Fungsi untuk menangani klik tombol download (Aksi CTA)
  void _onDownloadPressed(BuildContext context) {
    // Di sini Anda bisa menambahkan logika navigasi ke halaman store
    // atau menampilkan dialog. Untuk sekarang, kita tampilkan SnackBar sederhana.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Terima kasih atas minat Anda! Mengarahkan ke Download Page..."),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Warna tema aplikasi
    const Color primaryColor = Color(0xFF2563EB); // Biru Modern
    const Color accentColor = Color(0xFF10B981);  // Hijau Segar
    const Color textColor = Color(0xFF1F2937);   // Abu-abu Gelap
    const Color subtitleColor = Color(0xFF6B7280); // Abu-abu Terang

    // Style Teks Global untuk konsistensi
    const TextStyle headlineStyle = TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: textColor,
      height: 1.2,
    );

    const TextStyle subtitleStyle = TextStyle(
      fontSize: 16,
      color: subtitleColor,
      height: 1.5,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar minimalis
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(CupertinoIcons.layers_alt_fill, color: primaryColor, size: 28),
            SizedBox(width: 10),
            Text(
              "NamaAplikasi",
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w800, fontSize: 22),
            ),
          ],
        ),
        actions: [
          // Tombol CTA di AppBar untuk pengguna yang sudah siap
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: () => _onDownloadPressed(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text("Download Sekarang", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      // SingleChildScrollView agar konten bisa di-scroll jika panjang
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HERO SECTION ---
            Container(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 60),
              width: double.infinity,
              color: const Color(0xFFF3F4F6), // Latar belakang abu-abu muda yang bersih
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Gambar Ilustrasi (Ganti dengan aset gambar Anda sendiri)
                  // Disini menggunakan placeholder container berbentuk kotak
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        CupertinoIcons.rocket_fill, // Ikon yang mewakili kecepatan/inovasi
                        size: 100,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Headline Utama yang Persuasif
                  const Text(
                    "Solusi Cerdas Untuk\nMengatur Hidup Anda",
                    textAlign: TextAlign.center,
                    style: headlineStyle,
                  ),
                  const SizedBox(height: 16),

                  // Sub-headline yang menjelaskan nilai tambah (Value Proposition)
                  const Text(
                    "Kelola tugas, lacak keuangan, dan tingkatkan produktivitas Anda setiap hari. Semuanya dalam satu aplikasi yang mudah digunakan.",
                    textAlign: TextAlign.center,
                    style: subtitleStyle,
                  ),
                  const SizedBox(height: 40),

                  // Tombol CTA Utama yang Menonjol
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () => _onDownloadPressed(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor, // Hijau untuk aksi
                        foregroundColor: Colors.white,
                        elevation: 3,
                        shadowColor: accentColor.withOpacity(0.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(CupertinoIcons.arrow_down_circle_fill, size: 28),
                      label: const Text(
                        "COBA GRATIS SEKARANG",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("Tersedia untuk Android & iOS", style: TextStyle(color: subtitleColor, fontSize: 12)),
                ],
              ),
            ),

            // --- FITUR UNGGULAN SECTION ---
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Kenapa Memilih Kami?", style: headlineStyle),
                  const SizedBox(height: 10),
                  const Text("Fitur dirancang khusus untuk kemudahan Anda.", style: subtitleStyle),
                  const SizedBox(height: 40),

                  // Grid Fitur (menggunakan Wrap agar responsif)
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      _buildFeatureCard(
                        icon: CupertinoIcons.calendar_today,
                        title: "Manajemen Jadwal",
                        description: "Atur agenda harian, mingguan, dan bulanan dengan intuitif.",
                      ),
                      _buildFeatureCard(
                        icon: CupertinoIcons.chart_bar_square_fill,
                        title: "Pelacak Keuangan",
                        description: "Pantau pemasukan dan pengeluaran Anda dalam satu pandangan.",
                      ),
                      _buildFeatureCard(
                        icon: CupertinoIcons.checkmark_seal_fill,
                        title: "Pencatat Tugas",
                        description: "Kelola to-do list dengan prioritas dan tenggat waktu.",
                      ),
                      _buildFeatureCard(
                        icon: CupertinoIcons.bell_fill,
                        title: "Pengingat Cerdas",
                        description: "Jangan pernah lewatkan rapat, acara, atau tagihan penting.",
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- TESTIMONI SECTION ---
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Apa Kata Pengguna?", style: headlineStyle),
                  const SizedBox(height: 30),
                  // Kartu Testimoni
                  _buildTestimonialCard(
                    name: "Siti Rahayu",
                    role: "Freelancer",
                    comment: "Aplikasi ini benar-benar mengubah cara saya mengatur waktu. Sangat membantu produktivitas saya sehari-hari!",
                    avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg', // Gambar profil acak
                  ),
                  const SizedBox(height: 20),
                  _buildTestimonialCard(
                    name: "Budi Santoso",
                    role: "Mahasiswa",
                    comment: "Suka banget sama fitur pelacak keuangannya. Sekarang saya bisa lebih hemat dan tahu ke mana uang saya pergi.",
                    avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg', // Gambar profil acak
                  ),
                ],
              ),
            ),

            // --- FOOTER CTA SECTION ---
            Container(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
              color: primaryColor,
              width: double.infinity,
              child: Column(
                children: [
                  const Text(
                    "Siap Menjadi Lebih Produktif?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Bergabunglah dengan ribuan pengguna yang telah meningkatkan efisiensi hidup mereka.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 250,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _onDownloadPressed(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        "DOWNLOAD SEKARANG",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk Kartu Fitur
  Widget _buildFeatureCard({required IconData icon, required String title, required String description}) {
    return Container(
      width: 170, // Ukuran tetap untuk Wrap (bisa disesuaikan)
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        // Shadow halus
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF2563EB), size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(color: Colors.black54, fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }

  // Widget Helper untuk Kartu Testimoni
  Widget _buildTestimonialCard({required String name, required String role, required String comment, required String avatarUrl}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bintang Rating
          Row(
            children: List.generate(5, (index) => const Icon(CupertinoIcons.star_fill, color: Colors.amber, size: 18)),
          ),
          const SizedBox(height: 12),
          // Komentar
          Text(
            '"$comment"',
            style: const TextStyle(fontSize: 16, color: Colors.black87, fontStyle: FontStyle.italic, height: 1.5),
          ),
          const SizedBox(height: 16),
          // Profil User
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(avatarUrl),
                radius: 20,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                  Text(role, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
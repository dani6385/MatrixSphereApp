import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Halaman untuk menampilkan pusat bantuan dan FAQ.
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pusat Bantuan'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          _buildSectionHeader(context, 'Pertanyaan Umum (FAQ)'),
          const _FaqTile(
            question: 'Bagaimana cara menambahkan produk baru?',
            answer:
                'Untuk menambahkan produk baru, pergi ke menu "Produk", lalu tekan tombol tambah (+) di pojok kanan bawah. Isi semua detail produk yang diperlukan seperti nama, harga, deskripsi, dan gambar, lalu simpan.',
          ),
          const _FaqTile(
            question: 'Bagaimana cara melihat pesanan yang masuk?',
            answer:
                'Semua pesanan yang masuk dapat dilihat di menu "Pesanan". Anda akan menemukan daftar pesanan baru, yang sedang diproses, dikirim, dan selesai.',
          ),
          const _FaqTile(
            question: 'Bagaimana cara mengubah status pesanan?',
            answer:
                'Buka detail pesanan yang ingin diubah dari menu "Pesanan". Di sana Anda akan menemukan opsi untuk memperbarui status pesanan, misalnya dari "Menunggu Konfirmasi" menjadi "Diproses".',
          ),
          const Divider(height: 32),
          _buildSectionHeader(context, 'Hubungi Kami'),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Kirim Email'),
            subtitle: const Text('support@sellersphere.com'),
            onTap: () {
              _launchEmailApp();
            },
          ),
          ListTile(
            leading: const Icon(Icons.message_outlined),
            title: const Text('Pusat Panggilan'),
            subtitle: const Text('0821-2968-545'),
            onTap: () {
              _launchMessageApp();
            },
          ),
        ],
      ),
    );
  }

  /// Widget helper untuk membuat header setiap bagian.
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Future<void> _launchMessageApp() async {
    // Contoh nomor tujuan (gunakan format internasional tanpa tanda +, contoh: 6281234567890)
    const String phoneNumber = '628212968545';
    const String message =
        'Halo, saya ingin bertanya mengenai layanan aplikasi.';

    // Membuat URI khusus untuk WhatsApp API
    final Uri whatsappUri = Uri.parse(
        'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');

    // Memeriksa apakah perangkat bisa membuka URL tersebut
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak dapat membuka aplikasi pesan ke $whatsappUri';
    }
  }

  Future<void> _launchEmailApp() async {
    // Tentukan alamat email tujuan, subjek, dan isi pesan default (opsional)
    final String encodeEmail = Uri.encodeComponent('support@domain.com');
    final String encodeSubject =
        Uri.encodeComponent('Bantuan Layanan Aplikasi');
    final String encodeBody =
        Uri.encodeComponent('Halo, saya membutuhkan bantuan terkait...');

    // Membuat URI khusus mailto
    final Uri emailUri = Uri.parse(
        'mailto:$encodeEmail?subject=$encodeSubject&body=$encodeBody');

    // Memeriksa apakah perangkat dapat membuka URI email tersebut
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Tidak dapat membuka aplikasi email.';
    }
  }
}

/// Widget kustom untuk menampilkan item FAQ yang bisa diperluas.
class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqTile({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          question,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(answer),
          ),
        ],
      ),
    );
  }
}

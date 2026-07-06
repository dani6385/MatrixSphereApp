import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:matrix_sphere_app/presentation/registration_screens/providers/registration_provider.dart';
import '../models/registration_models.dart'; // Impor ditambahkan

/// Halaman untuk menampilkan dan mengelola daftar pendaftaran mitra.
class SellerRegistrationListScreen extends ConsumerWidget {
  const SellerRegistrationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registrationProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pendaftaran Mitra'),
          actions: [
            // Tombol Refresh
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () =>
                  ref.read(registrationProvider.notifier).fetchRegistrations(),
            ),
            // Tombol Sort
            PopupMenuButton<SortType>(
              icon: const Icon(Icons.sort),
              onSelected: (sortType) => ref
                  .read(registrationProvider.notifier)
                  .updateSortType(sortType),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: SortType.dateNewest,
                  child: Text('Tanggal (Terbaru)'),
                ),
                const PopupMenuItem(
                  value: SortType.dateOldest,
                  child: Text('Tanggal (Terlama)'),
                ),
                const PopupMenuItem(
                  value: SortType.nameAsc,
                  child: Text('Nama (A-Z)'),
                ),
                const PopupMenuItem(
                  value: SortType.nameDesc,
                  child: Text('Nama (Z-A)'),
                ),
              ],
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Tertunda (${state.pendingSellers.length})'),
              Tab(text: 'Disetujui (${state.approvedSellers.length})'),
              Tab(text: 'Ditolak (${state.rejectedSellers.length})'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Cari nama toko atau email...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                onChanged: (query) => ref
                    .read(registrationProvider.notifier)
                    .updateSearchQuery(query),
              ),
            ),
            // Content
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.errorMessage != null
                      ? Center(child: Text(state.errorMessage!))
                      : TabBarView(
                          children: [
                            _RegistrationList(
                              sellers: state.pendingSellers,
                              status: RegistrationStatus.pending,
                            ),
                            _RegistrationList(
                              sellers: state.approvedSellers,
                              status: RegistrationStatus.approved,
                            ),
                            _RegistrationList(
                              sellers: state.rejectedSellers,
                              status: RegistrationStatus.rejected,
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget untuk menampilkan daftar pendaftaran berdasarkan status.
class _RegistrationList extends ConsumerWidget {
  final List<SellerRegistration> sellers;
  final RegistrationStatus status;

  const _RegistrationList({required this.sellers, required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (sellers.isEmpty) {
      return const Center(child: Text('Tidak ada data pendaftaran.'));
    }

    return ListView.builder(
      itemCount: sellers.length,
      itemBuilder: (context, index) {
        final seller = sellers[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  seller.partnerName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                if (seller.email != null)
                  Text(seller.email!,
                      style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Text(
                    'Tanggal Daftar: ${DateFormat.yMMMd().format(seller.registrationDate)}'),
                if (status == RegistrationStatus.rejected &&
                    seller.rejectionReason != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Alasan Ditolak: ${seller.rejectionReason}',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ],
                if (status == RegistrationStatus.pending) ...[
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () =>
                            _showRejectDialog(context, ref, seller.id),
                        style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.error),
                        child: const Text('Tolak'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        child: const Text('Setujui'),
                        onPressed: () => ref
                            .read(registrationProvider.notifier)
                            .approveSeller(seller.id),
                      ),
                    ],
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRejectDialog(
      BuildContext context, WidgetRef ref, String sellerId) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Tolak Pendaftaran'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Berikan alasan penolakan (opsional).'),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: 'Alasan',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: () {
                ref
                    .read(registrationProvider.notifier)
                    .rejectSeller(sellerId, reasonController.text);
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Kirim Penolakan'),
            ),
          ],
        );
      },
    );
  }
}

class SellerRegistrationListRoute extends StatelessWidget {
  const SellerRegistrationListRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return const SellerRegistrationListScreen();
  }
}

/*
  CATATAN:

  Untuk menggunakan halaman ini, Anda perlu menambahkannya ke GoRouter.
  Contoh di file router Anda:

  GoRoute(
    path: '/seller-registrations',
    builder: (context, state) => const SellerRegistrationListRoute(),
  ),

  Pastikan juga Anda sudah menginisialisasi Firebase di aplikasi Anda
  dan memiliki data di koleksi 'seller_registrations' agar daftar
  ini tidak kosong. Anda bisa menggunakan 'register_seller_screen.dart'
  untuk menambahkan data baru.
*/

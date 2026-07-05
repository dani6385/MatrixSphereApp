import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'providers/registration_provider.dart';
import 'package:matrix_sphere_app/presentation/registration_screens/detail/seller_registration_detail_screen.dart';
class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() { 
      ref.read(registrationProvider.notifier).updateSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showRejectionDialog(SellerRegistration seller) async {
    final reasonController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final reason = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tolak Pendaftaran ${seller.partnerName}?'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: reasonController,
            decoration: const InputDecoration(
              labelText: 'Alasan Penolakan',
              hintText: 'Masukkan alasan penolakan...',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Alasan tidak boleh kosong';
              }
              return null;
            },
            maxLines: 3,
            autofocus: true,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(context).pop(reasonController.text);
              }
            },
            child: const Text('Tolak'),
          ),
        ],
      ),
    );

    if (reason != null && reason.isNotEmpty) {
      ref.read(registrationProvider.notifier).rejectSeller(seller.id, reason);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${seller.partnerName} ditolak.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final regState = ref.watch(registrationProvider);
    final regNotifier = ref.read(registrationProvider.notifier);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manajemen Pendaftaran'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            PopupMenuButton<SortType>(
              icon: const Icon(Icons.sort),
              onSelected: (sortType) => regNotifier.updateSortType(sortType),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<SortType>>[
                const PopupMenuItem<SortType>( // Corrected: Removed 'registration_provider.'
                  value: SortType.dateNewest,
                  child: Text('Tanggal (Terbaru)'),
                ),
                const PopupMenuItem<SortType>( // Corrected: Removed 'registration_provider.'
                  value: SortType.dateOldest,
                  child: Text('Tanggal (Terlama)'),
                ),
                const PopupMenuItem<SortType>( // Corrected: Removed 'registration_provider.'
                  value: SortType.nameAsc,
                  child: Text('Nama (A-Z)'),
                ),
                const PopupMenuItem<SortType>(
                  value: SortType.nameDesc,
                  child: Text('Nama (Z-A)'),
                ),
              ],
            )
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari nama atau email...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.zero,
                      suffixIcon: regState.searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => _searchController.clear(),
                            )
                          : null,
                    ),
                  ),
                ),
                const TabBar(
                  isScrollable: true,
                  tabs: [
                    Tab(text: 'Menunggu Persetujuan'),
                    Tab(text: 'Disetujui'),
                    Tab(text: 'Ditolak'),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
 _buildSellerList(regState.pendingSellers, status: RegistrationStatus.pending),
 _buildSellerList(regState.approvedSellers, status: RegistrationStatus.approved),
 _buildSellerList(regState.rejectedSellers, status: RegistrationStatus.rejected),
          ],
        ),
      ),
    );
  }

  Widget _buildSellerList(List<SellerRegistration> sellers, {required RegistrationStatus status}) {
    if (sellers.isEmpty) { 
      return Center(
        child: Text(
          'Tidak ada pendaftar di kategori ini.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return ListView.builder(
      itemCount: sellers.length,
      itemBuilder: (context, index) {
        final seller = sellers[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.storefront_outlined),
            title: Text(seller.partnerName), 
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mendaftar pada: ${DateFormat.yMMMd().format(seller.registrationDate)}'),
                if (seller.rejectionReason != null) Text('Alasan: ${seller.rejectionReason}', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
            ),
            trailing: _buildTrailingWidget(context, seller, status),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SellerRegistrationDetailScreen(
                    seller: seller, // Assuming SellerRegistrationDetailScreen expects a SellerRegistration object
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget? _buildTrailingWidget(BuildContext context, SellerRegistration seller, RegistrationStatus status) {
    switch (status) {
      case RegistrationStatus.pending:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton( 
              onPressed: () {
                ref.read(registrationProvider.notifier).approveSeller(seller.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${seller.partnerName} disetujui.')),
                );
              },
              child: const Text('Setujui'),
            ),
            TextButton(
              onPressed: () {
                _showRejectionDialog(seller);
              },
              child: Text('Tolak', style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          ],
        );
      case RegistrationStatus.approved:
        return const Icon(Icons.check_circle, color: Colors.green);
      case RegistrationStatus.rejected:
        return Icon(Icons.cancel, color: Theme.of(context).colorScheme.error);
      }
  }
}

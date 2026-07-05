import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/registration_provider.dart';


class SellerRegistrationDetailScreen extends ConsumerWidget {
  final SellerRegistration seller;

  const SellerRegistrationDetailScreen({
    super.key,
    required this.seller,
  });

  Future<void> _showRejectionDialog(BuildContext context, WidgetRef ref) async {
    final reasonController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(dialogContext).pop(reasonController.text);
              }
            },
            child: const Text('Tolak'),
          ),
        ],
      ),
    );

    if (reason != null && reason.isNotEmpty) {
      ref.read(registrationProvider.notifier).rejectSeller(seller.id, reason);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${seller.partnerName} ditolak.')),
        );
        Navigator.of(context).pop(); // Kembali ke layar sebelumnya
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pendaftaran'),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem(context, 'Nama Partner', seller.partnerName),
            _buildDetailItem(context, 'Nama Pemilik', seller.ownerName ?? 'Tidak tersedia'),
            _buildDetailItem(context, 'No. Telepon', seller.phone ?? 'Tidak tersedia'),
            _buildDetailItem(context, 'Alamat', seller.address ?? 'Tidak tersedia'),
            _buildDetailItem(context, 'Email', seller.email ?? 'Tidak tersedia'),
            _buildDetailItem(context, 'Tanggal Daftar', DateFormat.yMMMMd('id_ID').add_jm().format(seller.registrationDate)),
            _buildDetailItem(context, 'Status', seller.status.name),
            if (seller.rejectionReason != null)
              _buildDetailItem(context, 'Alasan Penolakan', seller.rejectionReason!, isError: true),
          ],
        ),
      ),
      bottomNavigationBar: seller.status == RegistrationStatus.pending
          ? _buildActionButtons(context, ref)
          : null,
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value, {bool isError = false}) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.labelLarge?.copyWith(color: textTheme.bodySmall?.color)),
          const SizedBox(height: 4),
          Text(value, style: textTheme.titleMedium?.copyWith(color: isError ? Theme.of(context).colorScheme.error : null)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showRejectionDialog(context, ref),
                style: OutlinedButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
                child: const Text('Tolak'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ref.read(registrationProvider.notifier).approveSeller(seller.id);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${seller.partnerName} disetujui.')));
                  Navigator.of(context).pop();
                },
                child: const Text('Setujui'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
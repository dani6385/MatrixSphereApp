import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/approval_request.dart';
import '../viewmodels/app_view_model.dart';


class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({super.key});

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppViewModel>(context);
    final allRequests = viewModel.approvalRequests;
    final pendingRequests = allRequests.where((r) => r.status == "Menunggu").toList();
    final historyRequests = allRequests.where((r) => r.status != "Menunggu").toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight - 20),
            _StatsBanners(pendingCount: pendingRequests.length, approvedCount: historyRequests.where((r)=> r.status == "Disetujui").length),
            const SizedBox(height: 12),
            _buildTabs(pendingRequests.length, historyRequests.length),
             const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _RequestList(requests: pendingRequests, isHistory: false),
                  _RequestList(requests: historyRequests, isHistory: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs(int pendingCount, int historyCount) {
    return TabBar(
      controller: _tabController,
      tabs: [
        Tab(text: "Menunggu ($pendingCount)"),
        Tab(text: "Riwayat ($historyCount)"),
      ],
       labelStyle: const TextStyle(fontWeight: FontWeight.bold),
       unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
    );
  }
}

class _StatsBanners extends StatelessWidget {
  final int pendingCount;
  final int approvedCount;

  const _StatsBanners({required this.pendingCount, required this.approvedCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatCard(count: pendingCount, label: "Menunggu Tindakan", color: Theme.of(context).colorScheme.primary)),
        const SizedBox(width: 12),
        Expanded(child: _StatCard(count: approvedCount, label: "Total Disetujui", color: const Color(0xFF26A69A))),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final int count;
  final String label;
  final Color color;

  const _StatCard({required this.count, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withAlpha(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: color.withAlpha(2)),
      ),
      elevation: 0,
      child: SizedBox(
        height: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(count.toString(), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: color)),
            Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

class _RequestList extends StatelessWidget {
  final List<ApprovalRequest> requests;
  final bool isHistory;

  const _RequestList({required this.requests, required this.isHistory});

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      final icon = isHistory ? Icons.history : Icons.done_all;
      final message = isHistory ? "Riwayat permintaan masih kosong" : "Selesai! Tidak ada permintaan tertunda";
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 8),
            Text(message, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: requests.length,
      itemBuilder: (context, index) => _ApprovalRowItem(request: requests[index], isHistory: isHistory),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }
}

class _ApprovalRowItem extends StatelessWidget {
  final ApprovalRequest request;
  final bool isHistory;

  const _ApprovalRowItem({required this.request, required this.isHistory});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppViewModel>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;
    final tealColor = const Color(0xFF26A69A);

    IconData iconData;
    Color iconColor;

    switch (request.title) {
      case "Pendaftaran Seller Baru":
        iconData = Icons.person_add_alt;
        iconColor = colorScheme.primary;
        break;
      case "Permintaan Buka Blokir":
        iconData = Icons.lock_open;
        iconColor = colorScheme.error;
        break;
      default:
        iconData = Icons.cloud_queue;
        iconColor = tealColor;
    }

    return Card(
        elevation: 1,
        shadowColor: Colors.black.withAlpha(1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.surfaceContainerHighest),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [ 
                     CircleAvatar(
                      radius: 18,
                      backgroundColor: iconColor.withAlpha(15),
                      child: Icon(iconData, color: iconColor, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(request.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                        Text("Pemohon: ${request.requesterName}", style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),   
                  ],),
                   Text(
                      DateFormat("HH:mm dd MMM").format(request.timestamp.toLocal()),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, color: colorScheme.onSurfaceVariant),
                    ),
                 
                ],
              ),
              const SizedBox(height: 12),
              Text(request.details, maxLines: 3, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 16),
              if (isHistory)
                _buildHistoryStatus(context, tealColor, colorScheme)
              else
                _buildActionButtons(context, viewModel, tealColor, colorScheme),
            ],
          ),
        ));
  }

  Widget _buildActionButtons(BuildContext context, AppViewModel viewModel, Color tealColor, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => viewModel.rejectRequest(request.id),
            icon: const Icon(Icons.close, size: 16), 
            label: const Text("Tolak"),
            style: OutlinedButton.styleFrom(
              foregroundColor: colorScheme.error,
              side: BorderSide(color: colorScheme.error),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => viewModel.approveRequest(request.id),
            icon: const Icon(Icons.check, size: 16), 
            label: const Text("Setujui"),
            style: ElevatedButton.styleFrom(
              backgroundColor: tealColor,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryStatus(BuildContext context, Color tealColor, ColorScheme colorScheme) {
    final isApproved = request.status == "Disetujui";
    final statusColor = isApproved ? tealColor : colorScheme.error;
    final statusIcon = isApproved ? Icons.check_circle : Icons.cancel;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: statusColor.withAlpha(15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(statusIcon, color: statusColor, size: 14),
            const SizedBox(width: 4),
            Text(
              request.status.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: statusColor),
            ),
          ],
        ),
      ),
    );
  }
}

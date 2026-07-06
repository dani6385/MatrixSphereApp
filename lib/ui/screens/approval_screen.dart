import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ApprovalScreen extends StatelessWidget {
  const ApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppViewModel>(context);
    final approvalRequests = viewModel.approvalRequests;

    final pendingRequests = approvalRequests.where((request) => request.status == "Menunggu").toList();
    final historyRequests = approvalRequests.where((request) => request.status != "Menunggu").toList();

    return ChangeNotifierProvider(
      create: (_) => TabState(),
      child: Consumer<TabState>(
        builder: (context, tabState, child) {
          return Column(
            children: [
              // Upper stats banner
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 0,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                            width: 1.0,
                          ),
                        ),
                        child: SizedBox(
                          height: 64,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${pendingRequests.length}",
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                Text(
                                  "Menunggu Tindakan",
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Card(
                        elevation: 0,
                        color: const Color(0xFF4DB6AC).withOpacity(0.08),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: const Color(0xFF4DB6AC).withOpacity(0.2),
                            width: 1.0,
                          ),
                        ),
                        child: SizedBox(
                          height: 64,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${historyRequests.where((request) => request.status == "Disetujui").length}",
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF4DB6AC),
                                  ),
                                ),
                                Text(
                                  "Total Disetujui",
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Selection Tab Row
              TabBar(
                controller: tabState.tabController,
                tabs: [
                  Tab(
                    child: Text(
                      "Menunggu (${pendingRequests.length})",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Riwayat (${historyRequests.length})",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                indicatorColor: Theme.of(context).colorScheme.primary,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
              ),

              // Selected requests lists
              Expanded(
                child: TabBarView(
                  controller: tabState.tabController,
                  children: [
                    if (pendingRequests.isEmpty)
                      const Center(child: Text("No pending requests"))
                    else
                      ListView.builder(
                        itemCount: pendingRequests.length,
                        itemBuilder: (context, index) {
                          return ApprovalRequestItem(request: pendingRequests[index]);
                        },
                      ),
                    if (historyRequests.isEmpty)
                      const Center(child: Text("No history requests"))
                    else
                      ListView.builder(
                        itemCount: historyRequests.length,
                        itemBuilder: (context, index) {
                          return ApprovalRequestItem(request: historyRequests[index]);
                        },
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class TabState with ChangeNotifier {
  late TabController tabController;

  void init(TickerProvider vsync, int length) {
    tabController = TabController(length: length, vsync: vsync);
    tabController.addListener(notifyListeners);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}

class ApprovalRequestItem extends StatelessWidget {
  final ApprovalRequest request;

  const ApprovalRequestItem({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    // Implement your request item UI here
    return Card(
      child: ListTile(
        title: Text(request.title),
        subtitle: Text(DateFormat('dd MMM yyyy').format(request.date)),
        trailing: Text(request.status),
      ),
    );
  }
}

// Example ViewModel and ApprovalRequest classes
class AppViewModel with ChangeNotifier {
  List<ApprovalRequest> approvalRequests = [];

  // Add methods to update approvalRequests as needed
}

class ApprovalRequest {
  final String title;
  final String status;
  final DateTime date;

  ApprovalRequest({
    required this.title,
    required this.status,
    required this.date,
  });
}


import 'package:flutter/foundation.dart';
import 'package:shared_services/shared_services.dart';

enum ApprovalStatus { pending, approved, rejected }

class ApprovalItem {
  final String id;
  final String title;
  final String subtitle;
  final ApprovalStatus status;

  ApprovalItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.status,
  });

  factory ApprovalItem.fromMap(String id, Map<dynamic, dynamic> data) {
    return ApprovalItem(
      id: id,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      status: ApprovalStatus.values.firstWhere((e) => e.toString() == 'ApprovalStatus.${data['status']}', orElse: () => ApprovalStatus.pending),
    );
  }
}

class ApprovalProvider with ChangeNotifier {
  final RtdbService _rtdbService = RtdbService();
  List<ApprovalItem> _items = [];

  ApprovalProvider() {
    _rtdbService.getApprovalsStream().listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        _items = data.entries.map((e) => ApprovalItem.fromMap(e.key, e.value)).toList();
        notifyListeners();
      }
    });
  }

  List<ApprovalItem> get items => _items;
  List<ApprovalItem> get pendingItems => _items.where((item) => item.status == ApprovalStatus.pending).toList();

  Future<void> approve(String id) {
    return _rtdbService.updateApprovalStatus(id, 'approved');
  }

  Future<void> reject(String id) {
    return _rtdbService.updateApprovalStatus(id, 'rejected');
  }
}

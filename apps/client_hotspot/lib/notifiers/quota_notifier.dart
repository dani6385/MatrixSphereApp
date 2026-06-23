
import 'package:flutter/foundation.dart';
import '../models/user_quota_model.dart';
import '../services/rtdb_service.dart';

class QuotaNotifier extends ChangeNotifier {
  final RtdbService _rtdbService = RtdbService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<UserQuota> _userQuotas = [];
  List<UserQuota> get userQuotas => _userQuotas;

  // --- REFACTOR: fetchQuotas sekarang membutuhkan mikrotikId ---
  Future<void> fetchQuotas({required String mikrotikId}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _userQuotas = await _rtdbService.getQuotas(mikrotikId: mikrotikId);
    } catch (e) {
      debugPrint("Error fetching quotas for Mikrotik ID $mikrotikId: $e");
      _userQuotas = []; // Kosongkan data jika ada error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

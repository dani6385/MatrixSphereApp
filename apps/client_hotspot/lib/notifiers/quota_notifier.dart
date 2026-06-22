
import 'package:flutter/foundation.dart';
import '../models/user_quota_model.dart'; // <- Ganti ke model yang benar
import '../services/rtdb_service.dart';

class QuotaNotifier extends ChangeNotifier {
  final RtdbService _rtdbService = RtdbService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<UserQuota> _userQuotas = [];
  List<UserQuota> get userQuotas => _userQuotas;

  Future<void> fetchQuotas() async {
    _isLoading = true;
    notifyListeners();

    try {
      _userQuotas = await _rtdbService.getQuotas();
    } catch (e) {
      debugPrint("Error fetching quotas: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

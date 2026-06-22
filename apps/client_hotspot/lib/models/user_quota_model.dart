
import 'quota_model.dart';

class UserQuota {
  final String userId;
  final List<Quota> quotas;

  UserQuota({required this.userId, required this.quotas});
}

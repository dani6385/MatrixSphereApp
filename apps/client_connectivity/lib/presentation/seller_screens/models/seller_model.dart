class Seller {
  final String initial;
  final String name;
  final String store;
  final String email;
  final String phone;
  final String status;
  final String? reason;
  final bool isBanned;

  Seller({
    required this.initial,
    required this.name,
    required this.store,
    required this.email,
    required this.phone,
    required this.status,
    this.reason,
    this.isBanned = false,
  });
}

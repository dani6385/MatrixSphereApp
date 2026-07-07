class UserProfile {
  final String id;
  final String username;
  final String fullName;
  final String email;
  final String phone;
  final String passwordHash;
  final bool isTwoFactorEnabled;

  UserProfile({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.passwordHash,
    required this.isTwoFactorEnabled,
  });
}

class AppControl {
  final String appName;
  final String appCategory;
  final String appIdentifier;
  final int usage;
  final int limit;
  final bool isActive;

  AppControl({
    required this.appName,
    required this.appCategory,
    required this.appIdentifier,
    required this.usage,
    required this.limit,
    required this.isActive,
  });
}

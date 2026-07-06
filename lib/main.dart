import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Models
class Notification {
  final String id;
  final bool isRead;

  Notification({required this.id, required this.isRead});
}

// ViewModel
class AppViewModel extends ChangeNotifier {
  final AppRepository repository;
  bool _isLoggedIn = false;
  List<Notification> _notifications = [];

  AppViewModel(this.repository);

  bool get isLoggedIn => _isLoggedIn;
  List<Notification> get notifications => _notifications;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void addNotification(Notification notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }
}

// Repository
class AppRepository {
  final AppDao appDao;
  AppRepository(this.appDao);
}

// DAO
class AppDao {
  // Database operations would go here
}

// Database
class AppDatabase {
  static AppDatabase? _instance;
  final AppDao appDao = AppDao();

  AppDatabase._();
  static AppDatabase getDatabase() {
    _instance ??= AppDatabase._();
    return _instance!;
  }
}

// ViewModel Factory
class AppViewModelFactory {
  static AppViewModel create(AppRepository repository) {
    return AppViewModel(repository);
  }
}

// Main App
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          tertiary: const Color(0xFF4DB6AC),
        ),
        useMaterial3: true,
      ),
      home: const MainActivity(),
    );
  }
}

class MainActivity extends ConsumerStatefulWidget {
  const MainActivity({super.key});

  @override
  ConsumerState<MainActivity> createState() => _MainActivityState();
}

class _MainActivityState extends ConsumerState<MainActivity> {
  @override
  Widget build(BuildContext context) {
    // Initialize Database and Repository
    final database = AppDatabase.getDatabase();
    final repository = AppRepository(database.appDao);
    final appViewModel = AppViewModelFactory.create(repository);

    return ListenableBuilder(
      listenable: appViewModel,
      builder: (context, _) {
        if (!appViewModel.isLoggedIn) {
          return LoginScreen(viewModel: appViewModel);
        } else {
          return MainAppScaffold(viewModel: appViewModel);
        }
      },
    );
  }
}

enum MainTab { home, notifications, settings }

class MainAppScaffold extends ConsumerStatefulWidget {
  final AppViewModel viewModel;

  const MainAppScaffold({super.key, required this.viewModel});

  @override
  ConsumerState<MainAppScaffold> createState() => _MainAppScaffoldState();
}

class _MainAppScaffoldState extends ConsumerState<MainAppScaffold> {
  MainTab selectedTab = MainTab.home;
  Notification? activeNotification;

  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_handleNotifications);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_handleNotifications);
    super.dispose();
  }

  void _handleNotifications() {
    final notifications = widget.viewModel.notifications;
    final latestUnread = notifications.firstWhere(
      (n) => !n.isRead,
      orElse: () => Notification(id: '', isRead: true),
    );

    if (latestUnread.id.isNotEmpty &&
        latestUnread.id != activeNotification?.id) {
      setState(() {
        activeNotification = latestUnread;
      });

      // Dismiss automatically after 4 seconds
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) {
          setState(() {
            activeNotification = null;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: _buildBody(),
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedTab.index,
            onDestinationSelected: (index) {
              setState(() {
                selectedTab = MainTab.values[index];
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.notifications_outlined),
                selectedIcon: Icon(Icons.notifications),
                label: 'Alerts',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "GUARDIAN CONSOLE",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                        letterSpacing: 1.5,
                      ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.shield,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "SecurApp Admin",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (activeNotification != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + kToolbarHeight,
            left: 16,
            right: 16,
            child: _buildNotificationBanner(activeNotification!),
          ),
      ],
    );
  }

  Widget _buildBody() {
    switch (selectedTab) {
      case MainTab.home:
        return const HomeScreen();
      case MainTab.notifications:
        return const NotificationsScreen();
      case MainTab.settings:
        return const SettingsScreen();
    }
  }

  Widget _buildNotificationBanner(Notification notification) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "New Alert",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Security alert requires your attention",
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  activeNotification = null;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder screens
class LoginScreen extends StatelessWidget {
  final AppViewModel viewModel;

  const LoginScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => viewModel.login(),
          child: const Text("Login"),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Home Screen"));
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Notifications Screen"));
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Settings Screen"));
  }
}
import 'package:flutter/material.dart';
import 'package:admin_dashboard/login_page.dart'; // Import LoginPage
import 'package:shared_services/shared_services.dart'; // Import MikrotikService
import 'dart:async'; // Required for Timer
import 'package:package_info_plus/package_info_plus.dart'; // For app version
import 'package:device_info_plus/device_info_plus.dart'; // For device info
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:admin_dashboard/reset_password_dialog.dart'; // Assume this dialog is created separately

// --- Placeholder Screens ---

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
      'Home Screen',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ));
  }
}

// --- Management Screen with Tabs ---
class ManagementScreen extends StatefulWidget {
  const ManagementScreen({super.key});

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  // Controllers and keys for Add User/Voucher form
  final _memberFormKey = GlobalKey<FormState>();
  final _voucherFormKey = GlobalKey<FormState>();
  final _memberUsernameController = TextEditingController();
  final _memberPasswordController = TextEditingController();
  final _voucherUsernameController = TextEditingController(); // For voucher association
  final _voucherPasswordController = TextEditingController();
  bool _isAddingUserOrVoucher = false;

  // MikrotikService instance
  final MikrotikService _mikrotikService = MikrotikService();

  // State for viewing users and vouchers
  List<Map<String, String>> _users = [];
  List<Map<String, String>> _vouchers = []; // Assuming vouchers can be listed like this
  bool _isLoadingUsers = false;
  bool _isLoadingVouchers = false;
  String? _managementErrorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _fetchVouchers();
  }

  @override
  void dispose() {
    _memberUsernameController.dispose();
    _memberPasswordController.dispose();
    _voucherUsernameController.dispose();
    _voucherPasswordController.dispose();
    try {
      _mikrotikService.dispose();
    } catch (e) {
      print("Error disposing MikrotikService in ManagementScreen: $e");
    }
    super.dispose();
  }

  Future<void> _addUser() async {
    if (_memberFormKey.currentState!.validate()) {
      setState(() {
        _isAddingUserOrVoucher = true;
        _managementErrorMessage = null;
      });
      try {
        print('Simulating adding user: ${_memberUsernameController.text}');
        await Future.delayed(const Duration(seconds: 1));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User added successfully!')));
        _memberUsernameController.clear();
        _memberPasswordController.clear();
        _memberFormKey.currentState?.reset();
        _fetchUsers();
      } catch (e) {
        setState(() { _managementErrorMessage = 'Failed to add user: ${e.toString()}'; });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding user: ${e.toString()}')));
      } finally {
        setState(() { _isAddingUserOrVoucher = false; });
      }
    }
  }

  Future<void> _createVoucher() async {
    if (_voucherFormKey.currentState!.validate()) {
      setState(() {
        _isAddingUserOrVoucher = true;
        _managementErrorMessage = null;
      });
      try {
        await _mikrotikService.createVoucher(
          _voucherUsernameController.text.trim(),
          _voucherPasswordController.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Voucher created successfully!')));
        _voucherUsernameController.clear();
        _voucherPasswordController.clear();
        _voucherFormKey.currentState?.reset();
        _fetchVouchers();
      } catch (e) {
        setState(() { _managementErrorMessage = 'Failed to create voucher: ${e.toString()}'; });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error creating voucher: ${e.toString()}')));
      } finally {
        setState(() { _isAddingUserOrVoucher = false; });
      }
    }
  }

  Future<void> _fetchUsers() async {
    setState(() { _isLoadingUsers = true; _managementErrorMessage = null; });
    try {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _users = [
          {'id': '1', 'username': 'user1', 'status': 'Active'},
          {'id': '2', 'username': 'user2', 'status': 'Inactive'},
        ];
        _isLoadingUsers = false;
      });
    } catch (e) {
      setState(() {
        _managementErrorMessage = 'Failed to load users: ${e.toString()}';
        _isLoadingUsers = false;
      });
    }
  }

  Future<void> _fetchVouchers() async {
    setState(() { _isLoadingVouchers = true; _managementErrorMessage = null; });
    try {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _vouchers = [
          {'code': 'VOUCH001', 'user': 'user1', 'expiry': '2024-12-31'},
          {'code': 'VOUCH002', 'user': 'user2', 'expiry': '2024-11-30'},
        ];
        _isLoadingVouchers = false;
      });
    } catch (e) {
      setState(() {
        _managementErrorMessage = 'Failed to load vouchers: ${e.toString()}';
        _isLoadingVouchers = false;
      });
    }
  }

  Future<void> _deleteUser(String userId, String username) async {
    print('Deleting user: $username (ID: $userId)');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete user $username... (not implemented)')));
  }

  Future<void> _deleteVoucher(String voucherCode) async {
    print('Deleting voucher: $voucherCode');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete voucher $voucherCode... (not implemented)')));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Management'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginPage()), (Route<dynamic> route) => false);
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person_add), text: 'Add'),
              Tab(icon: Icon(Icons.group), text: 'Users'),
              Tab(icon: Icon(Icons.redeem), text: 'Vouchers'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // --- Add Tab ---
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Add New User', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  Form(
                    key: _memberFormKey,
                    child: Column(
                      children: [
                        TextFormField(controller: _memberUsernameController, decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()), validator: (value) { if (value == null || value.isEmpty) return 'Please enter a username'; return null; }),
                        const SizedBox(height: 16),
                        TextFormField(controller: _memberPasswordController, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()), obscureText: true, validator: (value) { if (value == null || value.isEmpty) return 'Please enter a password'; return null; }),
                        const SizedBox(height: 24),
                        _isAddingUserOrVoucher ? const Center(child: CircularProgressIndicator()) : ElevatedButton.icon(icon: const Icon(Icons.person_add), label: const Text('Add User'), onPressed: _addUser, style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), minimumSize: const Size(double.infinity, 40))),
                      ],
                    ),
                  ),
                  const Divider(height: 40),
                  Text('Create Voucher', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  Form(
                    key: _voucherFormKey,
                    child: Column(
                      children: [
                        TextFormField(controller: _voucherUsernameController, decoration: const InputDecoration(labelText: 'Associated Username (Optional)', border: OutlineInputBorder())),
                        const SizedBox(height: 16),
                        TextFormField(controller: _voucherPasswordController, decoration: const InputDecoration(labelText: 'Voucher Code / Password', border: OutlineInputBorder()), obscureText: true, validator: (value) { if (value == null || value.isEmpty) return 'Please enter voucher code/password'; return null; }),
                        const SizedBox(height: 24),
                        _isAddingUserOrVoucher ? const Center(child: CircularProgressIndicator()) : ElevatedButton.icon(icon: const Icon(Icons.redeem), label: const Text('Create Voucher'), onPressed: _createVoucher, style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), minimumSize: const Size(double.infinity, 40))),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- Users Tab ---
            _isLoadingUsers ? const Center(child: CircularProgressIndicator()) : _users.isEmpty ? const Center(child: Text('No users found.')) : Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ Text('Existing Users', style: Theme.of(context).textTheme.headlineSmall), const SizedBox(height: 16), Expanded(child: ListView.builder( itemCount: _users.length, itemBuilder: (context, index) { final user = _users[index]; return Card( margin: const EdgeInsets.symmetric(vertical: 4.0), child: ListTile( leading: const Icon(Icons.person), title: Text(user['username'] ?? 'N/A'), subtitle: Text('Status: ${user['status'] ?? 'Unknown'}'), trailing: Row( mainAxisSize: MainAxisSize.min, children: [ IconButton(icon: const Icon(Icons.edit, color: Colors.blue), tooltip: 'Edit User', onPressed: () { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Edit user ${user['username']} (not implemented)'))); }, ), IconButton(icon: const Icon(Icons.delete, color: Colors.red), tooltip: 'Delete User', onPressed: () => _deleteUser(user['id']!, user['username']!), ), ], ), ), ); }, ), ), ], ), ),

            // --- Vouchers Tab ---
            _isLoadingVouchers ? const Center(child: CircularProgressIndicator()) : _vouchers.isEmpty ? const Center(child: Text('No vouchers found.')) : Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ Text('Existing Vouchers', style: Theme.of(context).textTheme.headlineSmall), const SizedBox(height: 16), Expanded(child: ListView.builder( itemCount: _vouchers.length, itemBuilder: (context, index) { final voucher = _vouchers[index]; return Card( margin: const EdgeInsets.symmetric(vertical: 4.0), child: ListTile( leading: const Icon(Icons.redeem), title: Text(voucher['code'] ?? 'N/A'), subtitle: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [ if (voucher['user'] != null && voucher['user']!.isNotEmpty) Text('User: ${voucher['user']}'), if (voucher['expiry'] != null) Text('Expiry: ${voucher['expiry']}'), ], ), trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), tooltip: 'Delete Voucher', onPressed: () => _deleteVoucher(voucher['code']!), ), ), ); }, ), ), ], ), ),
          ],
        ),
      ),
    );
  }
}

// --- Profile Screen ---
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.onMikrotikIpChange});
  final Function(String)? onMikrotikIpChange;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _appVersion = 'Loading...';
  String _deviceInfo = 'Loading...';
  String _networkInfo = 'Not Connected';
  String? _mikrotikConnectedIp;

  // Controllers for package creation
  final _packageNameController = TextEditingController();
  final _packageDescriptionController = TextEditingController();
  final _packageDurationController = TextEditingController();
  final _packageDurationUnitController = TextEditingController(text: 'days'); // Default to 'days'
  final _packageFormKey = GlobalKey<FormState>();
  bool _isCreatingPackage = false;
  List<Map<String, String>> _createdPackages = []; // To display created packages

  @override
  void initState() {
    super.initState();
    _loadProfileInfo();
    _loadMikrotikConnectionInfo();
    _fetchCreatedPackages();
  }

  Future<void> _loadProfileInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() { _appVersion = packageInfo.version; });
    } catch (e) {
      setState(() { _appVersion = 'Error loading version'; });
    }

    String deviceDetails = '';
    try {
      final deviceInfoPlugin = DeviceInfoPlugin();
      if (kIsWeb) {
        final WebBrowserInfo webInfo = await deviceInfoPlugin.webBrowserInfo;
        deviceDetails = "Browser: ${webInfo.browserName}, Vendor: ${webInfo.vendor}";
      } else {
        final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        deviceDetails = "Device: ${androidInfo.model} (Brand: ${androidInfo.brand ?? 'N/A'}), OS: ${androidInfo.version.release} (SDK ${androidInfo.version.sdkInt})";
      }
      setState(() { _deviceInfo = deviceDetails; });
    } catch (e) {
      setState(() { _deviceInfo = 'Error loading device info: ${e.toString()}'; });
    }
  }

  void _loadMikrotikConnectionInfo() {
     final mockMikrotikIp = '192.168.1.1';
     setState(() {
       _networkInfo = 'Mikrotik IP: $mockMikrotikIp (Placeholder)';
       _mikrotikConnectedIp = mockMikrotikIp;
     });
     if (widget.onMikrotikIpChange != null && mockMikrotikIp != null) {
       widget.onMikrotikIpChange!(mockMikrotikIp);
     }
  }

  // --- Package Creation Logic ---
  Future<void> _createPackage() async {
    if (_packageFormKey.currentState!.validate()) {
      setState(() { _isCreatingPackage = true; });

      try {
        final packageName = _packageNameController.text.trim();
        final packageDescription = _packageDescriptionController.text.trim();
        final durationValue = int.tryParse(_packageDurationController.text.trim());
        final durationUnit = _packageDurationUnitController.text.trim().toLowerCase();

        if (durationValue == null || durationValue <= 0) {
          throw Exception('Invalid duration value. Please enter a positive number.');
        }

        // Basic pluralization for duration string
        String formattedDurationUnit = durationValue == 1 ? durationUnit.replaceAll('s', '') : durationUnit;
        if (!formattedDurationUnit.endsWith('s') && durationValue != 1) {
            formattedDurationUnit += 's';
        } else if (formattedDurationUnit.endsWith('s') && durationValue == 1) {
            formattedDurationUnit = formattedDurationUnit.substring(0, formattedDurationUnit.length - 1);
        }

        String durationString = "$durationValue $formattedDurationUnit";

        // TODO: Implement actual package creation using MikrotikService or another backend
        print('Creating package: $packageName, Desc: $packageDescription, Duration: $durationString');
        await Future.delayed(const Duration(seconds: 1)); // Simulate network call

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Package created successfully!')),
        );

        _packageNameController.clear();
        _packageDescriptionController.clear();
        _packageDurationController.clear();
        _packageDurationUnitController.text = 'days'; // Reset to default
        _packageFormKey.currentState?.reset();
        _fetchCreatedPackages();

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create package: ${e.toString()}')),
        );
      } finally {
        setState(() { _isCreatingPackage = false; });
      }
    }
  }

  // Fetch created packages (placeholder)
  Future<void> _fetchCreatedPackages() async {
     await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
     setState(() {
       _createdPackages = [
         {'name': '1 Day Pass', 'description': '24 hours access', 'duration': '1 day'},
         {'name': '1 Week Pass', 'description': '7 days access', 'duration': '7 days'},
         {'name': '1 Month Pass', 'description': '30 days access', 'duration': '30 days'},
       ];
     });
  }

  void _showPasswordResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return ResetPasswordDialog(
          onResetPassword: (String newPassword) async {
            print('Attempting to reset password to: $newPassword');
            await Future.delayed(const Duration(seconds: 2));
            ScaffoldMessenger.of(dialogContext).showSnackBar(
              const SnackBar(content: Text('Password reset initiated. Check your email or follow further instructions.')),
            );
            Navigator.of(dialogContext).pop();
            return true;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Packages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Device Information Section ---
              Text('Device Information', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_networkInfo, style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      const Text('MAC Address: Not Directly Accessible (Privacy)', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- Application Information Section ---
              Text('Application Information', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('App Version: $_appVersion', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('Device Info: $_deviceInfo', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // --- Package Creation Section ---
              Text('Create Service Package', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              Form(
                key: _packageFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _packageNameController,
                      decoration: const InputDecoration(labelText: 'Package Name', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter a package name';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _packageDescriptionController,
                      decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _packageDurationController,
                            decoration: const InputDecoration(labelText: 'Duration Value', border: OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Enter duration';
                              if (int.tryParse(value) == null || int.parse(value) <= 0) return 'Enter a valid number > 0';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _packageDurationUnitController.text, // Use the controller's value
                            decoration: const InputDecoration(labelText: 'Duration Unit', border: OutlineInputBorder()),
                            items: ['days', 'weeks', 'months'].map((String unit) {
                              return DropdownMenuItem<String>(
                                value: unit,
                                child: Text(unit),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _packageDurationUnitController.text = newValue;
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Select a unit';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _isCreatingPackage
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton.icon(
                            icon: const Icon(Icons.add_circle_outline),
                            label: const Text('Create Package'),
                            onPressed: _createPackage,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                          ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // --- Display Created Packages ---
              Text('Existing Service Packages', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              _createdPackages.isEmpty
                  ? const Center(child: Text('No service packages created yet.'))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _createdPackages.length,
                      itemBuilder: (context, index) {
                        final package = _createdPackages[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(package['name'] ?? 'Unnamed Package'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (package['description'] != null && package['description']!.isNotEmpty) Text(package['description']!),
                                if (package['duration'] != null) Text('Duration: ${package['duration']}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              tooltip: 'Delete Package',
                              onPressed: () {
                                // TODO: Implement delete package logic
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete package ${package['name']} (not implemented)')));
                              },
                            ),
                          ),
                        );
                      },
                    ),

              const SizedBox(height: 32),

              // --- Reset Password Button ---
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.lock_reset),
                  label: const Text('Reset Admin Password'),
                  onPressed: _showPasswordResetDialog,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPasswordResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return ResetPasswordDialog(
          onResetPassword: (String newPassword) async {
            print('Attempting to reset password to: $newPassword');
            await Future.delayed(const Duration(seconds: 2));
            ScaffoldMessenger.of(dialogContext).showSnackBar(
              const SnackBar(content: Text('Password reset initiated. Check your email or follow further instructions.')),
            );
            Navigator.of(dialogContext).pop();
            return true;
          },
        );
      },
    );
  }
}

// --- Mikrotik Screen ---
class MikrotikScreen extends StatefulWidget {
  const MikrotikScreen({super.key});

  @override
  State<MikrotikScreen> createState() => _MikrotikScreenState();
}

class _MikrotikScreenState extends State<MikrotikScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ipController = TextEditingController();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  final MikrotikService _mikrotikService = MikrotikService();
  bool _isConnected = false;
  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, String>> _activeUsers = [];
  double _currentThroughput = 0.0;
  Map<String, double> _interfaceTraffic = {'download': 0.0, 'upload': 0.0};

  Timer? _timer;
  String? _lastConnectedIp;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ipController.dispose();
    _userController.dispose();
    _passwordController.dispose();
    try {
      _mikrotikService.dispose();
    } catch (e) {
      print("Error disposing MikrotikService: $e");
    }
    super.dispose();
  }

  Future<void> _connectToMikrotik() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; _errorMessage = null; _isConnected = false;
      });
      try {
        final success = await _mikrotikService.connect(
          _ipController.text.trim(),
          _userController.text.trim(),
          _passwordController.text.trim(),
        );
        if (success) {
          setState(() { _isConnected = true; _isLoading = false; _lastConnectedIp = _ipController.text.trim(); });
          _fetchData(); _startTimer();
        } else {
          setState(() { _errorMessage = 'Failed to connect. Please check credentials and IP.'; _isLoading = false; _isConnected = false; });
        }
      } catch (e) {
        setState(() { _errorMessage = 'An error occurred: ${e.toString()}'; _isLoading = false; _isConnected = false; });
      }
    }
  }

  void _fetchData() async {
    if (!_isConnected) return;
    setState(() { _isLoading = true; _errorMessage = null; });
    try {
      final users = await _mikrotikService.getActiveHotspotUsers();
      final throughput = await _mikrotikService.getCurrentThroughput();
      final traffic = await _mikrotikService.getInterfaceTraffic();
      setState(() { _activeUsers = users; _currentThroughput = throughput; _interfaceTraffic = traffic; _isLoading = false; });
    } catch (e) {
      setState(() { _errorMessage = 'Error fetching data: ${e.toString()}'; _isLoading = false; _isConnected = false; _timer?.cancel(); });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_isConnected && !_isLoading) _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mikrotik Information'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isConnected)
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text('Connect to Mikrotik', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 16),
                      TextFormField(controller: _ipController, decoration: const InputDecoration(labelText: 'Mikrotik IP Address', border: OutlineInputBorder(), prefixIcon: Icon(Icons.router)), keyboardType: TextInputType.number, validator: (value) { if (value == null || value.isEmpty) return 'Please enter Mikrotik IP address'; return null; }),
                      const SizedBox(height: 16),
                      TextFormField(controller: _userController, decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)), validator: (value) { if (value == null || value.isEmpty) return 'Please enter username'; return null; }),
                      const SizedBox(height: 16),
                      TextFormField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock)), obscureText: true, validator: (value) { if (value == null || value.isEmpty) return 'Please enter password'; return null; }),
                      const SizedBox(height: 24),
                      _isLoading ? const Center(child: CircularProgressIndicator()) : ElevatedButton.icon(icon: const Icon(Icons.link), label: const Text('Connect'), onPressed: _connectToMikrotik, style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), minimumSize: const Size(double.infinity, 40))),
                      if (_errorMessage != null) Padding(padding: const EdgeInsets.only(top: 16.0), child: Text(_errorMessage!, style: const TextStyle(color: Colors.red))),
                    ],
                  ),
                ),
              if (_isConnected)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mikrotik Status', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 16),
                    Card(margin: const EdgeInsets.only(bottom: 16.0), child: Padding(padding: const EdgeInsets.all(12.0), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Connection Status:', style: TextStyle(fontWeight: FontWeight.bold)), Text(_isConnected ? 'Connected' : 'Disconnected', style: TextStyle(color: _isConnected ? Colors.green : Colors.red)), if (_isLoading && _isConnected) const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))]))),
                    Card(margin: const EdgeInsets.only(bottom: 16.0), child: Padding(padding: const EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Current Throughput:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 8), Text('${_currentThroughput.toStringAsFixed(2)} Mbps', style: const TextStyle(fontSize: 20, color: Colors.cyan))]))),
                    Card(margin: const EdgeInsets.only(bottom: 16.0), child: Padding(padding: const EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Interface Traffic:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 8), Text('Download: ${_interfaceTraffic['download']?.toStringAsFixed(2) ?? 'N/A'} Mbps', style: const TextStyle(fontSize: 16)), Text('Upload: ${_interfaceTraffic['upload']?.toStringAsFixed(2) ?? 'N/A'} Mbps', style: const TextStyle(fontSize: 16))]))),
                    Text('Active Hotspot Users:', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 16),
                    _activeUsers.isEmpty ? (_isLoading ? const CircularProgressIndicator() : const Text('No active hotspot users found.')) : ListView.builder( shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: _activeUsers.length, itemBuilder: (context, index) { final user = _activeUsers[index]; return Card( margin: const EdgeInsets.symmetric(vertical: 4.0), child: ListTile( leading: const Icon(Icons.person_pin), title: Text(user['user'] ?? 'Unknown User'), subtitle: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [ if (user['address'] != null) Text('Address: ${user['address']}'), if (user['uptime'] != null) Text('Uptime: ${user['uptime']}'), ], ), trailing: IconButton(icon: const Icon(Icons.kick_user, color: Colors.red), tooltip: 'Kick User', onPressed: () async { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kick user functionality not fully implemented yet.'))); }, ), ), ); }, ),
                    if (_errorMessage != null && _isConnected) Padding(padding: const EdgeInsets.only(top: 16.0), child: Text(_errorMessage!, style: const TextStyle(color: Colors.red))),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Account Screen ---
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key, this.onMikrotikIpChange});
  final Function(String)? onMikrotikIpChange;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _appVersion = 'Loading...';
  String _deviceInfo = 'Loading...';
  String _networkInfo = 'Not Connected';
  String? _mikrotikConnectedIp;

  @override
  void initState() {
    super.initState();
    _loadProfileInfo();
    _loadMikrotikConnectionInfo();
  }

  Future<void> _loadProfileInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() { _appVersion = packageInfo.version; });
    } catch (e) {
      setState(() { _appVersion = 'Error loading version'; });
    }

    String deviceDetails = '';
    try {
      final deviceInfoPlugin = DeviceInfoPlugin();
      if (kIsWeb) {
        final WebBrowserInfo webInfo = await deviceInfoPlugin.webBrowserInfo;
        deviceDetails = "Browser: ${webInfo.browserName}, Vendor: ${webInfo.vendor}";
      } else {
        final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        deviceDetails = "Device: ${androidInfo.model} (Brand: ${androidInfo.brand ?? 'N/A'}), OS: ${androidInfo.version.release} (SDK ${androidInfo.version.sdkInt})";
      }
      setState(() { _deviceInfo = deviceDetails; });
    } catch (e) {
      setState(() { _deviceInfo = 'Error loading device info: ${e.toString()}'; });
    }
  }

  void _loadMikrotikConnectionInfo() {
     final mockMikrotikIp = '192.168.1.1';
     setState(() {
       _networkInfo = 'Mikrotik IP: $mockMikrotikIp (Placeholder)';
       _mikrotikConnectedIp = mockMikrotikIp;
     });
     if (widget.onMikrotikIpChange != null && mockMikrotikIp != null) {
       widget.onMikrotikIpChange!(mockMikrotikIp);
     }
  }

  void _showPasswordResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return ResetPasswordDialog(
          onResetPassword: (String newPassword) async {
            print('Attempting to reset password to: $newPassword');
            await Future.delayed(const Duration(seconds: 2));
            ScaffoldMessenger.of(dialogContext).showSnackBar(
              const SnackBar(content: Text('Password reset initiated. Check your email or follow further instructions.')),
            );
            Navigator.of(dialogContext).pop();
            return true;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Admin Device Information', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_networkInfo, style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      const Text('MAC Address: Not Directly Accessible (Privacy)', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Application Information', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('App Version: $_appVersion', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('Device Info: $_deviceInfo', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.lock_reset),
                  label: const Text('Reset Admin Password'),
                  onPressed: _showPasswordResetDialog,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Reset Password Dialog Widget ---
class ResetPasswordDialog extends StatefulWidget {
  final Future<bool> Function(String newPassword) onResetPassword;

  const ResetPasswordDialog({super.key, required this.onResetPassword});

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isResetting = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isResetting = true; });
      final success = await widget.onResetPassword(_passwordController.text.trim());
      setState(() { _isResetting = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reset Password'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'New Password', border: OutlineInputBorder()),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a new password';
                  if (value.length < 6) return 'Password must be at least 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Confirm New Password', border: OutlineInputBorder()),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please confirm your password';
                  if (value != _passwordController.text) return 'Passwords do not match';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(child: const Text('Cancel'), onPressed: () { Navigator.of(context).pop(); }),
        TextButton(
          onPressed: _isResetting ? null : _handleReset,
          child: _isResetting
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Reset'),
        ),
      ],
    );
  }
}

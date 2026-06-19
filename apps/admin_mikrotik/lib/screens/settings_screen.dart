import 'package:flutter/material.dart';
import 'package:shared_services/mikrotik/mikrotik_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final MikrotikService _mikrotikService = MikrotikService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _terminalController = TextEditingController();
  final TextEditingController _identityNameController = TextEditingController();
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _identityData;
  List<Map<String, dynamic>> _terminalOutput = [];
  bool _isLoading = false;
  bool _isEditingIdentity = false;

  Future<void> _fetchIdentity() async {
    setState(() {
      _isLoading = true;
      _identityData = null;
    });

    try {
      final response = await _mikrotikService.executeTerminalCommand('/system/identity/print');
      if (response.isNotEmpty) {
        setState(() {
          _identityData = response[0];
          _identityNameController.text = _identityData!['name'] ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching identity: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _rebootDevice() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin memulai ulang perangkat?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Mulai Ulang')),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await _mikrotikService.executeTerminalCommand('/system/reboot');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perangkat sedang dimulai ulang...')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memulai ulang: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _setIdentity() async {
    if (_identityNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama identitas tidak boleh kosong')),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _mikrotikService.executeTerminalCommand('/system/identity/set name=${_identityNameController.text}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Identitas berhasil diperbarui')),
      );
      _fetchIdentity(); // Refresh identity after setting
      setState(() => _isEditingIdentity = false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui identitas: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchUserData() async {
    if (_usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a username')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _userData = null;
    });

    try {
      final data =
          await _mikrotikService.getActiveUser(_usernameController.text);
      setState(() {
        _userData = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _executeTerminalCommand() async {
    if (_terminalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a command')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _terminalOutput = [];
    });

    try {
      final output =
          await _mikrotikService.executeTerminalCommand(_terminalController.text);
      setState(() {
        _terminalOutput = output;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mikrotik Control'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Section: Mikrotik Identity
                _buildSection(
                  title: 'Mikrotik Identity',
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: _fetchIdentity,
                            child: const Text('Get Identity'),
                          ),
                          const SizedBox(width: 8),
                          if (_identityData != null)
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isEditingIdentity = !_isEditingIdentity;
                                });
                              },
                              child: Text(_isEditingIdentity ? 'Cancel' : 'Edit'),
                            ),
                        ],
                      ),
                      if (_identityData != null && !_isEditingIdentity)
                        Card(
                          margin: const EdgeInsets.only(top: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _identityData!.entries
                                  .map((entry) =>
                                      Text('${entry.key}: ${entry.value}'))
                                  .toList(),
                            ),
                          ),
                        ),
                      if (_isEditingIdentity)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _identityNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'New Identity Name',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _setIdentity,
                                child: const Text('Save'),
                              )
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: <Widget>[
                          ElevatedButton(
                              onPressed: _rebootDevice,
                              child: const Text('Daftar Ulang')),
                          ElevatedButton(
                              onPressed: () {}, child: const Text('Shutdown')),
                          ElevatedButton(
                              onPressed: () {},
                              child: const Text('Reset Configuration')),
                          ElevatedButton(
                              onPressed: () {}, child: const Text('Export')),
                          ElevatedButton(
                              onPressed: () {}, child: const Text('Import')),
                        ],
                      ),
                    ],
                  ),
                ),

                const Divider(height: 32, thickness: 2),

                // Section: Get Active User
                _buildSection(
                  title: 'Get Active User Info',
                  child: Column(
                    children: [
                      TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchUserData,
                        child: const Text('Get Info'),
                      ),
                      if (_userData != null)
                        Card(
                          margin: const EdgeInsets.only(top: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _userData!.entries
                                  .map((entry) =>
                                      Text('${entry.key}: ${entry.value}'))
                                  .toList(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const Divider(height: 32, thickness: 2),

                // Section: Terminal
                _buildSection(
                  title: 'Terminal',
                  child: Column(
                    children: [
                      TextField(
                        controller: _terminalController,
                        decoration: const InputDecoration(
                          labelText: 'Enter Command',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _executeTerminalCommand(),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _executeTerminalCommand,
                        child: const Text('Execute'),
                      ),
                      if (_terminalOutput.isNotEmpty)
                        Container(
                          height: 300,
                          margin: const EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            itemCount: _terminalOutput.length,
                            itemBuilder: (context, index) {
                              final item = _terminalOutput[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: item.entries
                                        .map((entry) => Text(
                                            '${entry.key}: ${entry.value}'))
                                        .toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}
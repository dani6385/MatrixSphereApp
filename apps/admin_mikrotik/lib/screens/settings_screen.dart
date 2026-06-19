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
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _terminalOutput = [];
  bool _isLoading = false;

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
      final data = await _mikrotikService.getActiveUser(_usernameController.text);
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
      final output = await _mikrotikService.executeTerminalCommand(_terminalController.text);
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                              .map((entry) => Text('${entry.key}: ${entry.value}'))
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
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: item.entries
                                    .map((entry) => Text('${entry.key}: ${entry.value}'))
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
             if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
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

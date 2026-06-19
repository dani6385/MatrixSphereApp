
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';

class MikrotikSetupScreen extends StatefulWidget {
  const MikrotikSetupScreen({super.key});

  @override
  State<MikrotikSetupScreen> createState() => _MikrotikSetupScreenState();
}

class _MikrotikSetupScreenState extends State<MikrotikSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ipController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final MikrotikService _mikrotikService = MikrotikService();
  bool _isLoading = false;

  Future<void> _saveConfiguration() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // TODO: Implement logic to save configuration to Realtime Database

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Configuration Saved Successfully!')),
        );

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving configuration: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _createScript() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Connect to Mikrotik (assuming the service handles connection details)
      // The service might need to be initialized with credentials from the text fields

      // Command to create the script
      final scriptCommand = '/system script add name=on-login-profile source="/tool fetch url=\"https://console.firebase.google.com/project/matrixsphere-project/database/matrixsphere-project-default-rtdb/data/~2F/mikrotik_member/\$user.json\" keep-result=no"';

      // Command to assign the script to the hotspot profile
      final profileCommand = '/ip hotspot user profile set default on-login=on-login-profile';

      await _mikrotikService.executeTerminalCommand(scriptCommand);
      await _mikrotikService.executeTerminalCommand(profileCommand);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Script created and assigned successfully!')),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating script: $e')),
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
        title: const Text('Mikrotik Setup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _ipController,
                decoration: const InputDecoration(
                  labelText: 'IP Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the IP Address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveConfiguration,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Configuration'),
              ),
              const SizedBox(height: 16),
               ElevatedButton(
                onPressed: _isLoading ? null : _createScript,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Create Script'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  double _fontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.grey[100],
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: _isDarkMode ? Colors.white : Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Appearance'),
            _buildAppearanceSection(),
            const SizedBox(height: 24),
            _buildSectionTitle('Notifications'),
            _buildNotificationSection(),
            const SizedBox(height: 24),
            _buildSectionTitle('General'),
            _buildGeneralSection(),
            const SizedBox(height: 24),
             _buildSectionTitle('About'),
            _buildAboutSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18, 
          fontWeight: FontWeight.bold, 
          color: _isDarkMode ? Colors.blue.shade300 : Theme.of(context).primaryColor
        ),
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: _isDarkMode ? Colors.grey[850] : Colors.white,
      child: Column(
        children: [
          SwitchListTile(
            title: Text('Dark Mode', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
            secondary: Icon(Icons.dark_mode_outlined, color: _isDarkMode ? Colors.white70 : Colors.black54),
            value: _isDarkMode,
            onChanged: (bool value) {
              setState(() {
                _isDarkMode = value;
              });
            },
          ),
          const Divider(height: 1),
          ListTile(
             title: Text('Font Size', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
             subtitle: Slider(
               value: _fontSize,
               min: 12.0,
               max: 24.0,
               divisions: 6,
               label: _fontSize.round().toString(),
               onChanged: (double value) {
                 setState(() {
                   _fontSize = value;
                 });
               },
             ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
       color: _isDarkMode ? Colors.grey[850] : Colors.white,
      child: SwitchListTile(
        title: Text('Push Notifications', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
        secondary: Icon(Icons.notifications_active_outlined, color: _isDarkMode ? Colors.white70 : Colors.black54),
        value: _notificationsEnabled,
        onChanged: (bool value) {
          setState(() {
            _notificationsEnabled = value;
          });
        },
      ),
    );
  }

  Widget _buildGeneralSection() {
    return Card(
       elevation: 2,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
       color: _isDarkMode ? Colors.grey[850] : Colors.white,
       child: ListTile(
         leading: Icon(Icons.language_outlined, color: _isDarkMode ? Colors.white70 : Colors.black54),
         title: Text('Language', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
         trailing: DropdownButton<String>(
           value: _selectedLanguage,
           onChanged: (String? newValue) {
             setState(() {
               _selectedLanguage = newValue!;
             });
           },
           items: <String>['English', 'Spanish', 'French', 'German']
               .map<DropdownMenuItem<String>>((String value) {
             return DropdownMenuItem<String>(
               value: value,
               child: Text(value),
             );
           }).toList(),
         ),
       ),
    );
  }

    Widget _buildAboutSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
       color: _isDarkMode ? Colors.grey[850] : Colors.white,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.privacy_tip_outlined, color: _isDarkMode ? Colors.white70 : Colors.black54),
            title: Text('Privacy Policy', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
           const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.gavel_outlined, color: _isDarkMode ? Colors.white70 : Colors.black54),
            title: Text('Terms of Service', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(height: 1),
           ListTile(
            leading: Icon(Icons.info_outline, color: _isDarkMode ? Colors.white70 : Colors.black54),
            title: Text('App Version', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
            trailing: Text('1.0.0', style: TextStyle(color: Colors.grey.shade500)),
          ),
        ],
      ),
    );
  }
}

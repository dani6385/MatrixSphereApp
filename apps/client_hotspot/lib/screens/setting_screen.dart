
import 'package:flutter/material.dart';

enum ThemeModeOption { light, dark, system }

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ThemeModeOption _themeMode = ThemeModeOption.system;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'System';
  double _fontSize = 16.0;

  ThemeMode get currentThemeMode {
    switch (_themeMode) {
      case ThemeModeOption.light:
        return ThemeMode.light;
      case ThemeModeOption.dark:
        return ThemeMode.dark;
      case ThemeModeOption.system:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = (MediaQuery.of(context).platformBrightness == Brightness.dark && _themeMode == ThemeModeOption.system) || _themeMode == ThemeModeOption.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[100],
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Appearance', isDarkMode),
            _buildAppearanceSection(isDarkMode),
            const SizedBox(height: 24),
            _buildSectionTitle('Notifications', isDarkMode),
            _buildNotificationSection(isDarkMode),
            const SizedBox(height: 24),
            _buildSectionTitle('General', isDarkMode),
            _buildGeneralSection(isDarkMode),
            const SizedBox(height: 24),
             _buildSectionTitle('About', isDarkMode),
            _buildAboutSection(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18, 
          fontWeight: FontWeight.bold, 
          color: isDarkMode ? Colors.blue.shade300 : Theme.of(context).primaryColor
        ),
      ),
    );
  }

  Widget _buildAppearanceSection(bool isDarkMode) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: Column(
        children: [
           ListTile(
            leading: Icon(Icons.brightness_6_outlined, color: isDarkMode ? Colors.white70 : Colors.black54),
            title: Text('Theme', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            trailing: DropdownButton<ThemeModeOption>(
              value: _themeMode,
              dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
              onChanged: (ThemeModeOption? newValue) {
                setState(() {
                  _themeMode = newValue!;
                });
              },
              items: ThemeModeOption.values
                  .map<DropdownMenuItem<ThemeModeOption>>((ThemeModeOption value) {
                    final name = value.name[0].toUpperCase() + value.name.substring(1);
                return DropdownMenuItem<ThemeModeOption>(
                  value: value,
                  child: Text(name, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1),
          ListTile(
             title: Text('Font Size', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
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

  Widget _buildNotificationSection(bool isDarkMode) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
       color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: SwitchListTile(
        title: Text('Push Notifications', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
        secondary: Icon(Icons.notifications_active_outlined, color: isDarkMode ? Colors.white70 : Colors.black54),
        value: _notificationsEnabled,
        onChanged: (bool value) {
          setState(() {
            _notificationsEnabled = value;
          });
        },
      ),
    );
  }

  Widget _buildGeneralSection(bool isDarkMode) {
    return Card(
       elevation: 2,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
       color: isDarkMode ? Colors.grey[850] : Colors.white,
       child: ListTile(
         leading: Icon(Icons.language_outlined, color: isDarkMode ? Colors.white70 : Colors.black54),
         title: Text('Language', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
         trailing: DropdownButton<String>(
           value: _selectedLanguage,
           dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
           onChanged: (String? newValue) {
             setState(() {
               _selectedLanguage = newValue!;
             });
           },
           items: <String>['System', 'English', 'Spanish', 'French', 'German']
               .map<DropdownMenuItem<String>>((String value) {
             return DropdownMenuItem<String>(
               value: value,
               child: Text(value, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
             );
           }).toList(),
         ),
       ),
    );
  }

    Widget _buildAboutSection(bool isDarkMode) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
       color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.privacy_tip_outlined, color: isDarkMode ? Colors.white70 : Colors.black54),
            title: Text('Privacy Policy', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
           const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.gavel_outlined, color: isDarkMode ? Colors.white70 : Colors.black54),
            title: Text('Terms of Service', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(height: 1),
           ListTile(
            leading: Icon(Icons.info_outline, color: isDarkMode ? Colors.white70 : Colors.black54),
            title: Text('App Version', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            trailing: Text('1.0.0', style: TextStyle(color: Colors.grey.shade500)),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/customer_settings.dart';
import 'package:southsea_cinema/widgets/main_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

const String prefAddress = 'user_address';
const String prefEmail = 'user_email';
const String prefPatronNo = 'user_patron_no';
const String prefNews = 'user_news';
const String prefThemeMode = 'theme_mode';

class SettingsScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode>? onThemeModeChanged;

  const SettingsScreen({
    super.key,
    this.themeMode = ThemeMode.dark,
    this.onThemeModeChanged,
  });

  @override
  State<SettingsScreen> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _addressController;
  late TextEditingController _emailController;
  late TextEditingController _patronNoController;
  bool _receiveNews = false;
  late bool _darkMode;
  String _confirmationMessage = '';

  Future<void> _loadSettings() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    final String? savedAddress = await prefs.getString(prefAddress);
    final String? savedEmail = await prefs.getString(prefEmail);
    final String? savedPatronNo = await prefs.getString(prefPatronNo);
    final bool? savedNews = await prefs.getBool(prefNews);
    final String? savedTheme = await prefs.getString(prefThemeMode);

    String address = '';
    if (savedAddress != null) {
      address = savedAddress;
    }

    String email = '';
    if (savedEmail != null) {
      email = savedEmail;
    }

    String patronnu = '';
    if (savedPatronNo != null) {
      patronnu = savedPatronNo;
    }
    bool newslet = false;
    if (savedNews != null) {
      newslet = savedNews;
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _addressController.text = address;
      _emailController.text = email;
      _patronNoController.text = patronnu.toString();
      _receiveNews = newslet;
      _darkMode = savedTheme == 'light'
          ? false
          : savedTheme == 'dark'
              ? true
              : widget.themeMode == ThemeMode.dark;
    });
  }

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _emailController = TextEditingController();
    _patronNoController = TextEditingController();
    _darkMode = widget.themeMode == ThemeMode.dark;
    _loadSettings();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _emailController.dispose();
    _patronNoController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    final String address = _addressController.text.trim();
    final String email = _emailController.text.trim();
    final String patronNo = _patronNoController.text.trim();
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();

    await prefs.setString(prefAddress, address);
    await prefs.setString(prefEmail, email);
    await prefs.setString(prefPatronNo, patronNo);
    await prefs.setBool(prefNews, _receiveNews);
    await prefs.setString(prefThemeMode, _darkMode ? 'dark' : 'light');

    // ignore: unused_local_variable
    final CustomerSettings settings = CustomerSettings(
      address: address,
      email: email,
      patronNo: patronNo,
      receiveNews: _receiveNews,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _confirmationMessage = 'Settings saved!';
    });
  }

  Future<void> _setDarkMode(bool value) async {
    final ThemeMode mode = value ? ThemeMode.dark : ThemeMode.light;
    setState(() {
      _darkMode = value;
    });
    widget.onThemeModeChanged?.call(mode);
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    await prefs.setString(prefThemeMode, value ? 'dark' : 'light');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavDrawer(),
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'My Settings',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Address',
                style: TextStyle(
                    color: cinemaFontMuted,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              TextField(
                controller: _addressController,
                maxLines: 4,
                decoration: const InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(),
                  hintText: 'Enter your address',
                ),
              ),
              const SizedBox(height: 16),
              Text('Email Address',
                  style: TextStyle(
                      color: cinemaFontMuted,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(),
                  hintText: 'Enter your email address',
                ),
              ),
              const SizedBox(height: 23),
              Text('Patron Number',
                  style: TextStyle(
                      color: cinemaFontMuted,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              TextField(
                controller: _patronNoController,
                decoration: const InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(),
                  hintText: 'Enter your Patron Number',
                ),
              ),
              const SizedBox(height: 23),
              Text('Preferences',
                  style: TextStyle(
                      color: cinemaFontMuted,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              const SizedBox(height: 3),
              Row(
                children: [
                  const Expanded(
                    child: Text('Receive news by email'),
                  ),
                  Switch(
                    key: const ValueKey<String>('news-switch'),
                    value: _receiveNews,
                    onChanged: (bool value) {
                      setState(() {
                        _receiveNews = value;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text('Dark mode'),
                  ),
                  Switch(
                    key: const ValueKey<String>('theme-switch'),
                    value: _darkMode,
                    onChanged: _setDarkMode,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                          foregroundColor:
                              Theme.of(context).colorScheme.onSurface,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface),
                      onPressed: () {},
                      child: Text(
                        'CANCEL',
                        style: TextStyle(fontSize: 21),
                      )),
                  const SizedBox(width: 5),
                  MainButton(label: 'SAVE SETTINGS', onPressed: _saveSettings)
                ],
              ),
              if (_confirmationMessage.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  _confirmationMessage,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ])));
  }
}

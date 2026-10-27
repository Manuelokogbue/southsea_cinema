import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/customer_settings.dart';
import 'package:southsea_cinema/widgets/main_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String prefAddress = 'user_address';
const String prefEmail = 'user_email';
const String prefPatronNo = 'user_patron_no';
const String prefNews = 'user_news';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

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
  String _confirmationMessage = '';

  Future<void> _loadSettings() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    final String? savedAddress = await prefs.getString(prefAddress);
    final String? savedEmail = await prefs.getString(prefEmail);
    final String? savedPatronNo = await prefs.getString(prefPatronNo);
    final bool? savedNews = await prefs.getBool(prefNews);

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
    });
  }

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _emailController = TextEditingController();
    _patronNoController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(appTitle, style: cinemaHeaderStyle),
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
                  fillColor: cinemaSurface,
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
                  fillColor: cinemaSurface,
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
                  fillColor: cinemaSurface,
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
                    value: _receiveNews,
                    onChanged: (bool value) {
                      setState(() {
                        _receiveNews = value;
                      });
                    },
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
                          foregroundColor: cinemaFontWhite,
                          backgroundColor: cinemaSurface),
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

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  double _volume = 0.5;
  bool _vibrationEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _soundEnabled = prefs.getBool('soundEnabled') ?? true;
      _volume = prefs.getDouble('volume') ?? 0.5;
      _vibrationEnabled = prefs.getBool('vibrationEnabled') ?? true;
    });
  }

  Future<void> _setSound(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundEnabled', value);
    setState(() => _soundEnabled = value);
  }

  Future<void> _setVolume(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('volume', value);
    setState(() => _volume = value);
  }

  Future<void> _setVibration(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibrationEnabled', value);
    setState(() => _vibrationEnabled = value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: Text(l10n.sound),
            value: _soundEnabled,
            onChanged: _setSound,
          ),
          ListTile(
            title: Text(l10n.volume),
            subtitle: Slider(
              value: _volume,
              onChanged: _soundEnabled ? _setVolume : null,
            ),
          ),
          SwitchListTile(
            title: Text(l10n.vibration),
            value: _vibrationEnabled,
            onChanged: _setVibration,
          ),
        ],
      ),
    );
  }
}

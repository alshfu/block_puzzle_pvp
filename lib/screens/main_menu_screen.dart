import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import 'game_selection_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  String _playerName = '';

  @override
  void initState() {
    super.initState();
    _loadPlayerName();
  }

  Future<void> _loadPlayerName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _playerName = prefs.getString('playerName') ?? 'Player';
    });
  }

  void _navigateTo(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen))
        .then((_) => _loadPlayerName()); // Обновляем имя после возврата
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              // Верхняя панель с профилем и настройками
              _buildHeader(l10n),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.appTitle,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 60),
                      _buildMenuButton(
                        context,
                        text: l10n.selectMode,
                        color: const Color(0xFF3498db),
                        onPressed: () => _navigateTo(const GameSelectionScreen()),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Кнопка профиля
        TextButton.icon(
          icon: const Icon(Icons.person, color: Colors.white70),
          label: Text(_playerName, style: const TextStyle(color: Colors.white)),
          onPressed: () => _navigateTo(const ProfileScreen()),
        ),
        // Кнопка настроек
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white70),
          onPressed: () => _navigateTo(const SettingsScreen()),
        ),
      ],
    );
  }

  Widget _buildMenuButton(BuildContext context,
      {required String text,
        required Color color,
        required VoidCallback onPressed}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 24),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}

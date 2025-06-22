import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../games/tetris/tetris_game_screen.dart';
import '../l10n/app_localizations.dart';
import '../models/player_stats.dart';
import '../services/firebase_service.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'leaderboard_screen.dart';

class GameSelectionScreen extends StatefulWidget {
  const GameSelectionScreen({super.key});

  @override
  State<GameSelectionScreen> createState() => _GameSelectionScreenState();
}

class _GameSelectionScreenState extends State<GameSelectionScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  PlayerStats _stats = PlayerStats();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final stats = await _firebaseService.loadPlayerStats();
    if (mounted) {
      setState(() {
        _stats = stats;
      });
    }
  }

  void _navigateTo(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen))
        .then((_) => _loadData());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            tooltip: l10n.leaderboard,
            onPressed: () => _navigateTo(const LeaderboardScreen()),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: l10n.settings,
            onPressed: () => _navigateTo(const SettingsScreen()),
          ),
          // ИСПРАВЛЕНИЕ: Добавлена кнопка выхода
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.logout,
            onPressed: () async {
              await _firebaseService.signOut();
              // AuthGate сам перенаправит на экран входа
            },
          ),
          TextButton(
            child: Text(_stats.playerName, style: TextStyle(color: Colors.white)),
            onPressed: () => _navigateTo(const ProfileScreen()),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildTetrisButton(
                l10n: l10n,
                onTap: () => _navigateTo(const TetrisGameScreen()),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTetrisButton({required AppLocalizations l10n, required VoidCallback onTap}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3498db),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: onTap,
      child: Column(
        children: [
          Text(l10n.tetris, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(l10n.classicMode, style: const TextStyle(fontSize: 14, color: Colors.white70)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(color: Colors.white24),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildScoreColumn(
                  title: l10n.highScore,
                  score: '${_stats.tetrisHighScore}',
                  color: Colors.amber),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreColumn({required String title, required String score, required Color color}) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 12, color: color.withOpacity(0.8))),
        const SizedBox(height: 2),
        Text(
          score,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}

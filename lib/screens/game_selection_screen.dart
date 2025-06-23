import 'package:flutter/material.dart';
import 'package:block_puzzle_pvp/services/firebase_service.dart';
import 'package:block_puzzle_pvp/models/player_stats.dart';
import 'package:block_puzzle_pvp/l10n/app_localizations.dart';
import 'package:block_puzzle_pvp/screens/profile_screen.dart';
import 'package:block_puzzle_pvp/screens/settings_screen.dart';
import 'package:block_puzzle_pvp/screens/leaderboard_screen.dart';
import '../games/tetris/tetris_game_screen.dart';
import '../games/tetris/tetris_pvp_screen.dart';

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
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.logout,
            onPressed: () async {
              await _firebaseService.signOut();
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
              _buildGameButton(
                l10n: l10n,
                title: l10n.tetris,
                subtitle: l10n.classicMode,
                color: const Color(0xFF3498db),
                highScore: _stats.tetrisHighScore,
                onTap: () => _navigateTo(const TetrisGameScreen()),
              ),
              const SizedBox(height: 20),
              _buildGameButton(
                l10n: l10n,
                title: "PvP",
                subtitle: l10n.oneVsOne,
                color: const Color(0xFFe74c3c),
                highScore: _stats.pvpWins,
                onTap: () => _navigateTo(const TetrisPvpScreen()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameButton({
    required AppLocalizations l10n,
    required String title,
    required String subtitle,
    required Color color,
    required int highScore,
    required VoidCallback onTap
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: onTap,
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.white70)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(color: Colors.white24),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(l10n.highScore, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8))),
                  const SizedBox(height: 2),
                  Text(highScore.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

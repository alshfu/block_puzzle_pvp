import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/player_stats.dart';
import '../services/firebase_service.dart';
import '../widgets/identicon_avatar.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  Future<List<PlayerStats>>? _leaderboardFuture;

  @override
  void initState() {
    super.initState();
    _leaderboardFuture = _firebaseService.getLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.leaderboard),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<PlayerStats>>(
        future: _leaderboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Не удалось загрузить таблицу лидеров.'));
          }

          final players = snapshot.data!;

          return ListView.builder(
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              final placeColor = index < 3 ? Colors.amber.shade600 : Colors.white70;
              return Card(
                color: Theme.of(context).cardColor.withOpacity(0.5),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '#${index + 1}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: placeColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      IdenticonAvatar(
                        text: player.playerName,
                        seed: player.avatarId,
                        size: 40,
                      ),
                    ],
                  ),
                  title: Text(player.playerName),
                  subtitle: Text('${l10n.playerLevel}: ${player.level}'),
                  trailing: Text(
                    '${player.tetrisHighScore}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

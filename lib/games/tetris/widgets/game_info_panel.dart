import 'package:flutter/material.dart';
import '../../../../../l10n/app_localizations.dart';
import '../game_logic/piece.dart';

class GameInfoPanel extends StatelessWidget {
  final int score;
  final int level;
  final Piece nextPiece;
  final bool isPaused;
  final VoidCallback onPauseToggle;
  final VoidCallback onRestart;

  const GameInfoPanel({
    super.key,
    required this.score,
    required this.level,
    required this.nextPiece,
    required this.isPaused,
    required this.onPauseToggle,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInfoBox(l10n.score, score.toString()),
          const SizedBox(height: 16),
          _buildInfoBox(l10n.level, level.toString()),
          const SizedBox(height: 16),
          _buildInfoBox(l10n.next, '', child: _buildNextPiece()),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: onPauseToggle,
            icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
            label: Text(isPaused ? l10n.resume : l10n.pause),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: onRestart,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.restart),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String label, String value, {Widget? child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
          const SizedBox(height: 4),
          child ?? Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildNextPiece() {
    return Container(
      height: 60,
      width: 60,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: nextPiece.shape[0].length,
        ),
        itemCount: nextPiece.shape.length * nextPiece.shape[0].length,
        itemBuilder: (context, index) {
          int row = index ~/ nextPiece.shape[0].length;
          int col = index % nextPiece.shape[0].length;

          if (row < nextPiece.shape.length && col < nextPiece.shape[row].length && nextPiece.shape[row][col] == 1) {
            return Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: nextPiece.color,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

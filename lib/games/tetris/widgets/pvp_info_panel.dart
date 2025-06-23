import 'package:flutter/material.dart';
import '../game_logic/piece.dart';
import '../game_logic/pvp_board.dart';

class PvpInfoPanel extends StatelessWidget {
  final int score;
  final PlayerType currentPlayer;
  final Piece humanNextPiece;
  final Piece botNextPiece;

  const PvpInfoPanel({
    super.key,
    required this.score,
    required this.currentPlayer,
    required this.humanNextPiece,
    required this.botNextPiece,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey.shade900,
      child: Column(
        children: [
          Text('СЧЕТ: $score', style: const TextStyle(color: Colors.white, fontSize: 20)),
          const SizedBox(height: 10),
          Text(
            currentPlayer == PlayerType.human ? 'ВАШ ХОД' : 'ХОД БОТА',
            style: TextStyle(
              color: currentPlayer == PlayerType.human ? Colors.greenAccent : Colors.redAccent,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNextPieceBox('ВЫ', humanNextPiece),
              _buildNextPieceBox('БОТ', botNextPiece),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildNextPieceBox(String label, Piece piece) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade700),
            borderRadius: BorderRadius.circular(4),
          ),
          child: _buildNextPiece(piece),
        ),
      ],
    );
  }

  Widget _buildNextPiece(Piece piece) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemCount: 16,
      itemBuilder: (context, index) {
        int row = index ~/ 4;
        int col = index % 4;

        if (row < piece.shape.length && col < piece.shape[row].length && piece.shape[row][col] == 1) {
          return Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: piece.color,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../game_logic/piece.dart';
import '../game_logic/pvp_board.dart'; // Using pvp_board for PlayerType

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
      padding: const EdgeInsets.all(16.0),
      color: Colors.black.withOpacity(0.2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInfoBox('СЧЕТ', score.toString()),
          const SizedBox(height: 20),
          _buildTurnIndicator(),
          const SizedBox(height: 20),
          _buildNextPieceBox('СЛЕДУЮЩАЯ (ВЫ)', humanNextPiece),
          const SizedBox(height: 16),
          _buildNextPieceBox('СЛЕДУЮЩАЯ (БОТ)', botNextPiece),
        ],
      ),
    );
  }

  Widget _buildTurnIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          currentPlayer == PlayerType.human ? 'ВАШ ХОД' : 'ХОД БОТА',
          style: TextStyle(
            color: currentPlayer == PlayerType.human ? Colors.greenAccent : Colors.redAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  // FIXED: This method now accepts an optional child widget
  Widget _buildInfoBox(String label, String value, {Widget? child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
          const SizedBox(height: 4),
          // Display the child if it exists, otherwise display the text value
          child ?? Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildNextPieceBox(String label, Piece piece) {
    // This call is now valid because _buildInfoBox accepts a child
    return _buildInfoBox(
      label,
      '',
      child: Center(
        child: SizedBox(
          height: 60,
          width: 60,
          child: _buildNextPiece(piece),
        ),
      ),
    );
  }

  Widget _buildNextPiece(Piece piece) {
    final int pieceWidth = piece.shape.isNotEmpty ? piece.shape[0].length : 4;
    final int pieceHeight = piece.shape.length;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: pieceWidth,
      ),
      itemCount: pieceWidth * pieceHeight,
      itemBuilder: (context, index) {
        int row = index ~/ pieceWidth;
        int col = index % pieceWidth;

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
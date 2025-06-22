import 'package:flutter/material.dart';
import '../game_logic/board.dart';

class GameBoardDisplay extends StatelessWidget {
  final GameBoard game;

  const GameBoardDisplay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: GameBoard.cols / GameBoard.rows,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade800, width: 2),
            color: Colors.black,
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: GameBoard.cols,
            ),
            itemBuilder: (context, index) {
              int row = index ~/ GameBoard.cols;
              int col = index % GameBoard.cols;
              Color? color = game.grid[row][col];

              // Отрисовка текущей фигуры
              for (int y = 0; y < game.currentPiece.shape.length; y++) {
                for (int x = 0; x < game.currentPiece.shape[y].length; x++) {
                  if (game.currentPiece.shape[y][x] == 1) {
                    if (game.currentPiece.position.y + y == row &&
                        game.currentPiece.position.x + x == col) {
                      color = game.currentPiece.color;
                    }
                  }
                }
              }

              return Container(
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: color ?? Colors.grey.shade900.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            },
            itemCount: GameBoard.rows * GameBoard.cols,
          ),
        ),
      ),
    );
  }
}

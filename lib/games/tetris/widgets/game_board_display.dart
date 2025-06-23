import 'package:flutter/material.dart';
import '../game_logic/piece.dart';

class GameBoardDisplay extends StatelessWidget {
  final List<List<Color?>> grid;
  final Piece currentPiece;

  const GameBoardDisplay({
    super.key,
    required this.grid,
    required this.currentPiece,
  });

  @override
  Widget build(BuildContext context) {
    // Определяем размеры доски из полученной сетки
    final int rows = grid.length;
    final int cols = grid.isNotEmpty ? grid[0].length : 0;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: cols / rows,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade800, width: 2),
            color: Colors.black,
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
            ),
            itemBuilder: (context, index) {
              int row = index ~/ cols;
              int col = index % cols;
              Color? color = grid[row][col];

              // Отрисовываем текущую падающую фигуру поверх сетки
              for (int y = 0; y < currentPiece.shape.length; y++) {
                for (int x = 0; x < currentPiece.shape[y].length; x++) {
                  if (currentPiece.shape[y][x] == 1) {
                    if (currentPiece.position.y + y == row &&
                        currentPiece.position.x + x == col) {
                      color = currentPiece.color;
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
            itemCount: rows * cols,
          ),
        ),
      ),
    );
  }
}

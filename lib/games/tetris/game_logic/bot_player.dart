import 'dart:math';
import 'pvp_board.dart';
import 'piece.dart';

class BotPlayer {

  void makeBestMove(PvpGameBoard board) {
    final bestMove = _findBestMove(board);

    // Применяем лучший найденный ход
    for (int i = 0; i < bestMove.rotations; i++) {
      board.rotate();
    }

    int currentX = (PvpGameBoard.cols / 2).floor() - 1;
    int dx = bestMove.xPosition - currentX;

    if (dx > 0) {
      for (int i = 0; i < dx; i++) board.moveRight();
    } else {
      for (int i = 0; i < dx.abs(); i++) board.moveLeft();
    }
    board.hardDrop();
  }

  _Move _findBestMove(PvpGameBoard board) {
    double bestScore = -double.infinity;
    _Move bestMove = _Move(0, 0);

    // Перебираем все возможные вращения
    for (int rotation = 0; rotation < 4; rotation++) {
      Piece simPiece = Piece(type: board.currentPiece.type);
      for(int i = 0; i < rotation; i++) simPiece.rotate();

      // Перебираем все возможные горизонтальные позиции
      for (int x = -2; x < PvpGameBoard.cols; x++) {
        Point<int> startPos = Point(x, 0);

        if (!board.isValidPosition(startPos, shape: simPiece.shape)) continue;

        Point<int> finalPos = startPos;
        while (board.isValidPosition(Point(finalPos.x, finalPos.y + 1), shape: simPiece.shape)) {
          finalPos = Point(finalPos.x, finalPos.y + 1);
        }

        // Симулируем доску после хода и оцениваем ее
        double score = _evaluateBoard(board, simPiece, finalPos);

        if (score > bestScore) {
          bestScore = score;
          bestMove = _Move(rotation, finalPos.x);
        }
      }
    }
    return bestMove;
  }

  // Улучшенная функция оценки, штрафующая за "дыры"
  double _evaluateBoard(PvpGameBoard board, Piece piece, Point<int> position) {
    List<List<bool>> tempGrid = board.grid.map((row) => row.map((cell) => cell != null).toList()).toList();

    // Симулируем размещение фигуры
    for (int y = 0; y < piece.shape.length; y++) {
      for (int x = 0; x < piece.shape[y].length; x++) {
        if (piece.shape[y][x] == 1) {
          if(position.y + y < PvpGameBoard.rows) {
            tempGrid[position.y + y][position.x + x] = true;
          }
        }
      }
    }

    int holes = 0;
    int aggregateHeight = 0;

    for (int c = 0; c < PvpGameBoard.cols; c++) {
      bool blockFound = false;
      for (int r = 0; r < PvpGameBoard.rows; r++) {
        if (tempGrid[r][c]) {
          blockFound = true;
          aggregateHeight += (PvpGameBoard.rows - r);
        } else if (blockFound) {
          holes++; // Найдена дыра
        }
      }
    }

    return - (holes * 10.0) - (aggregateHeight * 0.5);
  }
}

class _Move {
  final int rotations;
  final int xPosition;
  _Move(this.rotations, this.xPosition);
}

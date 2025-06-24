import 'dart:math';
import 'board.dart'; // ИЗМЕНЕНО: Импортируем стандартную доску
import 'piece.dart';

class BotPlayer {
  // ИЗМЕНЕНО: Метод теперь принимает стандартный GameBoard
  void makeBestMove(GameBoard board) {
    if (board.isGameOver()) return;
    final bestMove = _findBestMove(board);

    // Применяем лучший найденный ход
    for (int i = 0; i < bestMove.rotations; i++) {
      board.rotate();
    }

    // Начальная позиция фигуры известна
    int currentX = (GameBoard.cols / 2).floor() - 1;
    int dx = bestMove.xPosition - currentX;

    if (dx > 0) {
      for (int i = 0; i < dx; i++) board.moveRight();
    } else {
      for (int i = 0; i < dx.abs(); i++) board.moveLeft();
    }
    board.hardDrop();
  }

  _Move _findBestMove(GameBoard board) {
    double bestScore = -double.infinity;
    _Move bestMove = _Move(0, 0);

    // Перебираем все возможные вращения
    for (int rotation = 0; rotation < 4; rotation++) {
      Piece simPiece = Piece(type: board.currentPiece.type);
      for (int i = 0; i < rotation; i++) simPiece.rotate();

      // Перебираем все возможные горизонтальные позиции
      for (int x = -2; x < GameBoard.cols; x++) {
        Point<int> startPos = Point(x, 0);

        // Используем симуляцию для проверки валидности хода
        if (!_simulateIsValidPosition(board, simPiece, startPos)) continue;

        Point<int> finalPos = startPos;
        while (_simulateIsValidPosition(board, simPiece, Point(finalPos.x, finalPos.y + 1))) {
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

  // Улучшенная функция оценки, которая штрафует за высоту, "дыры" и неровности
  double _evaluateBoard(GameBoard board, Piece piece, Point<int> position) {
    List<List<bool>> tempGrid = board.grid.map((row) => row.map((cell) => cell != null).toList()).toList();

    // Симулируем размещение фигуры
    for (int y = 0; y < piece.shape.length; y++) {
      for (int x = 0; x < piece.shape[y].length; x++) {
        if (piece.shape[y][x] == 1) {
          if (position.y + y < GameBoard.rows) {
            tempGrid[position.y + y][position.x + x] = true;
          }
        }
      }
    }

    int holes = 0;
    int aggregateHeight = 0;
    int bumpiness = 0;
    List<int> columnHeights = List.filled(GameBoard.cols, 0);

    for (int c = 0; c < GameBoard.cols; c++) {
      bool blockFound = false;
      for (int r = 0; r < GameBoard.rows; r++) {
        if (tempGrid[r][c]) {
          if (!blockFound) {
            columnHeights[c] = GameBoard.rows - r;
          }
          blockFound = true;
        } else if (blockFound) {
          holes++; // Найдена дыра
        }
      }
      aggregateHeight += columnHeights[c];
    }

    for (int i = 0; i < columnHeights.length - 1; i++) {
      bumpiness += (columnHeights[i] - columnHeights[i + 1]).abs();
    }

    // Коэффициенты для оценки, взятые из популярных реализаций ИИ для Тетриса
    return - (aggregateHeight * 0.51) - (holes * 0.76) - (bumpiness * 0.18);
  }

  // Вспомогательный метод для симуляции, чтобы не зависеть от currentPiece на доске
  bool _simulateIsValidPosition(GameBoard board, Piece piece, Point<int> pos) {
    for (int y = 0; y < piece.shape.length; y++) {
      for (int x = 0; x < piece.shape[y].length; x++) {
        if (piece.shape[y][x] == 1) {
          int newX = pos.x + x;
          int newY = pos.y + y;
          if (newX < 0 || newX >= GameBoard.cols || newY >= GameBoard.rows || (newY >= 0 && board.grid[newY][newX] != null)) {
            return false;
          }
        }
      }
    }
    return true;
  }
}

class _Move {
  final int rotations;
  final int xPosition;
  _Move(this.rotations, this.xPosition);
}
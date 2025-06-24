import 'dart:math';
import 'package:flutter/material.dart';
import 'piece.dart';

class GameBoard {
  static const int rows = 20;
  static const int cols = 10;

  late List<List<Color?>> grid;
  late Piece currentPiece;
  late Piece nextPiece;

  int score = 0;
  int level = 1;
  int linesCleared = 0;
  bool _isGameOver = false;

  final List<Tetromino> _bag = [];
  final Random _random = Random();

  Function? onPiecePlaced;
  Function(int)? onLinesCleared;

  GameBoard() {
    grid = List.generate(rows, (_) => List.generate(cols, (_) => null));
    _fillAndShuffleBag();
    nextPiece = _createNewPiece();
    _spawnNewPiece();
  }

  void _fillAndShuffleBag() {
    _bag.clear();
    _bag.addAll(Tetromino.values);
    _bag.shuffle(_random);
  }

  void _spawnNewPiece() {
    if (_isGameOver) return;

    currentPiece = nextPiece;
    currentPiece.position = Point((cols / 2).floor() - 1, 0);

    nextPiece = _createNewPiece();

    // Use the public method now
    if (!isValidPosition(currentPiece.position)) {
      _isGameOver = true;
    }
  }

  Piece _createNewPiece() {
    if (_bag.isEmpty) {
      _fillAndShuffleBag();
    }
    final type = _bag.removeAt(0);
    return Piece(type: type);
  }

  void moveDown() => _tryMove(const Point(0, 1));
  void moveLeft() => _tryMove(const Point(-1, 0));
  void moveRight() => _tryMove(const Point(1, 0));

  void rotate() {
    final originalShape = currentPiece.shape.map((row) => List<int>.from(row)).toList();
    currentPiece.rotate();
    // Use the public method now
    if (!isValidPosition(currentPiece.position)) {
      currentPiece.shape = originalShape;
    }
  }

  void hardDrop() {
    // Use the public method now
    while (isValidPosition(Point(currentPiece.position.x, currentPiece.position.y + 1))) {
      currentPiece.move(const Point(0, 1));
    }
    _placePiece();
  }

  void _tryMove(Point<int> direction) {
    Point<int> newPosition = Point(currentPiece.position.x + direction.x, currentPiece.position.y + direction.y);
    // Use the public method now
    if (isValidPosition(newPosition)) {
      currentPiece.position = newPosition;
    } else if (direction.y == 1) {
      _placePiece();
    }
  }

  // FIXED: Made the method public by removing the underscore
  bool isValidPosition(Point<int> pos) {
    for (int y = 0; y < currentPiece.shape.length; y++) {
      for (int x = 0; x < currentPiece.shape[y].length; x++) {
        if (currentPiece.shape[y][x] == 1) {
          int newX = pos.x + x;
          int newY = pos.y + y;
          if (newX < 0 || newX >= cols || newY >= rows || (newY >= 0 && grid[newY][newX] != null)) {
            return false;
          }
        }
      }
    }
    return true;
  }

  void _placePiece() {
    for (int y = 0; y < currentPiece.shape.length; y++) {
      for (int x = 0; x < currentPiece.shape[y].length; x++) {
        if (currentPiece.shape[y][x] == 1) {
          int boardY = currentPiece.position.y + y;
          if (boardY >= 0 && boardY < rows) {
            grid[boardY][currentPiece.position.x + x] = currentPiece.color;
          }
        }
      }
    }

    int clearedCount = _clearLines();
    if (clearedCount > 0 && onLinesCleared != null) {
      onLinesCleared!(clearedCount);
    }

    if (onPiecePlaced != null) {
      onPiecePlaced!();
    } else {
      _spawnNewPiece();
    }
  }

  int _clearLines() {
    int lines = 0;
    for (int y = rows - 1; y >= 0; y--) {
      if (!grid[y].contains(null)) {
        lines++;
        for (int r = y; r > 0; r--) {
          grid[r] = List.from(grid[r - 1]);
        }
        grid[0] = List.generate(cols, (_) => null);
        y++;
      }
    }
    if (lines > 0) {
      score += [100, 300, 500, 800][lines - 1] * level;
      linesCleared += lines;
      level = (linesCleared ~/ 10) + 1;
    }
    return lines;
  }

  void addGarbageLines(int lineCount) {
    // ... (code without changes)

  }

  bool isGameOver() => _isGameOver;

  void setGameOver(bool value) {
    _isGameOver = value;
  }
}
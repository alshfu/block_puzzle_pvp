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

  // ИСПРАВЛЕНИЕ: Добавлен "мешок" для реализации системы "7-bag"
  final List<Tetromino> _bag = [];
  final Random _random = Random();

  GameBoard() {
    grid = List.generate(rows, (_) => List.generate(cols, (_) => null));
    _fillAndShuffleBag(); // Заполняем мешок в первый раз
    nextPiece = _createNewPiece(); // Инициализируем первую "следующую" фигуру
    _spawnNewPiece(); // Создаем первую "текущую" фигуру
  }

  // ИСПРАВЛЕНИЕ: Метод для заполнения и перемешивания "мешка" с фигурами
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

    if (!_isValidPosition(currentPiece.position)) {
      _isGameOver = true;
    }
  }

  Piece _createNewPiece() {
    // ИСПРАВЛЕНИЕ: Берем фигуру из "мешка", а не генерируем случайно
    if (_bag.isEmpty) {
      _fillAndShuffleBag();
    }
    // Извлекаем первую фигуру из перемешанного списка
    final type = _bag.removeAt(0);
    return Piece(type: type);
  }

  void moveDown() {
    _tryMove(const Point(0, 1));
  }

  void moveLeft() {
    _tryMove(const Point(-1, 0));
  }

  void moveRight() {
    _tryMove(const Point(1, 0));
  }

  void rotate() {
    final originalShape = currentPiece.shape.map((row) => List<int>.from(row)).toList();
    currentPiece.rotate();
    if (!_isValidPosition(currentPiece.position)) {
      currentPiece.shape = originalShape;
    }
  }

  void hardDrop() {
    Point<int> testPosition = currentPiece.position;
    while (_isValidPosition(Point(testPosition.x, testPosition.y + 1))) {
      testPosition = Point(testPosition.x, testPosition.y + 1);
    }
    currentPiece.position = testPosition;
    _placePiece();
  }

  void _tryMove(Point<int> direction) {
    Point<int> newPosition = Point(currentPiece.position.x + direction.x, currentPiece.position.y + direction.y);
    if (_isValidPosition(newPosition)) {
      currentPiece.position = newPosition;
    } else if (direction.x == 0 && direction.y == 1) {
      _placePiece();
    }
  }

  bool _isValidPosition(Point<int> pos) {
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
          int boardX = currentPiece.position.x + x;
          int boardY = currentPiece.position.y + y;
          if (boardY >= 0) {
            grid[boardY][boardX] = currentPiece.color;
          }
        }
      }
    }
    _clearLines();
    _spawnNewPiece();
  }

  void _clearLines() {
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
  }

  bool isGameOver() {
    return _isGameOver;
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'piece.dart';

// Перечисление для отслеживания, чей сейчас ход
enum PlayerType { human, bot }

class PvpGameBoard {
  static const int rows = 20;
  static const int cols = 10;

  late List<List<Color?>> grid;
  late Piece currentPiece;

  final List<Tetromino> _humanBag = [];
  final List<Tetromino> _botBag = [];
  late Piece humanNextPiece;
  late Piece botNextPiece;

  PlayerType currentPlayer = PlayerType.human;
  int score = 0;
  bool _isGameOver = false;
  final Random _random = Random();

  PvpGameBoard() {
    grid = List.generate(rows, (_) => List.generate(cols, (_) => null));
    _fillBagFor(PlayerType.human);
    _fillBagFor(PlayerType.bot);
    humanNextPiece = _getPieceFromBag(PlayerType.human);
    botNextPiece = _getPieceFromBag(PlayerType.bot);
    _spawnNewPiece();
  }

  void _fillBagFor(PlayerType player) {
    final bag = player == PlayerType.human ? _humanBag : _botBag;
    bag.clear();
    bag.addAll(Tetromino.values);
    bag.shuffle(_random);
  }

  Piece _getPieceFromBag(PlayerType player) {
    final bag = player == PlayerType.human ? _humanBag : _botBag;
    if (bag.isEmpty) _fillBagFor(player);
    return Piece(type: bag.removeAt(0));
  }

  void _spawnNewPiece() {
    if (_isGameOver) return;

    currentPiece = (currentPlayer == PlayerType.human) ? humanNextPiece : botNextPiece;
    currentPiece.position = Point((cols / 2).floor() - 1, 0);

    if (currentPlayer == PlayerType.human) {
      humanNextPiece = _getPieceFromBag(PlayerType.human);
    } else {
      botNextPiece = _getPieceFromBag(PlayerType.bot);
    }

    if (!isValidPosition(currentPiece.position)) {
      _isGameOver = true;
    }
  }

  void _switchTurn() {
    currentPlayer = (currentPlayer == PlayerType.human) ? PlayerType.bot : PlayerType.human;
    _spawnNewPiece();
  }

  void moveDown() => _tryMove(const Point(0, 1));
  void moveLeft() => _tryMove(const Point(-1, 0));
  void moveRight() => _tryMove(const Point(1, 0));

  void rotate() {
    final originalShape = currentPiece.shape.map((row) => List<int>.from(row)).toList();
    currentPiece.rotate();
    if (!isValidPosition(currentPiece.position)) currentPiece.shape = originalShape;
  }

  void hardDrop() {
    while (isValidPosition(Point(currentPiece.position.x, currentPiece.position.y + 1))) {
      currentPiece.move(const Point(0, 1));
    }
    _placePiece();
  }

  void _tryMove(Point<int> direction) {
    Point<int> newPosition = Point(currentPiece.position.x + direction.x, currentPiece.position.y + direction.y);
    if (isValidPosition(newPosition)) {
      currentPiece.position = newPosition;
    } else if (direction.y == 1) {
      _placePiece();
    }
  }

  bool isValidPosition(Point<int> pos, {List<List<int>>? shape}) {
    List<List<int>> s = shape ?? currentPiece.shape;
    for (int y = 0; y < s.length; y++) {
      for (int x = 0; x < s[y].length; x++) {
        if (s[y][x] == 1) {
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
    _clearLines();
    _switchTurn();
  }

  void _clearLines() {
    int lines = 0;
    for (int y = rows - 1; y >= 0; y--) {
      if (!grid[y].contains(null)) {
        lines++;
        for (int r = y; r > 0; r--) grid[r] = List.from(grid[r - 1]);
        grid[0] = List.generate(cols, (_) => null);
        y++;
      }
    }
    if (lines > 0) score += [100, 300, 500, 800][lines - 1];
  }

  bool isGameOver() => _isGameOver;
}

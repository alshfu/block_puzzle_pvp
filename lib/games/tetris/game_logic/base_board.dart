// lib/games/tetris/game_logic/base_board.dart (новый файл)
import 'dart:math';
import 'package:flutter/material.dart';
import 'piece.dart';

abstract class BaseGameBoard {
  static const int rows = 20;
  static const int cols = 10;

  late List<List<Color?>> grid;
  late Piece currentPiece;
  int score = 0;
  bool _isGameOver = false;

  BaseGameBoard() {
    grid = List.generate(rows, (_) => List.generate(cols, (_) => null));
  }

  // Общие методы, которые были дублированы
  void moveDown() => _tryMove(const Point(0, 1));

  void moveLeft() => _tryMove(const Point(-1, 0));

  void moveRight() => _tryMove(const Point(1, 0));

  void rotate() {
    final originalShape = currentPiece.shape
        .map((row) => List<int>.from(row))
        .toList();
    currentPiece.rotate();
    if (!isValidPosition(currentPiece.position)) {
      currentPiece.shape = originalShape;
    }
  }

  void hardDrop() {
    while (isValidPosition(
        Point(currentPiece.position.x, currentPiece.position.y + 1))) {
      currentPiece.move(const Point(0, 1));
    }
    _placePiece();
  }

  void _tryMove(Point<int> direction) {
    Point<int> newPosition = Point(currentPiece.position.x + direction.x,
        currentPiece.position.y + direction.y);
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
          if (newX < 0 || newX >= cols || newY >= rows ||
              (newY >= 0 && grid[newY][newX] != null)) {
            return false;
          }
        }
      }
    }
    return true;
  }

  // Абстрактные методы, реализация которых отличается
  void _placePiece();

  void _clearLines();

  void _spawnNewPiece();

  bool isGameOver() => _isGameOver;

  void setGameOver(bool value) => _isGameOver = value;
}
import 'package:flutter/material.dart';
import 'dart:math';

enum Tetromino { L, J, I, O, S, Z, T }

const Map<Tetromino, List<List<int>>> tetrominoShapes = {
  Tetromino.L: [[0, 1, 0],[0, 1, 0],[1, 1, 0]],
  Tetromino.J: [[0, 1, 0],[0, 1, 0],[0, 1, 1]],
  Tetromino.I: [[1],[1],[1],[1]],
  Tetromino.O: [[1, 1], [1, 1]],
  Tetromino.S: [[0, 1, 1],[1, 1, 0],[0, 0, 0]],
  Tetromino.Z: [[1, 1, 0],[0, 1, 1],[0, 0, 0]],
  Tetromino.T: [[1, 1, 1],[0, 1, 0],[0, 0, 0]],
};

class Piece {
  Tetromino type;
  List<List<int>> shape;
  Point<int> position;

  static final Map<Tetromino, Color> colors = {
    Tetromino.L: Colors.orange,
    Tetromino.J: Colors.blue,
    Tetromino.I: Colors.cyan,
    Tetromino.O: Colors.yellow,
    Tetromino.S: Colors.green,
    Tetromino.Z: Colors.red,
    Tetromino.T: Colors.purple,
  };

  Piece({required this.type}) :
        shape = List<List<int>>.from(tetrominoShapes[type]!.map((row) => List<int>.from(row))),
        position = const Point(0, 0);

  Color get color => colors[type]!;

  void move(Point<int> direction) {
    position = Point(position.x + direction.x, position.y + direction.y);
  }

  void rotate() {
    final List<List<int>> newShape = List.generate(shape[0].length, (i) => List.generate(shape.length, (j) => 0));
    for (int y = 0; y < shape.length; y++) {
      for (int x = 0; x < shape[y].length; x++) {
        newShape[x][shape.length - 1 - y] = shape[y][x];
      }
    }
    shape = newShape;
  }
}

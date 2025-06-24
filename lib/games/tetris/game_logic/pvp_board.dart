import 'dart:math';
import 'package:flutter/material.dart';
import 'board.dart';
import 'piece.dart';

enum PlayerType { human, bot }

class SharedBoardPvpGame {
  // The single, shared board for both players
  late GameBoard board;
  PlayerType currentPlayer = PlayerType.human;

  // Separate "7-bags" for each player
  final List<Tetromino> _humanBag = [];
  final List<Tetromino> _botBag = [];
  final Random _random = Random();

  late Piece humanNextPiece;
  late Piece botNextPiece;

  SharedBoardPvpGame() {
    board = GameBoard();
    // Subscribe to the piece placed event to switch turns
    board.onPiecePlaced = switchTurn;
    // Garbage lines are not used in this mode
    board.onLinesCleared = null;

    _fillBag(_humanBag);
    _fillBag(_botBag);

    humanNextPiece = _createNewPiece(PlayerType.human);
    botNextPiece = _createNewPiece(PlayerType.bot);

    _spawnNewPieceForCurrentPlayer();
  }

  void _fillBag(List<Tetromino> bag) {
    bag.clear();
    bag.addAll(Tetromino.values);
    bag.shuffle(_random);
  }

  Piece _createNewPiece(PlayerType player) {
    final bag = (player == PlayerType.human) ? _humanBag : _botBag;
    if (bag.isEmpty) {
      _fillBag(bag);
    }
    final type = bag.removeAt(0);
    return Piece(type: type);
  }

  void _spawnNewPieceForCurrentPlayer() {
    if (board.isGameOver()) return;

    // Take a piece from the current player's queue
    if (currentPlayer == PlayerType.human) {
      board.currentPiece = humanNextPiece;
      humanNextPiece = _createNewPiece(PlayerType.human);
    } else {
      board.currentPiece = botNextPiece;
      botNextPiece = _createNewPiece(PlayerType.bot);
    }

    // Place it at the starting position
    board.currentPiece.position = Point((GameBoard.cols / 2).floor() - 1, 0);

    // If there's no room for the new piece, the game is over
    if (!board.isValidPosition(board.currentPiece.position)) {
      board.setGameOver(true);
    }
  }

  void switchTurn() {
    if (board.isGameOver()) return;

    currentPlayer = (currentPlayer == PlayerType.human) ? PlayerType.bot : PlayerType.human;
    _spawnNewPieceForCurrentPlayer();
  }

  // Delegate piece control methods to the board
  void moveLeft() => board.moveLeft();
  void moveRight() => board.moveRight();
  void moveDown() => board.moveDown();
  void rotate() => board.rotate();
  void hardDrop() => board.hardDrop();

  // Methods to get game state
  bool isGameOver() => board.isGameOver();
  int get score => board.score;
  List<List<Color?>> get grid => board.grid;
  Piece get currentPiece => board.currentPiece;
}
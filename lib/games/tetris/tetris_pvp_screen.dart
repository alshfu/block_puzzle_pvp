import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../../l10n/app_localizations.dart';
import '../../services/firebase_service.dart';
import 'game_logic/board.dart';
import 'game_logic/bot_player.dart';
import 'game_logic/piece.dart';
import 'game_logic/pvp_board.dart';
import 'widgets/game_board_display.dart';
import 'widgets/game_controls.dart';
import 'widgets/pvp_info_panel.dart';

class TetrisPvpScreen extends StatefulWidget {
  const TetrisPvpScreen({super.key});

  @override
  State<TetrisPvpScreen> createState() => _TetrisPvpScreenState();
}

class _TetrisPvpScreenState extends State<TetrisPvpScreen> {
  late SharedBoardPvpGame _game;
  late BotPlayer _bot;
  Timer? _gravityTimer;
  bool _isGameOver = false;
  bool _isPaused = false;
  bool _isLoading = true;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _startGame();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
  }

  @override
  void dispose() {
    _gravityTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _startGame() {
    _gravityTimer?.cancel();
    setState(() {
      _game = SharedBoardPvpGame();
      _bot = BotPlayer();
      _isGameOver = false;
      _isPaused = false;
      _isLoading = false;
    });
    _handleTurnChange();
  }

  void _handleTurnChange() {
    if (_game.isGameOver()) {
      _handleGameOver();
      return;
    }

    if (_game.currentPlayer == PlayerType.bot) {
      _gravityTimer?.cancel();
      _makeBotMove();
    } else {
      _restartGravityTimer();
    }
  }

  void _restartGravityTimer() {
    _gravityTimer?.cancel();
    _gravityTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (!_isPaused && mounted) {
        _performPlayerMove(() => _game.moveDown());
      }
    });
  }

  void _makeBotMove() {
    if (!mounted || _isPaused || _game.isGameOver()) return;

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted || _isPaused || _game.isGameOver()) return;

      setState(() {
        // Бот делает свой ход, что приводит к установке фигуры
        // и автоматическому вызову `switchTurn` через callback.
        _bot.makeBestMove(_game.board);
        // После хода бота проверяем, не изменился ли ход
        _handleTurnChange();
      });
    });
  }

  void _performPlayerMove(VoidCallback moveFunction) {
    if (_isGameOver || _isPaused || _game.currentPlayer != PlayerType.human) return;

    PlayerType playerBeforeMove = _game.currentPlayer;

    setState(() {
      moveFunction();
    });

    // Если ход привел к установке фигуры, `currentPlayer` изменится.
    if (playerBeforeMove == PlayerType.human && _game.currentPlayer == PlayerType.bot) {
      _handleTurnChange();
    } else if (_game.isGameOver()) {
      _handleGameOver();
    }
  }

  void _handleGameOver() {
    if (_isGameOver) return;
    _gravityTimer?.cancel();
    setState(() => _isGameOver = true);

    // Проиграл тот, чей был ход в момент, когда фигуру нельзя было поставить.
    final loser = _game.currentPlayer;
    final winner = (loser == PlayerType.human) ? PlayerType.bot : PlayerType.human;

    FirebaseService().updatePvpResult(
      totalScore: _game.score,
      victory: winner == PlayerType.human,
    );

    if (mounted) _showGameOverDialog(winner);
  }

  void _showGameOverDialog(PlayerType winner) {
    final l10n = AppLocalizations.of(context)!;
    final victoryText = "ПОБЕДА!"; // TODO: l10n.victory
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(winner == PlayerType.human ? victoryText : l10n.gameOver),
        content: Text("${l10n.score}: ${_game.score}"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startGame();
                FocusScope.of(context).requestFocus(_focusNode);
              },
              child: Text(l10n.playAgain)),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(l10n.backToMenu)),
        ],
      ),
    );
  }

  void _togglePause() {
    if (_isGameOver) return;
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _gravityTimer?.cancel();
      } else {
        _handleTurnChange();
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent || _isGameOver || _isPaused) return;
    final move = switch (event.logicalKey) {
      LogicalKeyboardKey.arrowLeft => () => _game.moveLeft(),
      LogicalKeyboardKey.arrowRight => () => _game.moveRight(),
      LogicalKeyboardKey.arrowDown => () => _game.moveDown(),
      LogicalKeyboardKey.arrowUp => () => _game.rotate(),
      LogicalKeyboardKey.space => () => _game.hardDrop(),
      _ => null,
    };
    if (move != null) _performPlayerMove(move);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
          backgroundColor: Colors.black,
          body: Center(child: CircularProgressIndicator()));
    }

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Игровое поле ---
                    Expanded(
                      flex: 3,
                      child: GameBoardDisplay(
                        grid: _game.grid,
                        currentPiece: _game.currentPiece,
                      ),
                    ),
                    // --- Информационная панель ---
                    Expanded(
                      flex: 2,
                      child: PvpInfoPanel(
                        score: _game.score,
                        currentPlayer: _game.currentPlayer,
                        humanNextPiece: _game.humanNextPiece,
                        botNextPiece: _game.botNextPiece,
                      ),
                    ),
                  ],
                ),
              ),
              // --- Панель управления ---
              IgnorePointer(
                ignoring: _isPaused || _isGameOver || _game.currentPlayer != PlayerType.human,
                child: Opacity(
                  opacity: (_isPaused || _isGameOver || _game.currentPlayer != PlayerType.human) ? 0.5 : 1.0,
                  child: GameControls(
                    onLeft: () => _performPlayerMove(() => _game.moveLeft()),
                    onRight: () => _performPlayerMove(() => _game.moveRight()),
                    onRotate: () => _performPlayerMove(() => _game.rotate()),
                    onDown: () => _performPlayerMove(() => _game.moveDown()),
                    onHardDrop: () => _performPlayerMove(() => _game.hardDrop()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
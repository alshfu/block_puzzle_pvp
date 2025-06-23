import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../../l10n/app_localizations.dart';
import '../../services/firebase_service.dart';
import 'game_logic/board.dart';
import 'widgets/game_board_display.dart';
import 'widgets/game_info_panel.dart';
import 'widgets/game_controls.dart';
import 'game_logic/piece.dart';

class TetrisGameScreen extends StatefulWidget {
  const TetrisGameScreen({super.key});

  @override
  State<TetrisGameScreen> createState() => _TetrisGameScreenState();
}

class _TetrisGameScreenState extends State<TetrisGameScreen> {
  late GameBoard _game;
  Timer? _timer;
  bool _isGameOver = false;
  bool _isPaused = false;
  late DateTime _startTime;
  final FirebaseService _firebaseService = FirebaseService();
  final FocusNode _focusNode = FocusNode();

  Duration get gameSpeed => Duration(milliseconds: 500 - (_game.level * 20));

  @override
  void initState() {
    super.initState();
    _startGame();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _game = GameBoard();
      _isGameOver = false;
      _isPaused = false;
      _startTime = DateTime.now();
    });
    _restartTimer();
  }

  void _restartTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(gameSpeed, (timer) {
      if (!_isPaused && mounted) {
        _performMove(() => _game.moveDown());
      }
    });
  }

  void _performMove(VoidCallback moveFunction) {
    if (_isGameOver || _isPaused) return;
    setState(() {
      moveFunction();
      if (_game.isGameOver()) {
        _handleGameOver();
      }
    });
  }

  Future<void> _handleGameOver() async {
    _timer?.cancel();
    setState(() => _isGameOver = true);
    final score = _game.score;
    final playtime = DateTime.now().difference(_startTime);
    try {
      await _firebaseService.updatePostGameStats(finalScore: score, playtime: playtime);
    } catch (e) {
      print("Не удалось сохранить статистику: $e");
    }
    if (mounted) _showGameOverDialog();
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(l10n.gameOver, style: TextStyle(color: Colors.red.shade400)),
          content: Text(l10n.yourScore(_game.score)),
          actions: <Widget>[
            TextButton(child: Text(l10n.playAgain), onPressed: () {
              Navigator.of(context).pop();
              _startGame();
            }),
            TextButton(child: Text(l10n.backToMenu), onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }),
          ],
        );
      },
    );
  }

  void _togglePause() {
    if (_isGameOver) return;
    setState(() => _isPaused = !_isPaused);
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    if (_isPaused || _isGameOver) return;

    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      _performMove(() => _game.moveLeft());
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      _performMove(() => _game.moveRight());
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      _performMove(() => _game.moveDown());
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      _performMove(() => _game.rotate());
    } else if (event.logicalKey == LogicalKeyboardKey.space) {
      _performMove(() => _game.hardDrop());
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    Expanded(
                      flex: 3,
                      child: GameBoardDisplay(
                        // ИСПРАВЛЕНИЕ: Передаем правильные параметры
                        grid: _game.grid,
                        currentPiece: _game.currentPiece,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: GameInfoPanel(
                        score: _game.score,
                        level: _game.level,
                        nextPiece: _game.nextPiece,
                        isPaused: _isPaused,
                        onPauseToggle: _togglePause,
                        onRestart: _startGame,
                      ),
                    ),
                  ],
                ),
              ),
              GameControls(
                onLeft: () => _performMove(() => _game.moveLeft()),
                onRight: () => _performMove(() => _game.moveRight()),
                onRotate: () => _performMove(() => _game.rotate()),
                onDown: () => _performMove(() => _game.moveDown()),
                onHardDrop: () => _performMove(() => _game.hardDrop()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

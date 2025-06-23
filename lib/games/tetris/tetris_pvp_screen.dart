import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../../l10n/app_localizations.dart';
import '../../services/firebase_service.dart';
import 'game_logic/pvp_board.dart';
import 'game_logic/bot_player.dart';
import 'widgets/game_board_display.dart';
import 'widgets/pvp_info_panel.dart';
import 'widgets/game_controls.dart';
import 'game_logic/piece.dart';

class TetrisPvpScreen extends StatefulWidget {
  const TetrisPvpScreen({super.key});

  @override
  State<TetrisPvpScreen> createState() => _TetrisPvpScreenState();
}

class _TetrisPvpScreenState extends State<TetrisPvpScreen> {
  late PvpGameBoard _game;
  late BotPlayer _bot;
  Timer? _gameTimer;
  bool _isGameOver = false;
  final FocusNode _focusNode = FocusNode();

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
    _gameTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _game = PvpGameBoard();
      _bot = BotPlayer();
      _isGameOver = false;
    });
    _startTurn();
  }

  void _startTurn() {
    if (_isGameOver) return;

    if (_game.currentPlayer == PlayerType.bot) {
      _makeBotMove();
    } else {
      // Это ход человека, запускаем таймер гравитации
      _gameTimer?.cancel();
      _gameTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
        _performPlayerMove(() => _game.moveDown());
      });
    }
  }

  void _makeBotMove() {
    if (!mounted || _isGameOver) return;

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted || _isGameOver) return;
      setState(() {
        _bot.makeBestMove(_game); // Бот делает свой ход и сбрасывает фигуру
        if (_game.isGameOver()) {
          _handleGameOver(PlayerType.human);
        } else {
          // После хода бота сразу начинается ход человека
          _startTurn();
        }
      });
    });
  }

  void _performPlayerMove(VoidCallback moveFunction) {
    if (_isGameOver || _game.currentPlayer != PlayerType.human) return;

    PlayerType playerBeforeMove = _game.currentPlayer;

    setState(() {
      moveFunction();
      if (_game.isGameOver()) {
        _handleGameOver(PlayerType.bot);
      }
    });

    // Если ход завершен (фигура упала) и очередь перешла к боту
    if (playerBeforeMove == PlayerType.human && _game.currentPlayer == PlayerType.bot) {
      _gameTimer?.cancel(); // Останавливаем таймер гравитации
      _makeBotMove();
    }
  }

  Future<void> _handleGameOver(PlayerType winner) async {
    if(_isGameOver) return;
    setState(() => _isGameOver = true);

    await FirebaseService().updatePvpResult(
      totalScore: _game.score,
      victory: winner == PlayerType.human,
    );

    if (mounted) _showGameOverDialog(winner);
  }

  void _showGameOverDialog(PlayerType winner) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(winner == PlayerType.human ? "ПОБЕДА!" : l10n.gameOver),
        content: Text("${l10n.score}: ${_game.score}"),
        actions: [
          TextButton(onPressed: () {
            Navigator.of(context).pop();
            _startGame();
          }, child: Text(l10n.playAgain)),
          TextButton(onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }, child: Text(l10n.backToMenu)),
        ],
      ),
    );
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) _performPlayerMove(() => _game.moveLeft());
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) _performPlayerMove(() => _game.moveRight());
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) _performPlayerMove(() => _game.moveDown());
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) _performPlayerMove(() => _game.rotate());
    if (event.logicalKey == LogicalKeyboardKey.space) _performPlayerMove(() => _game.hardDrop());
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
              PvpInfoPanel(
                score: _game.score,
                currentPlayer: _game.currentPlayer,
                humanNextPiece: _game.humanNextPiece,
                botNextPiece: _game.botNextPiece,
              ),
              Expanded(
                child: Center(
                  child: GameBoardDisplay(
                    grid: _game.grid,
                    currentPiece: _game.currentPiece,
                  ),
                ),
              ),
              GameControls(
                onLeft: () => _performPlayerMove(() => _game.moveLeft()),
                onRight: () => _performPlayerMove(() => _game.moveRight()),
                onRotate: () => _performPlayerMove(() => _game.rotate()),
                onDown: () => _performPlayerMove(() => _game.moveDown()),
                onHardDrop: () => _performPlayerMove(() => _game.hardDrop()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

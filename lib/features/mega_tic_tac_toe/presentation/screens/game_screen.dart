import 'package:flutter/material.dart';
import 'package:mega_tic_tac_toe/core/theme/app_colors.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/application/game_controller.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/ai_difficulty.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/presentation/widgets/game_over_dialog.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/presentation/widgets/rules_dialog.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/presentation/widgets/mega_board.dart';

class GameScreen extends StatefulWidget {
  final bool vsAi;
  final AiDifficulty aiDifficulty;

  const GameScreen({
    super.key,
    required this.vsAi,
    this.aiDifficulty = AiDifficulty.medium,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GameController(
      vsAi: widget.vsAi,
      aiDifficulty: widget.aiDifficulty,
    );
    _controller.addListener(_handleControllerUpdate);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  void _handleControllerUpdate() {
    final String? message = _controller.consumePendingGameOverMessage();
    if (message == null || !mounted) {
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GameOverDialog(
          message: message,
          onClose: () => Navigator.pop(context),
          onPlayAgain: () {
            Navigator.pop(context);
            _controller.resetGame();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mediumWood,
      appBar: AppBar(
        backgroundColor: AppColors.darkWood,
        title: Text(
          widget.vsAi ? 'VS AI (${widget.aiDifficulty.label})' : 'VS Player',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'reset_game_fab',
            onPressed: _controller.resetGame,
            backgroundColor: AppColors.lightWood,
            child: const Icon(Icons.refresh, color: AppColors.darkWood),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: 'rules_fab',
            onPressed: () => showDialog<void>(
              context: context,
              builder: (BuildContext context) => const RulesDialog(),
            ),
            backgroundColor: AppColors.lightWood,
            child: const Icon(Icons.help_outline, color: AppColors.darkWood),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? _) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: MegaBoard(
              state: _controller.state,
              onCellTap: _controller.makeMove,
            ),
          );
        },
      ),
    );
  }
}

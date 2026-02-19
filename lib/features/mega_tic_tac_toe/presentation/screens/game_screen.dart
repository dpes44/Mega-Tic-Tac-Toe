import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mega_tic_tac_toe/core/theme/app_colors.dart';
import 'package:mega_tic_tac_toe/features/audio/application/audio_controller.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/application/game_controller.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/ai_difficulty.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/mega_game_state.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/presentation/widgets/game_over_dialog.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/presentation/widgets/mega_board.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/presentation/widgets/rules_dialog.dart';
import 'package:mega_tic_tac_toe/features/settings/application/settings_controller.dart';
import 'package:mega_tic_tac_toe/features/settings/domain/app_settings.dart';
import 'package:vibration/vibration.dart';

class GameScreen extends StatefulWidget {
  final bool vsAi;
  final AiDifficulty aiDifficulty;
  final SettingsController settingsController;

  const GameScreen({
    super.key,
    required this.vsAi,
    required this.settingsController,
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              AppColors.backgroundTop,
              AppColors.backgroundBottom,
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: Listenable.merge(<Listenable>[
              _controller,
              widget.settingsController,
            ]),
            builder: (BuildContext context, Widget? _) {
              final MegaGameState state = _controller.state;
              final settings = widget.settingsController.settings;
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                    child: Row(
                      children: <Widget>[
                        IconButton.filledTonal(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_rounded),
                          color: AppColors.panel,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.vsAi
                                ? 'VS AI (${widget.aiDifficulty.label})'
                                : 'VS Player',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        IconButton.filledTonal(
                          onPressed: _showRules,
                          icon: const Icon(Icons.help_outline_rounded),
                          color: AppColors.panel,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: _StatusCard(
                      turnText: _turnText(state),
                      targetText: _targetText(state),
                      isAiThinking:
                          widget.vsAi && state.isAiTurn && !state.gameOver,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                      child: LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                              final double boardSize = _boardDimension(
                                constraints,
                              );
                              return Center(
                                child: SizedBox.square(
                                  dimension: boardSize,
                                  child: MegaBoard(
                                    state: state,
                                    boardSkin: settings.boardSkin,
                                    onCellTap: (int section, int cell) =>
                                        _onCellTap(section, cell, settings),
                                  ),
                                ),
                              );
                            },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _showRules,
                            icon: const Icon(Icons.menu_book_rounded),
                            label: const Text('Rules'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.panel,
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.45),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _controller.resetGame,
                            icon: const Icon(Icons.replay_rounded),
                            label: const Text('Restart'),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.accentDeep,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  double _boardDimension(BoxConstraints constraints) {
    final double available = constraints.biggest.shortestSide;
    return available.clamp(280, 720);
  }

  String _turnText(MegaGameState state) {
    if (state.gameOver) {
      return 'Game finished';
    }
    if (widget.vsAi && state.isAiTurn) {
      return 'AI is thinking...';
    }
    return state.isPlayerXTurn ? 'Turn: Player X' : 'Turn: Player O';
  }

  String _targetText(MegaGameState state) {
    final int? target = state.targetSection;
    if (target == null) {
      return 'Target board: Any open board';
    }
    final int row = (target ~/ 3) + 1;
    final int col = (target % 3) + 1;
    return 'Target board: Row $row, Col $col';
  }

  void _showRules() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => const RulesDialog(),
    );
  }

  void _onCellTap(int section, int cell, AppSettings settings) {
    final bool moved = _controller.makeMove(section, cell);
    if (!moved) {
      return;
    }
    unawaited(_playMoveFeedback(settings));
  }

  Future<void> _playMoveFeedback(AppSettings settings) async {
    if (settings.soundEnabled) {
      unawaited(AudioController.instance.playTapBeep());
    }

    if (!settings.vibrationEnabled) {
      return;
    }

    try {
      final bool hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator) {
        await Vibration.vibrate(duration: 45, amplitude: 110);
      } else {
        await HapticFeedback.mediumImpact();
      }
    } catch (_) {
      await HapticFeedback.mediumImpact();
    }
  }
}

class _StatusCard extends StatelessWidget {
  final String turnText;
  final String targetText;
  final bool isAiThinking;

  const _StatusCard({
    required this.turnText,
    required this.targetText,
    required this.isAiThinking,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.panel.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                isAiThinking
                    ? Icons.psychology_rounded
                    : Icons.track_changes_rounded,
                size: 18,
                color: isAiThinking ? AppColors.warning : AppColors.success,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  turnText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            targetText,
            style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

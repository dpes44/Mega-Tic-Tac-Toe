import 'package:flutter/material.dart';
import 'package:mega_tic_tac_toe/core/theme/app_colors.dart';
import 'package:mega_tic_tac_toe/features/legal/presentation/screens/privacy_policy_screen.dart';
import 'package:mega_tic_tac_toe/features/legal/presentation/screens/terms_and_conditions_screen.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/ai_difficulty.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/presentation/screens/game_screen.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/presentation/widgets/menu_button.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/presentation/widgets/rules_dialog.dart';
import 'package:mega_tic_tac_toe/features/settings/application/settings_controller.dart';
import 'package:mega_tic_tac_toe/features/settings/presentation/screens/board_skin_screen.dart';
import 'package:mega_tic_tac_toe/features/settings/presentation/screens/settings_screen.dart';

class MainMenuScreen extends StatelessWidget {
  final SettingsController settingsController;

  const MainMenuScreen({super.key, required this.settingsController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: settingsController,
        builder: (BuildContext context, Widget? _) {
          return Container(
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
              child: Stack(
                children: <Widget>[
                  const _BackgroundOrnaments(),
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 500),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(
                                  22,
                                  22,
                                  22,
                                  20,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.panel.withValues(
                                    alpha: 0.96,
                                  ),
                                  borderRadius: BorderRadius.circular(26),
                                  border: Border.all(
                                    color: AppColors.accent.withValues(
                                      alpha: 0.55,
                                    ),
                                  ),
                                  boxShadow: const <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.black38,
                                      blurRadius: 30,
                                      offset: Offset(0, 16),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const Text(
                                      'MEGA TIC-TAC-TOE',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 36,
                                        height: 1.05,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Classic strategy, modern polish.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.textMuted,
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    const SizedBox(height: 22),
                                    MenuButton(
                                      text: 'VS AI',
                                      subtitle:
                                          'Choose difficulty, then play',
                                      icon: Icons.smart_toy_rounded,
                                      onPressed: () =>
                                          _startGame(context, vsAi: true),
                                    ),
                                    const SizedBox(height: 12),
                                    MenuButton(
                                      text: 'VS Player',
                                      subtitle: 'Pass-and-play on one device',
                                      icon: Icons.group_rounded,
                                      onPressed: () =>
                                          _startGame(context, vsAi: false),
                                    ),
                                    const SizedBox(height: 12),
                                    MenuButton(
                                      text: 'How to Play',
                                      subtitle: 'Rules and board flow',
                                      icon: Icons.menu_book_rounded,
                                      onPressed: () => _showRules(context),
                                    ),
                                    const SizedBox(height: 12),
                                    MenuButton(
                                      text: 'Board Skins',
                                      subtitle: 'Pick your board style',
                                      icon: Icons.palette_outlined,
                                      onPressed: () => _openBoardSkins(context),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          children: <Widget>[
                            TextButton(
                              onPressed: () => _openPrivacyPolicy(context),
                              child: const Text(
                                'Privacy Policy',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                            const Text(
                              '•',
                              style: TextStyle(color: Colors.white54),
                            ),
                            TextButton(
                              onPressed: () => _openTermsAndConditions(context),
                              child: const Text(
                                'Terms & Conditions',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 14,
                    right: 14,
                    child: IconButton.filledTonal(
                      onPressed: () => _openSettings(context),
                      icon: const Icon(Icons.settings_rounded),
                      color: AppColors.panel,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _startGame(BuildContext context, {required bool vsAi}) async {
    AiDifficulty aiDifficulty = settingsController.settings.defaultAiDifficulty;

    if (vsAi) {
      final AiDifficulty? selected = await _askAiDifficulty(context);
      if (selected == null || !context.mounted) {
        return;
      }
      aiDifficulty = selected;
      await settingsController.setDefaultAiDifficulty(selected);
      if (!context.mounted) {
        return;
      }
    }

    if (!context.mounted) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => GameScreen(
          vsAi: vsAi,
          aiDifficulty: aiDifficulty,
          settingsController: settingsController,
        ),
      ),
    );
  }

  Future<AiDifficulty?> _askAiDifficulty(BuildContext context) {
    final AiDifficulty selected = settingsController.settings.defaultAiDifficulty;
    return showModalBottomSheet<AiDifficulty>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (BuildContext sheetContext) {
        AiDifficulty selectedDifficulty = selected;
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
              decoration: BoxDecoration(
                color: AppColors.panel,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Choose AI Difficulty',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...AiDifficulty.values.map(
                    (AiDifficulty difficulty) => ListTile(
                      dense: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                      leading: Icon(
                        selectedDifficulty == difficulty
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: selectedDifficulty == difficulty
                            ? AppColors.accentDeep
                            : AppColors.textMuted,
                      ),
                      title: Text(
                        difficulty.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        difficulty.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      onTap: () {
                        setState(() => selectedDifficulty = difficulty);
                      },
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () =>
                          Navigator.pop(sheetContext, selectedDifficulty),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Start Game'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.accentDeep,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showRules(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => const RulesDialog(),
    );
  }

  void _openPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const PrivacyPolicyScreen(),
      ),
    );
  }

  void _openTermsAndConditions(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const TermsAndConditionsScreen(),
      ),
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            SettingsScreen(settingsController: settingsController),
      ),
    );
  }

  void _openBoardSkins(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            BoardSkinScreen(settingsController: settingsController),
      ),
    );
  }
}

class _BackgroundOrnaments extends StatelessWidget {
  const _BackgroundOrnaments();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -130,
            right: -80,
            child: _BlurCircle(
              size: 300,
              color: AppColors.accent.withValues(alpha: 0.20),
            ),
          ),
          Positioned(
            left: -100,
            bottom: 140,
            child: _BlurCircle(
              size: 240,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlurCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _BlurCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

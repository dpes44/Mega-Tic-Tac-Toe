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
          final settings = settingsController.settings;
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
                                  24,
                                  26,
                                  24,
                                  24,
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
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    const SizedBox(height: 28),
                                    MenuButton(
                                      text: 'VS AI',
                                      subtitle:
                                          'Play against adaptive AI (default: ${settings.defaultAiDifficulty.label})',
                                      icon: Icons.smart_toy_rounded,
                                      onPressed: () =>
                                          _startGame(context, vsAi: true),
                                    ),
                                    const SizedBox(height: 14),
                                    MenuButton(
                                      text: 'VS Player',
                                      subtitle: 'Pass-and-play on one device',
                                      icon: Icons.group_rounded,
                                      onPressed: () =>
                                          _startGame(context, vsAi: false),
                                    ),
                                    const SizedBox(height: 14),
                                    MenuButton(
                                      text: 'How to Play',
                                      subtitle: 'Rules and board flow',
                                      icon: Icons.menu_book_rounded,
                                      onPressed: () => _showRules(context),
                                    ),
                                    const SizedBox(height: 14),
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
    final AiDifficulty aiDifficulty =
        settingsController.settings.defaultAiDifficulty;

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

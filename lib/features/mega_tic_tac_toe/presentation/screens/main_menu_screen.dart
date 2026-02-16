import 'package:flutter/material.dart';
import 'package:mega_tic_tac_toe/core/theme/app_colors.dart';
import 'package:mega_tic_tac_toe/features/legal/presentation/screens/privacy_policy_screen.dart';
import 'package:mega_tic_tac_toe/features/legal/presentation/screens/terms_and_conditions_screen.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/ai_difficulty.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/presentation/screens/game_screen.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/presentation/widgets/menu_button.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/presentation/widgets/rules_dialog.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkWood,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        'Mega Tic-Tac-Toe',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 50),
                      MenuButton(
                        text: 'VS AI',
                        onPressed: () => _startGame(context, vsAi: true),
                      ),
                      const SizedBox(height: 20),
                      MenuButton(
                        text: 'VS Player',
                        onPressed: () => _startGame(context, vsAi: false),
                      ),
                      const SizedBox(height: 20),
                      MenuButton(
                        text: 'How to Play',
                        onPressed: () => _showRules(context),
                      ),
                    ],
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
                  const Text('•', style: TextStyle(color: Colors.white54)),
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
      ),
    );
  }

  Future<void> _startGame(BuildContext context, {required bool vsAi}) async {
    AiDifficulty aiDifficulty = AiDifficulty.medium;
    if (vsAi) {
      final AiDifficulty? selected = await _showAiDifficultyPicker(context);
      if (selected == null) {
        return;
      }
      aiDifficulty = selected;
    }

    if (!context.mounted) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            GameScreen(vsAi: vsAi, aiDifficulty: aiDifficulty),
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

  Future<AiDifficulty?> _showAiDifficultyPicker(BuildContext context) {
    return showModalBottomSheet<AiDifficulty>(
      context: context,
      backgroundColor: AppColors.lightWood,
      showDragHandle: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(
                  'Choose AI Difficulty',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkWood,
                  ),
                ),
              ),
              for (final AiDifficulty difficulty in AiDifficulty.values)
                ListTile(
                  title: Text(
                    difficulty.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkWood,
                    ),
                  ),
                  subtitle: Text(
                    difficulty.description,
                    style: const TextStyle(color: AppColors.darkWood),
                  ),
                  onTap: () => Navigator.pop(context, difficulty),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

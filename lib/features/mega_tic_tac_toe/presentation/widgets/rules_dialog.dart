import 'package:flutter/material.dart';
import 'package:mega_tic_tac_toe/core/theme/app_colors.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/presentation/widgets/rule_section.dart';

class RulesDialog extends StatelessWidget {
  const RulesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.lightWood,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.darkWood, width: 2),
        ),
        child: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'How to Play',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkWood,
                ),
              ),
              SizedBox(height: 20),
              RuleSection(
                title: 'Objective',
                content:
                    'Win 3 mini-games in a row on the main board (like regular tic-tac-toe) '
                    'by winning individual 3x3 sections.',
              ),
              RuleSection(
                title: 'Board Layout',
                content:
                    '- 9 main sections, each containing a 3x3 grid\n'
                    '- Win a section by getting 3 in a row in its grid\n'
                    '- Win the game by getting 3 won sections in a row',
              ),
              RuleSection(
                title: 'Game Flow',
                content:
                    '1. First move: Play anywhere\n'
                    '2. Next moves: Play in the section matching the last move cell position\n'
                    '   Example: Play center cell -> next move must be in center section\n'
                    '3. If target section is won or full: Choose any open section',
              ),
              RuleSection(
                title: 'Winning',
                content:
                    '- Section win: 3 same symbols in a row (any direction)\n'
                    '- Game win: 3 won sections in a row (any direction)\n'
                    '- Draw: All sections filled with no main-board winner',
              ),
              RuleSection(
                title: 'Special Rules',
                content:
                    '- Won sections are locked (marked with big X/O)\n'
                    '- Drawn sections become inactive\n'
                    '- Refresh button restarts current game',
              ),
              SizedBox(height: 20),
              _CloseButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text(
          'Close',
          style: TextStyle(
            color: AppColors.darkWood,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

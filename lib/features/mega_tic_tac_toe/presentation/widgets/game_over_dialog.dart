import 'package:flutter/material.dart';
import 'package:mega_tic_tac_toe/core/theme/app_colors.dart';

class GameOverDialog extends StatelessWidget {
  final String message;
  final VoidCallback onClose;
  final VoidCallback onPlayAgain;

  const GameOverDialog({
    super.key,
    required this.message,
    required this.onClose,
    required this.onPlayAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.lightWood,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.darkWood, width: 4),
          boxShadow: const <BoxShadow>[
            BoxShadow(color: Colors.black54, blurRadius: 15),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'Game Over',
              style: TextStyle(
                fontSize: 28,
                color: AppColors.darkWood,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              message,
              style: const TextStyle(
                fontSize: 24,
                color: AppColors.mediumWood,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextButton(
                  onPressed: onClose,
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      color: AppColors.darkWood,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onPlayAgain,
                  child: const Text(
                    'Play Again',
                    style: TextStyle(
                      color: AppColors.darkWood,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

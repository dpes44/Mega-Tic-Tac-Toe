import 'package:flutter/material.dart';
import 'package:mega_tic_tac_toe/core/theme/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mediumWood,
      appBar: AppBar(
        backgroundColor: AppColors.darkWood,
        foregroundColor: Colors.white,
        title: const Text('Privacy Policy'),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: _PrivacyPolicyContent(),
        ),
      ),
    );
  }
}

class _PrivacyPolicyContent extends StatelessWidget {
  const _PrivacyPolicyContent();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.lightWood,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Mega Tic-Tac-Toe Privacy Policy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkWood,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Effective Date: February 16, 2026',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.darkWood,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Mega Tic-Tac-Toe does not require account creation and does not intentionally collect personal data.',
              style: TextStyle(color: AppColors.darkWood),
            ),
            SizedBox(height: 12),
            Text(
              'What we process:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.darkWood,
              ),
            ),
            SizedBox(height: 6),
            Text(
              '- Basic in-app game state while the app is running.\n'
              '- Platform-provided crash and diagnostics data if enabled by your device settings.',
              style: TextStyle(color: AppColors.darkWood),
            ),
            SizedBox(height: 12),
            Text(
              'What we do not do:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.darkWood,
              ),
            ),
            SizedBox(height: 6),
            Text(
              '- No tracking across apps.\n'
              '- No sale of personal information.\n'
              '- No direct collection of payment or identity details.',
              style: TextStyle(color: AppColors.darkWood),
            ),
            SizedBox(height: 12),
            Text(
              'Data retention:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.darkWood,
              ),
            ),
            SizedBox(height: 6),
            Text(
              '- Gameplay data is stored only on your device via app settings.\n'
              '- You can clear app data at any time through device settings.',
              style: TextStyle(color: AppColors.darkWood),
            ),
            SizedBox(height: 12),
            Text(
              'Contact:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.darkWood,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'For privacy questions, contact: support@megatictactoe.app',
              style: TextStyle(color: AppColors.darkWood),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mega_tic_tac_toe/core/theme/app_colors.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mediumWood,
      appBar: AppBar(
        backgroundColor: AppColors.darkWood,
        foregroundColor: Colors.white,
        title: const Text('Terms & Conditions'),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: _TermsContent(),
        ),
      ),
    );
  }
}

class _TermsContent extends StatelessWidget {
  const _TermsContent();

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
              'Mega Tic-Tac-Toe Terms & Conditions',
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
              'By using this app, you agree to use it for personal, lawful purposes only.',
              style: TextStyle(color: AppColors.darkWood),
            ),
            SizedBox(height: 12),
            Text(
              'Usage rules:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.darkWood,
              ),
            ),
            SizedBox(height: 6),
            Text(
              '- Do not misuse, reverse-engineer, or attempt to disrupt app operation.\n'
              '- Respect applicable laws and app store policies.',
              style: TextStyle(color: AppColors.darkWood),
            ),
            SizedBox(height: 12),
            Text(
              'Disclaimer:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.darkWood,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'This app is provided "as is" without warranties of any kind. Availability and functionality may change without notice.',
              style: TextStyle(color: AppColors.darkWood),
            ),
            SizedBox(height: 12),
            Text(
              'Limitation of liability:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.darkWood,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'To the maximum extent permitted by law, the app authors are not liable for indirect, incidental, or consequential damages.',
              style: TextStyle(color: AppColors.darkWood),
            ),
            SizedBox(height: 12),
            Text(
              'Governing terms updates:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.darkWood,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'These terms may be updated over time. Continued use of the app after updates indicates acceptance of the revised terms.',
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
              'For legal inquiries, contact: support@megatictactoe.app',
              style: TextStyle(color: AppColors.darkWood),
            ),
          ],
        ),
      ),
    );
  }
}

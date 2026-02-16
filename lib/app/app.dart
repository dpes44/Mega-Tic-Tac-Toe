import 'package:flutter/material.dart';
import 'package:mega_tic_tac_toe/core/theme/app_colors.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/presentation/screens/main_menu_screen.dart';
import 'package:mega_tic_tac_toe/features/settings/application/settings_controller.dart';

class MegaTicTacToeApp extends StatelessWidget {
  final SettingsController settingsController;

  const MegaTicTacToeApp({super.key, required this.settingsController});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      primary: AppColors.accentDeep,
      secondary: AppColors.accent,
      surface: AppColors.panel,
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'Mega Tic-Tac-Toe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: AppColors.backgroundBottom,
        fontFamily: 'Georgia',
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentDeep,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: MainMenuScreen(settingsController: settingsController),
    );
  }
}

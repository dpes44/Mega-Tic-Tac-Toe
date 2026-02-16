import 'package:flutter/material.dart';
import 'package:mega_tic_tac_toe/app/app.dart';
import 'package:mega_tic_tac_toe/features/settings/application/settings_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SettingsController settingsController = SettingsController();
  await settingsController.load();
  runApp(MegaTicTacToeApp(settingsController: settingsController));
}

import 'package:flutter/material.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/presentation/screens/main_menu_screen.dart';

class MegaTicTacToeApp extends StatelessWidget {
  const MegaTicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mega Tic-Tac-Toe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const MainMenuScreen(),
    );
  }
}

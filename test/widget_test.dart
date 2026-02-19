import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mega_tic_tac_toe/app/app.dart';
import 'package:mega_tic_tac_toe/features/settings/application/settings_controller.dart';

void main() {
  testWidgets('main menu shows game options', (WidgetTester tester) async {
    await tester.pumpWidget(
      MegaTicTacToeApp(settingsController: SettingsController()),
    );

    expect(find.text('MEGA TIC-TAC-TOE'), findsOneWidget);
    expect(find.text('VS AI'), findsOneWidget);
    expect(find.text('VS Player'), findsOneWidget);
    expect(find.text('How to Play'), findsOneWidget);
    expect(find.text('Board Skins'), findsOneWidget);
    expect(find.text('Privacy Policy'), findsOneWidget);
    expect(find.text('Terms & Conditions'), findsOneWidget);
  });

  testWidgets('settings button is visible on main menu', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MegaTicTacToeApp(settingsController: SettingsController()),
    );

    expect(find.byIcon(Icons.settings_rounded), findsOneWidget);
  });
}

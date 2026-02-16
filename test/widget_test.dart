import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mega_tic_tac_toe/main.dart';

void main() {
  testWidgets('main menu shows game options', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainMenuScreen()));

    expect(find.text('Ultimate Tic-Tac-Toe'), findsOneWidget);
    expect(find.text('VS AI'), findsOneWidget);
    expect(find.text('VS Player'), findsOneWidget);
    expect(find.text('How to Play'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mega_tic_tac_toe/app/app.dart';

void main() {
  testWidgets('main menu shows game options', (WidgetTester tester) async {
    await tester.pumpWidget(const MegaTicTacToeApp());

    expect(find.text('Mega Tic-Tac-Toe'), findsOneWidget);
    expect(find.text('VS AI'), findsOneWidget);
    expect(find.text('VS Player'), findsOneWidget);
    expect(find.text('How to Play'), findsOneWidget);
    expect(find.text('Privacy Policy'), findsOneWidget);
    expect(find.text('Terms & Conditions'), findsOneWidget);
  });

  testWidgets('vs ai shows difficulty picker', (WidgetTester tester) async {
    await tester.pumpWidget(const MegaTicTacToeApp());

    await tester.tap(find.text('VS AI'));
    await tester.pumpAndSettle();

    expect(find.text('Choose AI Difficulty'), findsOneWidget);
    expect(find.text('Easy'), findsOneWidget);
    expect(find.text('Medium'), findsOneWidget);
    expect(find.text('Hard'), findsOneWidget);
  });
}

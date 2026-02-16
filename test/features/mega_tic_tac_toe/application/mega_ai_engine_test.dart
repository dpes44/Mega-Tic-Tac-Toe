import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/application/mega_ai_engine.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/ai_difficulty.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/board_move.dart';

import '../../../support/mega_state_builder.dart';

void main() {
  final MegaAiEngine ai = MegaAiEngine();

  group('MegaAiEngine.chooseMove', () {
    test('throws when no legal moves are available', () {
      final state = buildMegaState(sectionOwners: List<String>.filled(9, 'D'));

      expect(
        () => ai.chooseMove(
          state: state,
          difficulty: AiDifficulty.hard,
          random: Random(1),
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('returns the only legal move for every difficulty', () {
      final List<List<String>> cells = List<List<String>>.generate(
        9,
        (_) => List<String>.filled(9, ''),
      );
      final List<String> sectionOwners = <String>[
        'D',
        'D',
        '',
        'D',
        'D',
        'D',
        'D',
        'D',
        'D',
      ];
      cells[2] = <String>['X', 'O', 'X', 'X', 'O', '', 'O', 'X', 'O'];

      final state = buildMegaState(
        currentPlayer: 1,
        targetSection: 2,
        cells: cells,
        sectionOwners: sectionOwners,
      );

      for (final AiDifficulty difficulty in AiDifficulty.values) {
        final BoardMove move = ai.chooseMove(
          state: state,
          difficulty: difficulty,
          random: Random(42),
        );
        expect(move.section, 2);
        expect(move.cell, 5);
      }
    });

    test('hard difficulty takes immediate game-winning move', () {
      final List<List<String>> cells = List<List<String>>.generate(
        9,
        (_) => List<String>.filled(9, ''),
      );
      final List<String> sectionOwners = <String>[
        'O',
        'O',
        '',
        'D',
        'D',
        'D',
        'D',
        'D',
        'D',
      ];
      cells[2] = <String>['O', 'O', '', '', '', '', '', '', ''];

      final state = buildMegaState(
        currentPlayer: 1,
        targetSection: 2,
        cells: cells,
        sectionOwners: sectionOwners,
      );

      final BoardMove move = ai.chooseMove(
        state: state,
        difficulty: AiDifficulty.hard,
        random: Random(7),
      );

      expect(move.section, 2);
      expect(move.cell, 2);
    });
  });
}

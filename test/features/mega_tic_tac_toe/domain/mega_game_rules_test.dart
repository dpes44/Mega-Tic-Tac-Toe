import 'package:flutter_test/flutter_test.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/board_move.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/mega_game_rules.dart';

import '../../../support/mega_state_builder.dart';

void main() {
  group('MegaGameRules.resolveSectionOwner', () {
    test('returns winner for a completed line', () {
      final String owner = MegaGameRules.resolveSectionOwner(<String>[
        'X',
        'O',
        'O',
        '',
        'X',
        '',
        '',
        '',
        'X',
      ]);

      expect(owner, 'X');
    });

    test('returns draw for full board with no winner', () {
      final String owner = MegaGameRules.resolveSectionOwner(<String>[
        'X',
        'O',
        'X',
        'X',
        'O',
        'O',
        'O',
        'X',
        'X',
      ]);

      expect(owner, 'D');
    });
  });

  group('MegaGameRules.resolveMainWinner', () {
    test('ignores drawn sections and returns winner only for X/O lines', () {
      final String? winner = MegaGameRules.resolveMainWinner(<String>[
        'O',
        'O',
        'O',
        'D',
        'D',
        'X',
        'X',
        '',
        '',
      ]);

      expect(winner, 'O');
    });
  });

  group('MegaGameRules.availableMoves', () {
    test('restricts moves to target section when it is playable', () {
      final List<List<String>> cells = List<List<String>>.generate(
        9,
        (_) => List<String>.filled(9, ''),
      );
      cells[4] = <String>['X', '', '', '', 'O', '', '', '', 'X'];
      final state = buildMegaState(targetSection: 4, cells: cells);

      final List<BoardMove> moves = MegaGameRules.availableMoves(state);

      expect(moves, isNotEmpty);
      expect(moves.every((BoardMove move) => move.section == 4), isTrue);
      expect(
        moves.where(
          (BoardMove move) =>
              move.cell == 0 || move.cell == 4 || move.cell == 8,
        ),
        isEmpty,
      );
    });

    test('falls back to all open sections when target is full', () {
      final List<List<String>> cells = List<List<String>>.generate(
        9,
        (_) => List<String>.filled(9, ''),
      );
      cells[4] = <String>['X', 'O', 'X', 'X', 'O', 'O', 'O', 'X', 'X'];

      final state = buildMegaState(targetSection: 4, cells: cells);

      final List<BoardMove> moves = MegaGameRules.availableMoves(state);

      expect(moves, isNotEmpty);
      expect(moves.any((BoardMove move) => move.section == 4), isFalse);
      expect(moves.any((BoardMove move) => move.section == 0), isTrue);
    });
  });
}

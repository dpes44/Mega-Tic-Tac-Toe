import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/board_move.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/mega_game_state.dart';

class MegaGameRules {
  static const List<List<int>> _winPatterns = <List<int>>[
    <int>[0, 1, 2],
    <int>[3, 4, 5],
    <int>[6, 7, 8],
    <int>[0, 3, 6],
    <int>[1, 4, 7],
    <int>[2, 5, 8],
    <int>[0, 4, 8],
    <int>[2, 4, 6],
  ];

  static String resolveSectionOwner(List<String> cells) {
    for (final List<int> pattern in _winPatterns) {
      final String first = cells[pattern[0]];
      if (first.isEmpty) {
        continue;
      }
      if (first == cells[pattern[1]] && first == cells[pattern[2]]) {
        return first;
      }
    }

    if (!cells.contains('')) {
      return 'D';
    }
    return '';
  }

  static String? resolveMainWinner(List<String> sectionOwners) {
    for (final List<int> pattern in _winPatterns) {
      final String first = sectionOwners[pattern[0]];
      if (first.isEmpty || first == 'D') {
        continue;
      }
      if (first == sectionOwners[pattern[1]] &&
          first == sectionOwners[pattern[2]]) {
        return first;
      }
    }

    return null;
  }

  static List<BoardMove> availableMoves(MegaGameState state) {
    final List<BoardMove> moves = <BoardMove>[];
    final int? target = state.targetSection;

    if (target != null && state.sectionOwners[target].isEmpty) {
      for (int cell = 0; cell < 9; cell++) {
        if (state.cells[target][cell].isEmpty) {
          moves.add(BoardMove(section: target, cell: cell));
        }
      }
    }

    if (moves.isNotEmpty) {
      return moves;
    }

    for (int section = 0; section < 9; section++) {
      if (state.sectionOwners[section].isNotEmpty) {
        continue;
      }
      for (int cell = 0; cell < 9; cell++) {
        if (state.cells[section][cell].isEmpty) {
          moves.add(BoardMove(section: section, cell: cell));
        }
      }
    }

    return moves;
  }

  const MegaGameRules._();
}

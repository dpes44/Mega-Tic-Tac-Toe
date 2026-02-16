import 'dart:math';

import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/ai_difficulty.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/board_move.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/mega_game_rules.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/mega_game_state.dart';

class MegaAiEngine {
  static const int _positiveInfinity = 1000000000;
  static const int _negativeInfinity = -_positiveInfinity;

  BoardMove chooseMove({
    required MegaGameState state,
    required AiDifficulty difficulty,
    required Random random,
  }) {
    final List<BoardMove> legalMoves = MegaGameRules.availableMoves(state);
    if (legalMoves.isEmpty) {
      throw StateError('No legal moves available for AI.');
    }

    final _SimState root = _SimState.fromGameState(state);
    switch (difficulty) {
      case AiDifficulty.easy:
        return legalMoves[random.nextInt(legalMoves.length)];
      case AiDifficulty.medium:
        return _pickBySearch(
          root: root,
          random: random,
          depth: 2,
          randomness: 0.25,
          candidatePool: 3,
          timeBudgetMs: 250,
        );
      case AiDifficulty.hard:
        return _pickHard(root: root, random: random);
    }
  }

  BoardMove _pickHard({required _SimState root, required Random random}) {
    BoardMove? bestMove;
    final Stopwatch watch = Stopwatch()..start();
    const int timeBudgetMs = 1300;

    for (int depth = 3; depth <= 6; depth++) {
      try {
        final BoardMove candidate = _pickBySearch(
          root: root,
          random: random,
          depth: depth,
          randomness: 0,
          candidatePool: 1,
          timeBudgetMs: timeBudgetMs,
          watch: watch,
        );
        bestMove = candidate;
      } on _SearchTimeout {
        break;
      }
    }

    if (bestMove != null) {
      return bestMove;
    }

    return _pickBySearch(
      root: root,
      random: random,
      depth: 2,
      randomness: 0,
      candidatePool: 1,
      timeBudgetMs: 250,
    );
  }

  BoardMove _pickBySearch({
    required _SimState root,
    required Random random,
    required int depth,
    required double randomness,
    required int candidatePool,
    required int timeBudgetMs,
    Stopwatch? watch,
  }) {
    final Stopwatch timer = watch ?? (Stopwatch()..start());
    final List<BoardMove> moves = _legalMoves(root);
    final List<_ScoredMove> scored = <_ScoredMove>[];

    for (final BoardMove move in _orderedMoves(root, moves)) {
      _throwIfTimedOut(timer: timer, budgetMs: timeBudgetMs);
      final _SimState child = _applyMove(root, move);
      final int score = _minimax(
        state: child,
        depth: depth - 1,
        alpha: _negativeInfinity,
        beta: _positiveInfinity,
        ply: 1,
        timer: timer,
        budgetMs: timeBudgetMs,
      );
      scored.add(_ScoredMove(move: move, score: score));
    }

    scored.sort((a, b) => b.score.compareTo(a.score));
    final int poolSize = min(candidatePool, scored.length);
    final List<_ScoredMove> top = scored.take(poolSize).toList();

    if (top.length == 1 || randomness <= 0) {
      return top.first.move;
    }

    if (random.nextDouble() > randomness) {
      return top.first.move;
    }

    return top[random.nextInt(top.length)].move;
  }

  int _minimax({
    required _SimState state,
    required int depth,
    required int alpha,
    required int beta,
    required int ply,
    required Stopwatch timer,
    required int budgetMs,
  }) {
    _throwIfTimedOut(timer: timer, budgetMs: budgetMs);

    if (depth == 0 || state.isTerminal) {
      return _evaluateState(state, ply);
    }

    final List<BoardMove> moves = _orderedMoves(state, _legalMoves(state));
    if (moves.isEmpty) {
      return _evaluateState(state, ply);
    }

    if (state.currentPlayer == 1) {
      int best = _negativeInfinity;
      int localAlpha = alpha;

      for (final BoardMove move in moves) {
        final int value = _minimax(
          state: _applyMove(state, move),
          depth: depth - 1,
          alpha: localAlpha,
          beta: beta,
          ply: ply + 1,
          timer: timer,
          budgetMs: budgetMs,
        );
        best = max(best, value);
        localAlpha = max(localAlpha, value);
        if (localAlpha >= beta) {
          break;
        }
      }
      return best;
    }

    int best = _positiveInfinity;
    int localBeta = beta;

    for (final BoardMove move in moves) {
      final int value = _minimax(
        state: _applyMove(state, move),
        depth: depth - 1,
        alpha: alpha,
        beta: localBeta,
        ply: ply + 1,
        timer: timer,
        budgetMs: budgetMs,
      );
      best = min(best, value);
      localBeta = min(localBeta, value);
      if (alpha >= localBeta) {
        break;
      }
    }
    return best;
  }

  int _evaluateState(_SimState state, int ply) {
    if (state.winner == 'O') {
      return 1000000 - (ply * 100);
    }
    if (state.winner == 'X') {
      return -1000000 + (ply * 100);
    }
    if (state.isDraw) {
      return 0;
    }

    int score = 0;
    score +=
        _evaluateLineSet(
          values: state.sectionOwners,
          xSymbol: 'X',
          oSymbol: 'O',
          weights: const <int>[0, 20, 120, 3000],
          ignoreSymbol: 'D',
        ) *
        50;

    for (int section = 0; section < 9; section++) {
      final int importance = _sectionImportance(section);
      final String owner = state.sectionOwners[section];

      if (owner == 'O') {
        score += 1200 * importance;
        continue;
      }
      if (owner == 'X') {
        score -= 1200 * importance;
        continue;
      }
      if (owner == 'D') {
        continue;
      }

      final List<String> cells = state.cells[section];
      score +=
          _evaluateLineSet(
            values: cells,
            xSymbol: 'X',
            oSymbol: 'O',
            weights: const <int>[0, 3, 20, 180],
          ) *
          importance;
      score += _positionBonus(cells) * importance;
    }

    if (state.targetSection != null) {
      final int target = state.targetSection!;
      if (state.sectionOwners[target].isEmpty) {
        score +=
            _evaluateLineSet(
              values: state.cells[target],
              xSymbol: 'X',
              oSymbol: 'O',
              weights: const <int>[0, 4, 28, 220],
            ) *
            2;
      }
    }

    return score;
  }

  int _evaluateLineSet({
    required List<String> values,
    required String xSymbol,
    required String oSymbol,
    required List<int> weights,
    String? ignoreSymbol,
  }) {
    const List<List<int>> patterns = <List<int>>[
      <int>[0, 1, 2],
      <int>[3, 4, 5],
      <int>[6, 7, 8],
      <int>[0, 3, 6],
      <int>[1, 4, 7],
      <int>[2, 5, 8],
      <int>[0, 4, 8],
      <int>[2, 4, 6],
    ];

    int score = 0;
    for (final List<int> pattern in patterns) {
      int xCount = 0;
      int oCount = 0;
      bool blocked = false;
      for (final int i in pattern) {
        final String value = values[i];
        if (ignoreSymbol != null && value == ignoreSymbol) {
          blocked = true;
          break;
        }
        if (value == xSymbol) {
          xCount++;
        } else if (value == oSymbol) {
          oCount++;
        }
      }

      if (blocked || (xCount > 0 && oCount > 0)) {
        continue;
      }

      if (oCount > 0) {
        score += weights[oCount];
      } else if (xCount > 0) {
        score -= weights[xCount];
      }
    }

    return score;
  }

  int _positionBonus(List<String> cells) {
    int score = 0;
    if (cells[4] == 'O') {
      score += 6;
    } else if (cells[4] == 'X') {
      score -= 6;
    }

    const List<int> corners = <int>[0, 2, 6, 8];
    for (final int i in corners) {
      if (cells[i] == 'O') {
        score += 2;
      } else if (cells[i] == 'X') {
        score -= 2;
      }
    }
    return score;
  }

  int _sectionImportance(int index) {
    if (index == 4) {
      return 4;
    }
    if (index == 0 || index == 2 || index == 6 || index == 8) {
      return 3;
    }
    return 2;
  }

  List<BoardMove> _orderedMoves(_SimState state, List<BoardMove> moves) {
    final List<_ScoredMove> scored = moves.map<_ScoredMove>((BoardMove move) {
      int score = 0;

      if (move.cell == 4) {
        score += 10;
      } else if (move.cell == 0 ||
          move.cell == 2 ||
          move.cell == 6 ||
          move.cell == 8) {
        score += 6;
      }

      final _SimState child = _applyMove(state, move);
      if (child.winner == 'O') {
        score += 100000;
      } else if (child.winner == 'X') {
        score -= 100000;
      }
      if (child.sectionOwners[move.section] == 'O') {
        score += 1500;
      } else if (child.sectionOwners[move.section] == 'X') {
        score -= 1500;
      }
      score += _evaluateState(child, 0) ~/ 25;

      return _ScoredMove(move: move, score: score);
    }).toList();

    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.map((_ScoredMove value) => value.move).toList();
  }

  List<BoardMove> _legalMoves(_SimState state) {
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

  _SimState _applyMove(_SimState state, BoardMove move) {
    final List<List<String>> nextCells = state.copyCells();
    final List<String> nextOwners = List<String>.from(state.sectionOwners);
    final String symbol = state.currentPlayer == 0 ? 'X' : 'O';

    nextCells[move.section][move.cell] = symbol;
    final String sectionOwner = MegaGameRules.resolveSectionOwner(
      nextCells[move.section],
    );
    if (sectionOwner.isNotEmpty) {
      nextOwners[move.section] = sectionOwner;
    }

    final String? winner = MegaGameRules.resolveMainWinner(nextOwners);
    final bool draw =
        winner == null && nextOwners.every((String owner) => owner.isNotEmpty);

    int? nextTarget;
    if (winner == null && !draw) {
      final bool isTargetPlayable =
          nextOwners[move.cell].isEmpty && nextCells[move.cell].contains('');
      nextTarget = isTargetPlayable ? move.cell : null;
    }

    return _SimState(
      cells: nextCells,
      sectionOwners: nextOwners,
      currentPlayer: (state.currentPlayer + 1) % 2,
      targetSection: nextTarget,
      winner: winner,
      isDraw: draw,
    );
  }

  void _throwIfTimedOut({required Stopwatch timer, required int budgetMs}) {
    if (timer.elapsedMilliseconds > budgetMs) {
      throw const _SearchTimeout();
    }
  }
}

class _SimState {
  final List<List<String>> cells;
  final List<String> sectionOwners;
  final int currentPlayer;
  final int? targetSection;
  final String? winner;
  final bool isDraw;

  const _SimState({
    required this.cells,
    required this.sectionOwners,
    required this.currentPlayer,
    required this.targetSection,
    required this.winner,
    required this.isDraw,
  });

  factory _SimState.fromGameState(MegaGameState state) {
    return _SimState(
      cells: state.copyCellsMutable(),
      sectionOwners: state.copySectionOwnersMutable(),
      currentPlayer: state.currentPlayer,
      targetSection: state.targetSection,
      winner: null,
      isDraw: false,
    );
  }

  bool get isTerminal => winner != null || isDraw;

  List<List<String>> copyCells() {
    return cells
        .map((List<String> section) => List<String>.from(section))
        .toList();
  }
}

class _ScoredMove {
  final BoardMove move;
  final int score;

  const _ScoredMove({required this.move, required this.score});
}

class _SearchTimeout implements Exception {
  const _SearchTimeout();
}

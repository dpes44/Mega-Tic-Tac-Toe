// ignore_for_file: avoid_print

import 'dart:math';

import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/application/mega_ai_engine.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/ai_difficulty.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/board_move.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/mega_game_rules.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/mega_game_state.dart';

void main(List<String> args) {
  final int games = _readIntArg(args, '--games', 60);
  final int seed = _readIntArg(args, '--seed', 1337);
  final MegaAiEngine engine = MegaAiEngine();
  final Random random = Random(seed);

  final List<_Matchup> matchups = <_Matchup>[
    _Matchup(name: 'Random (X) vs Easy AI (O)', oDifficulty: AiDifficulty.easy),
    _Matchup(
      name: 'Random (X) vs Medium AI (O)',
      oDifficulty: AiDifficulty.medium,
    ),
    _Matchup(name: 'Random (X) vs Hard AI (O)', oDifficulty: AiDifficulty.hard),
  ];

  print('AI balance simulation');
  print('Games per matchup: $games | Seed: $seed');
  print('');

  for (final _Matchup matchup in matchups) {
    final _SimulationReport report = _runMatchup(
      engine: engine,
      random: random,
      games: games,
      matchup: matchup,
    );
    _printReport(report);
  }
}

_SimulationReport _runMatchup({
  required MegaAiEngine engine,
  required Random random,
  required int games,
  required _Matchup matchup,
}) {
  int xWins = 0;
  int oWins = 0;
  int draws = 0;
  int totalMoves = 0;
  int xTurns = 0;
  int oTurns = 0;
  int xMillis = 0;
  int oMillis = 0;

  for (int game = 0; game < games; game++) {
    MegaGameState state = MegaGameState.initial(vsAi: true);
    String? winner;
    int movesInGame = 0;

    while (!state.gameOver) {
      final bool xTurn = state.currentPlayer == 0;
      final BoardMove move;
      final Stopwatch watch = Stopwatch()..start();
      if (xTurn) {
        final List<BoardMove> legalMoves = MegaGameRules.availableMoves(state);
        move = legalMoves[random.nextInt(legalMoves.length)];
      } else {
        move = engine.chooseMove(
          state: state,
          difficulty: matchup.oDifficulty,
          random: random,
        );
      }
      watch.stop();
      movesInGame++;

      if (xTurn) {
        xTurns++;
        xMillis += watch.elapsedMilliseconds;
      } else {
        oTurns++;
        oMillis += watch.elapsedMilliseconds;
      }

      final _Transition transition = _applyMove(state, move);
      state = transition.nextState;
      winner = transition.winner;
    }

    totalMoves += movesInGame;

    if (winner == 'X') {
      xWins++;
    } else if (winner == 'O') {
      oWins++;
    } else {
      draws++;
    }
  }

  return _SimulationReport(
    name: matchup.name,
    games: games,
    xWins: xWins,
    oWins: oWins,
    draws: draws,
    averageMovesPerGame: totalMoves / games,
    averageXDecisionMs: xTurns == 0 ? 0 : xMillis / xTurns,
    averageODecisionMs: oTurns == 0 ? 0 : oMillis / oTurns,
  );
}

void _printReport(_SimulationReport report) {
  final String xRate = (report.xWins * 100 / report.games).toStringAsFixed(1);
  final String oRate = (report.oWins * 100 / report.games).toStringAsFixed(1);
  final String dRate = (report.draws * 100 / report.games).toStringAsFixed(1);

  print(report.name);
  print(
    '  Results: X ${report.xWins} ($xRate%) | O ${report.oWins} ($oRate%) | Draw ${report.draws} ($dRate%)',
  );
  print('  Avg moves/game: ${report.averageMovesPerGame.toStringAsFixed(1)}');
  print(
    '  Avg X think time: ${report.averageXDecisionMs.toStringAsFixed(2)} ms',
  );
  print(
    '  Avg O think time: ${report.averageODecisionMs.toStringAsFixed(2)} ms',
  );
  print('');
}

_Transition _applyMove(MegaGameState state, BoardMove move) {
  final List<List<String>> nextCells = state.copyCellsMutable();
  final List<String> nextOwners = state.copySectionOwnersMutable();
  final String symbol = state.currentPlayer == 0 ? 'X' : 'O';

  nextCells[move.section][move.cell] = symbol;
  final String sectionOwner = MegaGameRules.resolveSectionOwner(
    nextCells[move.section],
  );
  if (sectionOwner.isNotEmpty) {
    nextOwners[move.section] = sectionOwner;
  }

  final String? winner = MegaGameRules.resolveMainWinner(nextOwners);
  final bool isDraw =
      winner == null && nextOwners.every((String owner) => owner.isNotEmpty);

  int? nextTarget;
  if (winner == null && !isDraw) {
    final bool targetPlayable =
        nextOwners[move.cell].isEmpty && nextCells[move.cell].contains('');
    nextTarget = targetPlayable ? move.cell : null;
  }

  final MegaGameState nextState = state.copyWith(
    cells: nextCells,
    sectionOwners: nextOwners,
    currentPlayer: (state.currentPlayer + 1) % 2,
    targetSection: nextTarget,
    gameOver: winner != null || isDraw,
  );

  return _Transition(nextState: nextState, winner: winner);
}

int _readIntArg(List<String> args, String flag, int fallback) {
  final int index = args.indexOf(flag);
  if (index == -1 || index + 1 >= args.length) {
    return fallback;
  }
  return int.tryParse(args[index + 1]) ?? fallback;
}

class _Matchup {
  final String name;
  final AiDifficulty oDifficulty;

  const _Matchup({required this.name, required this.oDifficulty});
}

class _SimulationReport {
  final String name;
  final int games;
  final int xWins;
  final int oWins;
  final int draws;
  final double averageMovesPerGame;
  final double averageXDecisionMs;
  final double averageODecisionMs;

  const _SimulationReport({
    required this.name,
    required this.games,
    required this.xWins,
    required this.oWins,
    required this.draws,
    required this.averageMovesPerGame,
    required this.averageXDecisionMs,
    required this.averageODecisionMs,
  });
}

class _Transition {
  final MegaGameState nextState;
  final String? winner;

  const _Transition({required this.nextState, required this.winner});
}

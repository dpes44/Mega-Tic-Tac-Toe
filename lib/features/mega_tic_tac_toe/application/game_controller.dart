import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/application/mega_ai_engine.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/ai_difficulty.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/board_move.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/mega_game_rules.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/mega_game_state.dart';

class GameController extends ChangeNotifier {
  final Random _random;
  final MegaAiEngine _aiEngine;
  final AiDifficulty aiDifficulty;
  MegaGameState _state;
  Timer? _aiMoveTimer;
  String? _pendingGameOverMessage;

  GameController({
    required bool vsAi,
    this.aiDifficulty = AiDifficulty.medium,
    Random? random,
    MegaAiEngine? aiEngine,
  }) : _random = random ?? Random(),
       _aiEngine = aiEngine ?? MegaAiEngine(),
       _state = MegaGameState.initial(vsAi: vsAi);

  MegaGameState get state => _state;

  String? consumePendingGameOverMessage() {
    final String? message = _pendingGameOverMessage;
    _pendingGameOverMessage = null;
    return message;
  }

  void makeMove(int section, int cell) {
    if (!_isMoveAllowed(section, cell)) {
      return;
    }

    final List<List<String>> updatedCells = _state.copyCellsMutable();
    final List<String> updatedOwners = _state.copySectionOwnersMutable();
    updatedCells[section][cell] = _state.isPlayerXTurn ? 'X' : 'O';

    _resolveSectionOutcome(section, updatedCells, updatedOwners);

    final String? mainWinner = MegaGameRules.resolveMainWinner(updatedOwners);
    if (mainWinner != null) {
      _state = _state.copyWith(
        cells: updatedCells,
        sectionOwners: updatedOwners,
        gameOver: true,
      );
      _pendingGameOverMessage = _winnerMessage(mainWinner);
      notifyListeners();
      return;
    }

    if (updatedOwners.every((String owner) => owner.isNotEmpty)) {
      _state = _state.copyWith(
        cells: updatedCells,
        sectionOwners: updatedOwners,
        gameOver: true,
      );
      _pendingGameOverMessage = 'Draw!';
      notifyListeners();
      return;
    }

    _state = _state.copyWith(
      cells: updatedCells,
      sectionOwners: updatedOwners,
      targetSection: _nextTargetSection(cell, updatedCells, updatedOwners),
      currentPlayer: (_state.currentPlayer + 1) % 2,
    );
    notifyListeners();

    if (_state.isAiTurn) {
      _scheduleAiMove();
    }
  }

  void resetGame() {
    _aiMoveTimer?.cancel();
    _pendingGameOverMessage = null;
    _state = MegaGameState.initial(vsAi: _state.vsAi);
    notifyListeners();
  }

  bool _isMoveAllowed(int section, int cell) {
    if (_state.gameOver) {
      return false;
    }
    if (_state.sectionOwners[section].isNotEmpty) {
      return false;
    }
    if (_state.cells[section][cell].isNotEmpty) {
      return false;
    }
    if (_state.targetSection != null && _state.targetSection != section) {
      return false;
    }
    return true;
  }

  void _resolveSectionOutcome(
    int section,
    List<List<String>> cells,
    List<String> owners,
  ) {
    final String owner = MegaGameRules.resolveSectionOwner(cells[section]);
    if (owner.isNotEmpty) {
      owners[section] = owner;
    }
  }

  int? _nextTargetSection(
    int cell,
    List<List<String>> cells,
    List<String> owners,
  ) {
    final bool isPlayable = owners[cell].isEmpty && cells[cell].contains('');
    return isPlayable ? cell : null;
  }

  void _scheduleAiMove() {
    _aiMoveTimer?.cancel();
    _aiMoveTimer = Timer(const Duration(milliseconds: 500), () {
      if (_state.gameOver || !_state.isAiTurn) {
        return;
      }
      final List<BoardMove> moves = MegaGameRules.availableMoves(_state);
      if (moves.isEmpty) {
        return;
      }
      final BoardMove move = _aiEngine.chooseMove(
        state: _state,
        difficulty: aiDifficulty,
        random: _random,
      );
      makeMove(move.section, move.cell);
    });
  }

  String _winnerMessage(String symbol) {
    if (symbol == 'X') {
      return 'Player X Wins!';
    }
    if (_state.vsAi) {
      return 'AI Wins!';
    }
    return 'Player O Wins!';
  }

  @override
  void dispose() {
    _aiMoveTimer?.cancel();
    super.dispose();
  }
}

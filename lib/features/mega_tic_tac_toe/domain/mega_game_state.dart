import 'package:flutter/foundation.dart';

@immutable
class MegaGameState {
  final List<List<String>> cells;
  final List<String> sectionOwners;
  final int currentPlayer;
  final int? targetSection;
  final bool gameOver;
  final bool vsAi;

  MegaGameState._({
    required List<List<String>> cells,
    required List<String> sectionOwners,
    required this.currentPlayer,
    required this.targetSection,
    required this.gameOver,
    required this.vsAi,
  }) : cells = List<List<String>>.unmodifiable(
         cells.map((section) => List<String>.unmodifiable(section)),
       ),
       sectionOwners = List<String>.unmodifiable(sectionOwners);

  factory MegaGameState.initial({required bool vsAi}) {
    return MegaGameState._(
      cells: List<List<String>>.generate(9, (_) => List<String>.filled(9, '')),
      sectionOwners: List<String>.filled(9, ''),
      currentPlayer: 0,
      targetSection: null,
      gameOver: false,
      vsAi: vsAi,
    );
  }

  MegaGameState copyWith({
    List<List<String>>? cells,
    List<String>? sectionOwners,
    int? currentPlayer,
    Object? targetSection = _targetNotSet,
    bool? gameOver,
  }) {
    return MegaGameState._(
      cells: cells ?? this.cells,
      sectionOwners: sectionOwners ?? this.sectionOwners,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      targetSection: identical(targetSection, _targetNotSet)
          ? this.targetSection
          : targetSection as int?,
      gameOver: gameOver ?? this.gameOver,
      vsAi: vsAi,
    );
  }

  bool get isPlayerXTurn => currentPlayer == 0;

  bool get isAiTurn => vsAi && !isPlayerXTurn;

  bool isSectionLocked(int section) => sectionOwners[section].isNotEmpty;

  bool isSectionActive(int section) {
    if (isSectionLocked(section)) {
      return false;
    }
    return targetSection == null || targetSection == section;
  }

  List<List<String>> copyCellsMutable() {
    return cells.map((section) => List<String>.from(section)).toList();
  }

  List<String> copySectionOwnersMutable() {
    return List<String>.from(sectionOwners);
  }
}

const Object _targetNotSet = Object();

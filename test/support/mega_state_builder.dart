import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/mega_game_state.dart';

MegaGameState buildMegaState({
  bool vsAi = true,
  List<List<String>>? cells,
  List<String>? sectionOwners,
  int currentPlayer = 0,
  int? targetSection,
  bool gameOver = false,
}) {
  final MegaGameState base = MegaGameState.initial(vsAi: vsAi);
  return base.copyWith(
    cells: cells ?? base.copyCellsMutable(),
    sectionOwners: sectionOwners ?? base.copySectionOwnersMutable(),
    currentPlayer: currentPlayer,
    targetSection: targetSection,
    gameOver: gameOver,
  );
}

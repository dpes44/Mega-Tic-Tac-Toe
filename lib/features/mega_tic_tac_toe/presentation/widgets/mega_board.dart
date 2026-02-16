import 'package:flutter/material.dart';
import 'package:mega_tic_tac_toe/core/theme/app_colors.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/mega_game_state.dart';

class MegaBoard extends StatelessWidget {
  final MegaGameState state;
  final void Function(int section, int cell) onCellTap;

  const MegaBoard({super.key, required this.state, required this.onCellTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 9,
      itemBuilder: (BuildContext context, int section) =>
          _SectionTile(section: section, state: state, onCellTap: onCellTap),
    );
  }
}

class _SectionTile extends StatelessWidget {
  final int section;
  final MegaGameState state;
  final void Function(int section, int cell) onCellTap;

  const _SectionTile({
    required this.section,
    required this.state,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    final String owner = state.sectionOwners[section];
    final bool isLocked = owner.isNotEmpty;
    final bool isActive = state.isSectionActive(section);

    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.darkWood, width: 4),
            color: _sectionColor(owner),
            borderRadius: BorderRadius.circular(8),
          ),
          child: GridView.builder(
            padding: const EdgeInsets.all(4),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
            ),
            itemCount: 9,
            itemBuilder: (BuildContext context, int cell) => _CellTile(
              section: section,
              cell: cell,
              isSectionLocked: isLocked,
              isSectionActive: isActive,
              symbol: state.cells[section][cell],
              isPlayerXTurn: state.isPlayerXTurn,
              vsAi: state.vsAi,
              onTap: onCellTap,
            ),
          ),
        ),
        if (owner == 'X' || owner == 'O')
          Center(
            child: Text(
              owner,
              style: TextStyle(
                fontSize: 64,
                color: owner == 'X' ? Colors.red : Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Color _sectionColor(String owner) {
    if (owner == 'D') {
      return Colors.grey.withValues(alpha: 0.4);
    }
    return AppColors.lightWood;
  }
}

class _CellTile extends StatelessWidget {
  final int section;
  final int cell;
  final bool isSectionLocked;
  final bool isSectionActive;
  final String symbol;
  final bool isPlayerXTurn;
  final bool vsAi;
  final void Function(int section, int cell) onTap;

  const _CellTile({
    required this.section,
    required this.cell,
    required this.isSectionLocked,
    required this.isSectionActive,
    required this.symbol,
    required this.isPlayerXTurn,
    required this.vsAi,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCellActive =
        !isSectionLocked && isSectionActive && (vsAi ? isPlayerXTurn : true);

    return GestureDetector(
      onTap: isCellActive ? () => onTap(section, cell) : null,
      child: Container(
        color: isCellActive ? AppColors.activeCell : Colors.grey[300],
        child: Center(
          child: Text(
            symbol,
            style: TextStyle(
              fontSize: 28,
              color: symbol == 'X' ? Colors.red : Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

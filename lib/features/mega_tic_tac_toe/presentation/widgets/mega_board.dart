import 'package:flutter/material.dart';
import 'package:mega_tic_tac_toe/core/theme/app_colors.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/mega_game_state.dart';

class MegaBoard extends StatelessWidget {
  final MegaGameState state;
  final bool animationsEnabled;
  final void Function(int section, int cell) onCellTap;

  const MegaBoard({
    super.key,
    required this.state,
    required this.animationsEnabled,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppColors.panel, AppColors.panelSoft],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.boardFrame, width: 2),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (BuildContext context, int section) => _SectionTile(
          section: section,
          state: state,
          animationsEnabled: animationsEnabled,
          onCellTap: onCellTap,
        ),
      ),
    );
  }
}

class _SectionTile extends StatelessWidget {
  final int section;
  final MegaGameState state;
  final bool animationsEnabled;
  final void Function(int section, int cell) onCellTap;

  const _SectionTile({
    required this.section,
    required this.state,
    required this.animationsEnabled,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    final String owner = state.sectionOwners[section];
    final bool isLocked = owner.isNotEmpty;
    final bool isActive = state.isSectionActive(section);
    final bool isDimmed = !isLocked && state.targetSection != null && !isActive;
    final Duration duration = animationsEnabled
        ? const Duration(milliseconds: 180)
        : Duration.zero;

    return AnimatedOpacity(
      duration: duration,
      opacity: isDimmed ? 0.52 : 1,
      child: Stack(
        children: <Widget>[
          AnimatedContainer(
            duration: duration,
            decoration: BoxDecoration(
              border: Border.all(
                color: isActive ? AppColors.accentDeep : AppColors.boardFrame,
                width: isActive ? 2.5 : 1.5,
              ),
              color: _sectionColor(owner),
              borderRadius: BorderRadius.circular(12),
              boxShadow: isActive
                  ? <BoxShadow>[
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.22),
                        blurRadius: 14,
                        spreadRadius: 0,
                      ),
                    ]
                  : const <BoxShadow>[],
            ),
            child: GridView.builder(
              padding: const EdgeInsets.all(5),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
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
                  fontSize: 62,
                  color: owner == 'X' ? AppColors.xMark : AppColors.oMark,
                  fontWeight: FontWeight.w900,
                  shadows: const <Shadow>[
                    Shadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
          if (owner == 'D')
            const Center(
              child: Icon(
                Icons.horizontal_rule_rounded,
                size: 56,
                color: AppColors.textMuted,
              ),
            ),
        ],
      ),
    );
  }

  Color _sectionColor(String owner) {
    if (owner == 'D') {
      return AppColors.boardSectionDraw;
    }
    if (owner == 'X' || owner == 'O') {
      return AppColors.boardSectionLocked;
    }
    return AppColors.boardSection;
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

    return Material(
      color: isCellActive ? AppColors.cellActive : AppColors.cellInactive,
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: isCellActive ? () => onTap(section, cell) : null,
        child: Center(
          child: Text(
            symbol,
            style: TextStyle(
              fontSize: 24,
              color: symbol == 'X' ? AppColors.xMark : AppColors.oMark,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

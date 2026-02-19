import 'package:flutter/material.dart';
import 'package:mega_tic_tac_toe/core/theme/app_colors.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/mega_game_state.dart';
import 'package:mega_tic_tac_toe/features/settings/domain/board_skin.dart';

class MegaBoard extends StatelessWidget {
  final MegaGameState state;
  final BoardSkin boardSkin;
  final void Function(int section, int cell) onCellTap;

  const MegaBoard({
    super.key,
    required this.state,
    required this.boardSkin,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    final _BoardSkinPalette palette = _BoardSkinPalette.fromSkin(boardSkin);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[palette.boardGradientStart, palette.boardGradientEnd],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.frame, width: 2),
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
          palette: palette,
          onCellTap: onCellTap,
        ),
      ),
    );
  }
}

class _SectionTile extends StatelessWidget {
  final int section;
  final MegaGameState state;
  final _BoardSkinPalette palette;
  final void Function(int section, int cell) onCellTap;

  const _SectionTile({
    required this.section,
    required this.state,
    required this.palette,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    final String owner = state.sectionOwners[section];
    final bool isLocked = owner.isNotEmpty;
    final bool isActive = state.isSectionActive(section);
    final bool isDimmed = !isLocked && state.targetSection != null && !isActive;
    const Duration duration = Duration(milliseconds: 180);

    return AnimatedOpacity(
      duration: duration,
      opacity: isDimmed ? 0.52 : 1,
      child: Stack(
        children: <Widget>[
          AnimatedContainer(
            duration: duration,
            decoration: BoxDecoration(
              border: Border.all(
                color: isActive ? palette.activeBorder : palette.frame,
                width: isActive ? 2.5 : 1.5,
              ),
              color: _sectionColor(owner),
              borderRadius: BorderRadius.circular(12),
              boxShadow: isActive
                  ? <BoxShadow>[
                      BoxShadow(
                        color: palette.activeGlow.withValues(alpha: 0.28),
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
                palette: palette,
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
                  color: owner == 'X' ? palette.xMark : palette.oMark,
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
            Center(
              child: Icon(
                Icons.horizontal_rule_rounded,
                size: 56,
                color: palette.drawMark,
              ),
            ),
        ],
      ),
    );
  }

  Color _sectionColor(String owner) {
    if (owner == 'D') {
      return palette.sectionDraw;
    }
    if (owner == 'X' || owner == 'O') {
      return palette.sectionLocked;
    }
    return palette.sectionOpen;
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
  final _BoardSkinPalette palette;
  final void Function(int section, int cell) onTap;

  const _CellTile({
    required this.section,
    required this.cell,
    required this.isSectionLocked,
    required this.isSectionActive,
    required this.symbol,
    required this.isPlayerXTurn,
    required this.vsAi,
    required this.palette,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCellActive =
        !isSectionLocked && isSectionActive && (vsAi ? isPlayerXTurn : true);

    return Material(
      color: isCellActive ? palette.cellActive : palette.cellInactive,
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: isCellActive ? () => onTap(section, cell) : null,
        child: Center(
          child: Text(
            symbol,
            style: TextStyle(
              fontSize: 24,
              color: symbol == 'X' ? palette.xMark : palette.oMark,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _BoardSkinPalette {
  final Color boardGradientStart;
  final Color boardGradientEnd;
  final Color frame;
  final Color sectionOpen;
  final Color sectionLocked;
  final Color sectionDraw;
  final Color cellActive;
  final Color cellInactive;
  final Color activeBorder;
  final Color activeGlow;
  final Color xMark;
  final Color oMark;
  final Color drawMark;

  const _BoardSkinPalette({
    required this.boardGradientStart,
    required this.boardGradientEnd,
    required this.frame,
    required this.sectionOpen,
    required this.sectionLocked,
    required this.sectionDraw,
    required this.cellActive,
    required this.cellInactive,
    required this.activeBorder,
    required this.activeGlow,
    required this.xMark,
    required this.oMark,
    required this.drawMark,
  });

  factory _BoardSkinPalette.fromSkin(BoardSkin skin) {
    switch (skin) {
      case BoardSkin.classic:
        return const _BoardSkinPalette(
          boardGradientStart: AppColors.panel,
          boardGradientEnd: AppColors.panelSoft,
          frame: AppColors.boardFrame,
          sectionOpen: AppColors.boardSection,
          sectionLocked: AppColors.boardSectionLocked,
          sectionDraw: AppColors.boardSectionDraw,
          cellActive: AppColors.cellActive,
          cellInactive: AppColors.cellInactive,
          activeBorder: AppColors.accentDeep,
          activeGlow: AppColors.accent,
          xMark: AppColors.xMark,
          oMark: AppColors.oMark,
          drawMark: AppColors.textMuted,
        );
      case BoardSkin.graphite:
        return const _BoardSkinPalette(
          boardGradientStart: Color(0xFFDADEE7),
          boardGradientEnd: Color(0xFFBCC5D3),
          frame: Color(0xFF38414E),
          sectionOpen: Color(0xFFF1F3F7),
          sectionLocked: Color(0xFFD7DEE8),
          sectionDraw: Color(0xFFBCC4D1),
          cellActive: Color(0xFFFFFFFF),
          cellInactive: Color(0xFFCBD2DE),
          activeBorder: Color(0xFF3F5A84),
          activeGlow: Color(0xFF6A88B8),
          xMark: Color(0xFF973C39),
          oMark: Color(0xFF2E4D84),
          drawMark: Color(0xFF4D5765),
        );
      case BoardSkin.forest:
        return const _BoardSkinPalette(
          boardGradientStart: Color(0xFFDFEAD8),
          boardGradientEnd: Color(0xFFBFD0B6),
          frame: Color(0xFF2F4839),
          sectionOpen: Color(0xFFF2F7ED),
          sectionLocked: Color(0xFFD5E0CE),
          sectionDraw: Color(0xFFB8C8B0),
          cellActive: Color(0xFFFFFFFF),
          cellInactive: Color(0xFFC8D4C3),
          activeBorder: Color(0xFF2D6E4F),
          activeGlow: Color(0xFF5A9C7B),
          xMark: Color(0xFFAB3D3A),
          oMark: Color(0xFF1E5B7E),
          drawMark: Color(0xFF496050),
        );
      case BoardSkin.midnight:
        return const _BoardSkinPalette(
          boardGradientStart: Color(0xFF222A3A),
          boardGradientEnd: Color(0xFF121927),
          frame: Color(0xFF6F88B2),
          sectionOpen: Color(0xFF2D3648),
          sectionLocked: Color(0xFF3C475E),
          sectionDraw: Color(0xFF566079),
          cellActive: Color(0xFF44506A),
          cellInactive: Color(0xFF2A3344),
          activeBorder: Color(0xFFA9C0F0),
          activeGlow: Color(0xFF7FA5EC),
          xMark: Color(0xFFFF7E7E),
          oMark: Color(0xFF8CC6FF),
          drawMark: Color(0xFFB3C5E3),
        );
      case BoardSkin.rosewood:
        return const _BoardSkinPalette(
          boardGradientStart: Color(0xFFE9D5CB),
          boardGradientEnd: Color(0xFFC7A793),
          frame: Color(0xFF55372F),
          sectionOpen: Color(0xFFF9EEE8),
          sectionLocked: Color(0xFFE5CCBF),
          sectionDraw: Color(0xFFD1B6A8),
          cellActive: Color(0xFFFFFAF7),
          cellInactive: Color(0xFFDDBFB1),
          activeBorder: Color(0xFF8F4C3A),
          activeGlow: Color(0xFFBF735F),
          xMark: Color(0xFF9F2F2A),
          oMark: Color(0xFF2D5D8A),
          drawMark: Color(0xFF7A594F),
        );
      case BoardSkin.oceanic:
        return const _BoardSkinPalette(
          boardGradientStart: Color(0xFFD3EAF0),
          boardGradientEnd: Color(0xFFA9CAD5),
          frame: Color(0xFF2A5360),
          sectionOpen: Color(0xFFEFF8FB),
          sectionLocked: Color(0xFFCEE2E9),
          sectionDraw: Color(0xFFB3CDD6),
          cellActive: Color(0xFFFFFFFF),
          cellInactive: Color(0xFFBFD7DF),
          activeBorder: Color(0xFF23718A),
          activeGlow: Color(0xFF3E95B0),
          xMark: Color(0xFFB63F39),
          oMark: Color(0xFF1E5E9A),
          drawMark: Color(0xFF4A6D79),
        );
      case BoardSkin.ivory:
        return const _BoardSkinPalette(
          boardGradientStart: Color(0xFFF8F4E9),
          boardGradientEnd: Color(0xFFE6DECD),
          frame: Color(0xFF5A5650),
          sectionOpen: Color(0xFFFFFDF7),
          sectionLocked: Color(0xFFEDE6D8),
          sectionDraw: Color(0xFFD9D2C3),
          cellActive: Color(0xFFFFFFFF),
          cellInactive: Color(0xFFE1DACC),
          activeBorder: Color(0xFF8A7A60),
          activeGlow: Color(0xFFBDA278),
          xMark: Color(0xFFB1433D),
          oMark: Color(0xFF2C5C96),
          drawMark: Color(0xFF6B665E),
        );
      case BoardSkin.ember:
        return const _BoardSkinPalette(
          boardGradientStart: Color(0xFFE7C6A6),
          boardGradientEnd: Color(0xFFCB8E63),
          frame: Color(0xFF4A2F24),
          sectionOpen: Color(0xFFF9E8D8),
          sectionLocked: Color(0xFFE2C4AC),
          sectionDraw: Color(0xFFCEAC92),
          cellActive: Color(0xFFFFF4EA),
          cellInactive: Color(0xFFD8B397),
          activeBorder: Color(0xFF964F2A),
          activeGlow: Color(0xFFC36A3B),
          xMark: Color(0xFFA9332D),
          oMark: Color(0xFF215F8E),
          drawMark: Color(0xFF6A4938),
        );
    }
  }
}

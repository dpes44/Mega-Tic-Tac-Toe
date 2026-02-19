import 'package:flutter/material.dart';
import 'package:mega_tic_tac_toe/core/theme/app_colors.dart';
import 'package:mega_tic_tac_toe/features/settings/application/settings_controller.dart';
import 'package:mega_tic_tac_toe/features/settings/domain/board_skin.dart';

class BoardSkinScreen extends StatelessWidget {
  final SettingsController settingsController;

  const BoardSkinScreen({super.key, required this.settingsController});

  @override
  Widget build(BuildContext context) {
    const double sectionSpacing = 20;
    const double titleSpacing = 10;
    const double contentSpacing = 8;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              AppColors.backgroundTop,
              AppColors.backgroundBottom,
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: settingsController,
            builder: (BuildContext context, Widget? _) {
              final settings = settingsController.settings;
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                    child: Row(
                      children: <Widget>[
                        IconButton.filledTonal(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_rounded),
                          color: AppColors.panel,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Board Skins',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.panel,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColors.accent.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Choose Board Style',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: titleSpacing),
                            Text(
                              'Current: ${settings.boardSkin.label}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: contentSpacing),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: BoardSkin.values
                                  .map(
                                    (BoardSkin skin) => _BoardSkinPreviewChip(
                                      skin: skin,
                                      selected: settings.boardSkin == skin,
                                      onTap: () =>
                                          settingsController.setBoardSkin(skin),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: sectionSpacing),
                            const Text(
                              'Your selected skin is applied instantly in game.',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BoardSkinPreviewChip extends StatelessWidget {
  final BoardSkin skin;
  final bool selected;
  final VoidCallback onTap;

  const _BoardSkinPreviewChip({
    required this.skin,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final _SkinPreviewPalette palette = _SkinPreviewPalette.fromSkin(skin);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 148,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.42),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.accentDeep : AppColors.textMuted,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    skin.label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 16,
                  color: selected ? AppColors.accentDeep : AppColors.textMuted,
                ),
              ],
            ),
            const SizedBox(height: 6),
            AspectRatio(
              aspectRatio: 1.35,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      palette.boardGradientStart,
                      palette.boardGradientEnd,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: palette.frame, width: 1.5),
                ),
                child: Column(
                  children: List<Widget>.generate(3, (int row) {
                    return Expanded(
                      child: Row(
                        children: List<Widget>.generate(3, (int col) {
                          final bool highlight = row == 1 && col == 1;
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: highlight
                                    ? palette.cellActive
                                    : palette.cellInactive,
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(
                                  color: highlight
                                      ? palette.activeBorder
                                      : palette.frame.withValues(alpha: 0.45),
                                  width: highlight ? 1 : 0.6,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              skin.description,
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _SkinPreviewPalette {
  final Color boardGradientStart;
  final Color boardGradientEnd;
  final Color frame;
  final Color cellActive;
  final Color cellInactive;
  final Color activeBorder;

  const _SkinPreviewPalette({
    required this.boardGradientStart,
    required this.boardGradientEnd,
    required this.frame,
    required this.cellActive,
    required this.cellInactive,
    required this.activeBorder,
  });

  factory _SkinPreviewPalette.fromSkin(BoardSkin skin) {
    switch (skin) {
      case BoardSkin.classic:
        return const _SkinPreviewPalette(
          boardGradientStart: AppColors.panel,
          boardGradientEnd: AppColors.panelSoft,
          frame: AppColors.boardFrame,
          cellActive: AppColors.cellActive,
          cellInactive: AppColors.cellInactive,
          activeBorder: AppColors.accentDeep,
        );
      case BoardSkin.graphite:
        return const _SkinPreviewPalette(
          boardGradientStart: Color(0xFFDADEE7),
          boardGradientEnd: Color(0xFFBCC5D3),
          frame: Color(0xFF38414E),
          cellActive: Color(0xFFFFFFFF),
          cellInactive: Color(0xFFCBD2DE),
          activeBorder: Color(0xFF3F5A84),
        );
      case BoardSkin.forest:
        return const _SkinPreviewPalette(
          boardGradientStart: Color(0xFFDFEAD8),
          boardGradientEnd: Color(0xFFBFD0B6),
          frame: Color(0xFF2F4839),
          cellActive: Color(0xFFFFFFFF),
          cellInactive: Color(0xFFC8D4C3),
          activeBorder: Color(0xFF2D6E4F),
        );
      case BoardSkin.midnight:
        return const _SkinPreviewPalette(
          boardGradientStart: Color(0xFF222A3A),
          boardGradientEnd: Color(0xFF121927),
          frame: Color(0xFF6F88B2),
          cellActive: Color(0xFF44506A),
          cellInactive: Color(0xFF2A3344),
          activeBorder: Color(0xFFA9C0F0),
        );
      case BoardSkin.rosewood:
        return const _SkinPreviewPalette(
          boardGradientStart: Color(0xFFE9D5CB),
          boardGradientEnd: Color(0xFFC7A793),
          frame: Color(0xFF55372F),
          cellActive: Color(0xFFFFFAF7),
          cellInactive: Color(0xFFDDBFB1),
          activeBorder: Color(0xFF8F4C3A),
        );
      case BoardSkin.oceanic:
        return const _SkinPreviewPalette(
          boardGradientStart: Color(0xFFD3EAF0),
          boardGradientEnd: Color(0xFFA9CAD5),
          frame: Color(0xFF2A5360),
          cellActive: Color(0xFFFFFFFF),
          cellInactive: Color(0xFFBFD7DF),
          activeBorder: Color(0xFF23718A),
        );
      case BoardSkin.ivory:
        return const _SkinPreviewPalette(
          boardGradientStart: Color(0xFFF8F4E9),
          boardGradientEnd: Color(0xFFE6DECD),
          frame: Color(0xFF5A5650),
          cellActive: Color(0xFFFFFFFF),
          cellInactive: Color(0xFFE1DACC),
          activeBorder: Color(0xFF8A7A60),
        );
      case BoardSkin.ember:
        return const _SkinPreviewPalette(
          boardGradientStart: Color(0xFFE7C6A6),
          boardGradientEnd: Color(0xFFCB8E63),
          frame: Color(0xFF4A2F24),
          cellActive: Color(0xFFFFF4EA),
          cellInactive: Color(0xFFD8B397),
          activeBorder: Color(0xFF964F2A),
        );
    }
  }
}

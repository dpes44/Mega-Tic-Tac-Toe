import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/ai_difficulty.dart';
import 'package:mega_tic_tac_toe/features/settings/domain/board_skin.dart';

class AppSettings {
  final AiDifficulty defaultAiDifficulty;
  final BoardSkin boardSkin;
  final bool backgroundMusicEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;

  const AppSettings({
    required this.defaultAiDifficulty,
    required this.boardSkin,
    required this.backgroundMusicEnabled,
    required this.soundEnabled,
    required this.vibrationEnabled,
  });

  const AppSettings.defaults()
    : defaultAiDifficulty = AiDifficulty.medium,
      boardSkin = BoardSkin.classic,
      backgroundMusicEnabled = true,
      soundEnabled = true,
      vibrationEnabled = true;

  AppSettings copyWith({
    AiDifficulty? defaultAiDifficulty,
    BoardSkin? boardSkin,
    bool? backgroundMusicEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) {
    return AppSettings(
      defaultAiDifficulty: defaultAiDifficulty ?? this.defaultAiDifficulty,
      boardSkin: boardSkin ?? this.boardSkin,
      backgroundMusicEnabled:
          backgroundMusicEnabled ?? this.backgroundMusicEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }
}

import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/ai_difficulty.dart';

class AppSettings {
  final AiDifficulty defaultAiDifficulty;
  final bool backgroundMusicEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;

  const AppSettings({
    required this.defaultAiDifficulty,
    required this.backgroundMusicEnabled,
    required this.soundEnabled,
    required this.vibrationEnabled,
  });

  const AppSettings.defaults()
    : defaultAiDifficulty = AiDifficulty.medium,
      backgroundMusicEnabled = true,
      soundEnabled = true,
      vibrationEnabled = true;

  AppSettings copyWith({
    AiDifficulty? defaultAiDifficulty,
    bool? backgroundMusicEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) {
    return AppSettings(
      defaultAiDifficulty: defaultAiDifficulty ?? this.defaultAiDifficulty,
      backgroundMusicEnabled:
          backgroundMusicEnabled ?? this.backgroundMusicEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }
}

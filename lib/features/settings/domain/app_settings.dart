import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/ai_difficulty.dart';

class AppSettings {
  final AiDifficulty defaultAiDifficulty;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool animationsEnabled;

  const AppSettings({
    required this.defaultAiDifficulty,
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.animationsEnabled,
  });

  const AppSettings.defaults()
    : defaultAiDifficulty = AiDifficulty.medium,
      soundEnabled = true,
      vibrationEnabled = true,
      animationsEnabled = true;

  AppSettings copyWith({
    AiDifficulty? defaultAiDifficulty,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? animationsEnabled,
  }) {
    return AppSettings(
      defaultAiDifficulty: defaultAiDifficulty ?? this.defaultAiDifficulty,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
    );
  }
}

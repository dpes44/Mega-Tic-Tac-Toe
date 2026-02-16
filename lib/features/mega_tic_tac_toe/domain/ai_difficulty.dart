enum AiDifficulty {
  easy,
  medium,
  hard;

  String get label {
    switch (this) {
      case AiDifficulty.easy:
        return 'Easy';
      case AiDifficulty.medium:
        return 'Medium';
      case AiDifficulty.hard:
        return 'Hard';
    }
  }

  String get description {
    switch (this) {
      case AiDifficulty.easy:
        return 'Mostly random moves';
      case AiDifficulty.medium:
        return 'Tactical with short look-ahead';
      case AiDifficulty.hard:
        return 'Deep strategic search';
    }
  }
}

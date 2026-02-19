import 'package:flutter/foundation.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/ai_difficulty.dart';
import 'package:mega_tic_tac_toe/features/settings/domain/app_settings.dart';
import 'package:mega_tic_tac_toe/features/settings/domain/board_skin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends ChangeNotifier {
  static const String _defaultDifficultyKey = 'default_ai_difficulty';
  static const String _boardSkinKey = 'board_skin';
  static const String _backgroundMusicEnabledKey = 'background_music_enabled';
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _vibrationEnabledKey = 'vibration_enabled';

  AppSettings _settings = const AppSettings.defaults();
  bool _isInitialized = false;

  AppSettings get settings => _settings;
  bool get isInitialized => _isInitialized;

  Future<void> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _settings = AppSettings(
      defaultAiDifficulty: _readDifficulty(
        prefs.getString(_defaultDifficultyKey),
      ),
      boardSkin: _readBoardSkin(prefs.getString(_boardSkinKey)),
      backgroundMusicEnabled: prefs.getBool(_backgroundMusicEnabledKey) ?? true,
      soundEnabled: prefs.getBool(_soundEnabledKey) ?? true,
      vibrationEnabled: prefs.getBool(_vibrationEnabledKey) ?? true,
    );
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> setDefaultAiDifficulty(AiDifficulty difficulty) async {
    if (_settings.defaultAiDifficulty == difficulty) {
      return;
    }
    _settings = _settings.copyWith(defaultAiDifficulty: difficulty);
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_defaultDifficultyKey, difficulty.name);
  }

  Future<void> setBoardSkin(BoardSkin skin) async {
    if (_settings.boardSkin == skin) {
      return;
    }
    _settings = _settings.copyWith(boardSkin: skin);
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_boardSkinKey, skin.name);
  }

  Future<void> setSoundEnabled(bool value) async {
    if (_settings.soundEnabled == value) {
      return;
    }
    _settings = _settings.copyWith(soundEnabled: value);
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEnabledKey, value);
  }

  Future<void> setBackgroundMusicEnabled(bool value) async {
    if (_settings.backgroundMusicEnabled == value) {
      return;
    }
    _settings = _settings.copyWith(backgroundMusicEnabled: value);
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_backgroundMusicEnabledKey, value);
  }

  Future<void> setVibrationEnabled(bool value) async {
    if (_settings.vibrationEnabled == value) {
      return;
    }
    _settings = _settings.copyWith(vibrationEnabled: value);
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vibrationEnabledKey, value);
  }

  AiDifficulty _readDifficulty(String? rawValue) {
    if (rawValue == null) {
      return AiDifficulty.medium;
    }
    return AiDifficulty.values.firstWhere(
      (AiDifficulty value) => value.name == rawValue,
      orElse: () => AiDifficulty.medium,
    );
  }

  BoardSkin _readBoardSkin(String? rawValue) {
    if (rawValue == null) {
      return BoardSkin.classic;
    }
    return BoardSkin.values.firstWhere(
      (BoardSkin value) => value.name == rawValue,
      orElse: () => BoardSkin.classic,
    );
  }
}

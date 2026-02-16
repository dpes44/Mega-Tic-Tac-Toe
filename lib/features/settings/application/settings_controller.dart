import 'package:flutter/foundation.dart';
import 'package:mega_tic_tac_toe/features/mega_tic_tac_toe/domain/ai_difficulty.dart';
import 'package:mega_tic_tac_toe/features/settings/domain/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends ChangeNotifier {
  static const String _defaultDifficultyKey = 'default_ai_difficulty';
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _vibrationEnabledKey = 'vibration_enabled';
  static const String _animationsEnabledKey = 'animations_enabled';

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
      soundEnabled: prefs.getBool(_soundEnabledKey) ?? true,
      vibrationEnabled: prefs.getBool(_vibrationEnabledKey) ?? true,
      animationsEnabled: prefs.getBool(_animationsEnabledKey) ?? true,
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

  Future<void> setSoundEnabled(bool value) async {
    if (_settings.soundEnabled == value) {
      return;
    }
    _settings = _settings.copyWith(soundEnabled: value);
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEnabledKey, value);
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

  Future<void> setAnimationsEnabled(bool value) async {
    if (_settings.animationsEnabled == value) {
      return;
    }
    _settings = _settings.copyWith(animationsEnabled: value);
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_animationsEnabledKey, value);
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
}

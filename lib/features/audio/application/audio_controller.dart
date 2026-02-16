import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:mega_tic_tac_toe/features/settings/application/settings_controller.dart';

class AudioController with WidgetsBindingObserver {
  AudioController._();

  static final AudioController instance = AudioController._();
  static const String _backgroundMusicAsset = 'audio/background_music.wav';
  static const String _tapBeepAsset = 'audio/tap_beep.wav';

  final AudioPlayer _backgroundPlayer = AudioPlayer(
    playerId: 'background_music',
  );
  final AudioPlayer _tapPlayer = AudioPlayer(playerId: 'tap_beep');
  final AudioContext _backgroundAudioContext = AudioContextConfig(
    focus: AudioContextConfigFocus.gain,
    stayAwake: false,
  ).build();
  final AudioContext _tapAudioContext = AudioContextConfig(
    focus: AudioContextConfigFocus.mixWithOthers,
  ).build();

  SettingsController? _settingsController;
  bool _initialized = false;
  bool _backgroundRunning = false;
  bool _backgroundSourceLoaded = false;
  bool _tapSourceLoaded = false;
  bool _isAppInForeground = true;

  Future<void> initialize(SettingsController settingsController) async {
    if (_initialized) {
      return;
    }

    _settingsController = settingsController;
    _settingsController!.addListener(_handleSettingsChanged);
    WidgetsBinding.instance.addObserver(this);

    await _backgroundPlayer.setPlayerMode(PlayerMode.mediaPlayer);
    await _backgroundPlayer.setAudioContext(_backgroundAudioContext);
    await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
    await _backgroundPlayer.setVolume(0.17);

    await _tapPlayer.setPlayerMode(PlayerMode.lowLatency);
    await _tapPlayer.setAudioContext(_tapAudioContext);
    await _tapPlayer.setReleaseMode(ReleaseMode.stop);
    await _tapPlayer.setVolume(0.9);
    await _tapPlayer.setSource(AssetSource(_tapBeepAsset));
    _tapSourceLoaded = true;

    _initialized = true;
    await _syncBackgroundMusic();
  }

  Future<void> playTapBeep() async {
    if (!_initialized) {
      return;
    }

    final settingsController = _settingsController;
    if (settingsController == null ||
        !settingsController.settings.soundEnabled) {
      return;
    }

    try {
      if (!_tapSourceLoaded) {
        await _tapPlayer.setSource(AssetSource(_tapBeepAsset));
        _tapSourceLoaded = true;
      }

      await _tapPlayer.seek(Duration.zero);
      await _tapPlayer.resume();
    } catch (_) {
      await _tapPlayer.play(
        AssetSource(_tapBeepAsset),
        mode: PlayerMode.lowLatency,
        ctx: _tapAudioContext,
      );
      _tapSourceLoaded = true;
    }
  }

  Future<void> _syncBackgroundMusic() async {
    if (!_initialized) {
      return;
    }
    final settingsController = _settingsController;
    if (settingsController == null) {
      return;
    }

    final bool shouldPlay =
        settingsController.settings.backgroundMusicEnabled &&
        _isAppInForeground;
    if (shouldPlay && !_backgroundRunning) {
      if (!_backgroundSourceLoaded) {
        await _backgroundPlayer.setSource(AssetSource(_backgroundMusicAsset));
        _backgroundSourceLoaded = true;
      }
      await _backgroundPlayer.resume();
      _backgroundRunning = true;
      return;
    }
    if (!shouldPlay && _backgroundRunning) {
      await _backgroundPlayer.pause();
      _backgroundRunning = false;
    }
  }

  void _handleSettingsChanged() {
    unawaited(_syncBackgroundMusic());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isAppInForeground = state == AppLifecycleState.resumed;
    unawaited(_syncBackgroundMusic());
  }

  Future<void> dispose() async {
    if (_settingsController != null) {
      _settingsController!.removeListener(_handleSettingsChanged);
    }
    WidgetsBinding.instance.removeObserver(this);
    await _backgroundPlayer.dispose();
    await _tapPlayer.dispose();
    _initialized = false;
    _backgroundRunning = false;
    _backgroundSourceLoaded = false;
    _tapSourceLoaded = false;
  }
}

import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global route observer to assist screens with RouteAware lifecycle.
final RouteObserver<ModalRoute<void>> audioRouteObserver =
    RouteObserver<ModalRoute<void>>();

/// BGM Track Constants
class BgmTrack {
  static const String splash = 'SplashScreen.mp3';
  static const String mainMenu = 'MainMenu.mp3';
  static const String belajar = 'BelajarMenu.mp3';
  static const String kamus = 'KamusMenu.mp3';
  static const String kuis = 'KuisMenu.mp3';
  static const String misiPilah = 'MisiPilahSampah.mp3';
  static const String penghargaan = 'Penghargaan.mp3';
  static const String misiPilahSampah =
    'assets/audio/MisiPilahSampah.mp3';
}

/// SFX Track Constants
class SfxTrack {
  static const String playButton = 'PlayButton.mp3';
  static const String buttonMenu = 'ButtonMenu.mp3';
  static const String softPop = 'sfx_soft_pop.mp3';
  static const String correctAnswer = 'sfx_correct_answer.mp3';
  static const String wrongAnswer = 'sfx_wrong_answer.mp3';
  static const String levelComplete = 'sfx_level_complete.mp3';
  static const String menuAppearChime = 'sfx_menu_appear_chime.mp3';
  static const String pageTransitionWhoosh = 'sfx_page_transition_whoosh.mp3';
  static const String sparkle = 'sfx_sparkle.mp3';
}

/// Centralized Audio Manager for SampaHore!
class AudioManager with WidgetsBindingObserver {
  static final AudioManager instance = AudioManager._internal();
  AudioManager._internal();

  static const String _prefBgmVolume = 'audio_bgm_volume';
  static const String _prefSfxVolume = 'audio_sfx_volume';
  static const String _prefBgmMuted = 'audio_bgm_muted';
  static const String _prefSfxMuted = 'audio_sfx_muted';

  late final AudioPlayer _bgmPlayer;
  final List<AudioPlayer> _sfxPlayers = [];
  int _sfxPoolIndex = 0;
  static const int _sfxPoolSize = 4;

  bool _initialized = false;
  bool _isAppInBackground = false;

  String? _currentBgmTrack;
  int _bgmTransitionToken = 0;

  // Comfortable child-friendly default volumes
  double _bgmVolume = 0.5;
  double _sfxVolume = 0.7;
  bool _isBgmMuted = false;
  bool _isSfxMuted = false;

  // Debouncing / throttling identical SFX (millis)
  final Map<String, int> _lastSfxPlayedTime = {};
  static const int _sfxDebounceMs = 120;

  // ValueNotifiers for audio settings reactivity
  final ValueNotifier<double> bgmVolumeNotifier = ValueNotifier<double>(0.5);
  final ValueNotifier<double> sfxVolumeNotifier = ValueNotifier<double>(0.7);
  final ValueNotifier<bool> bgmMutedNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> sfxMutedNotifier = ValueNotifier<bool>(false);

  double get bgmVolume => _bgmVolume;
  double get sfxVolume => _sfxVolume;
  bool get isBgmMuted => _isBgmMuted;
  bool get isSfxMuted => _isSfxMuted;
  String? get currentBgmTrack => _currentBgmTrack;

  /// Initialize Audio Manager, load saved settings and setup players.
  Future<void> init() async {
    if (_initialized) return;

    try {
      _bgmPlayer = AudioPlayer();
      _bgmPlayer.audioCache = AudioCache(prefix: 'assets/audio/');
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);

      for (int i = 0; i < _sfxPoolSize; i++) {
        final player = AudioPlayer();
        player.audioCache = AudioCache(prefix: 'assets/audio/');
        _sfxPlayers.add(player);
      }

      final prefs = await SharedPreferences.getInstance();
      _bgmVolume = prefs.getDouble(_prefBgmVolume) ?? 0.5;
      _sfxVolume = prefs.getDouble(_prefSfxVolume) ?? 0.7;
      _isBgmMuted = prefs.getBool(_prefBgmMuted) ?? false;
      _isSfxMuted = prefs.getBool(_prefSfxMuted) ?? false;

      bgmVolumeNotifier.value = _bgmVolume;
      sfxVolumeNotifier.value = _sfxVolume;
      bgmMutedNotifier.value = _isBgmMuted;
      sfxMutedNotifier.value = _isSfxMuted;

      WidgetsBinding.instance.addObserver(this);
      _initialized = true;
    } catch (e) {
      debugPrint('AudioManager init warning: $e');
      _initialized = true;
    }
  }

  /// Play background music with automatic loop, transition, and deduplication.
  Future<void> playBgm(String trackName, {bool fade = true}) async {
    if (!_initialized) {
      await init();
    }

    // If identical track is already requested:
    if (_currentBgmTrack == trackName) {
      // If paused in foreground and unmuted, resume playback
      if (!_isAppInBackground && !_isBgmMuted) {
        if (_bgmPlayer.state == PlayerState.paused) {
          try {
            await _bgmPlayer.resume();
          } catch (_) {}
        }
      }
      return; // Do not restart from beginning!
    }

    _currentBgmTrack = trackName;
    final token = ++_bgmTransitionToken;

    // Smooth fade out old BGM if currently playing
    if (fade && _bgmPlayer.state == PlayerState.playing) {
      await _fadeVolume(token, from: _effectiveBgmVolume, to: 0.0, durationMs: 200);
      if (token != _bgmTransitionToken) return;
    }

    try {
      await _bgmPlayer.stop();
    } catch (_) {}

    if (token != _bgmTransitionToken) return;

    // If app is currently in background, don't start audio
    if (_isAppInBackground) return;

    final targetVolume = _effectiveBgmVolume;

    try {
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      if (fade && !_isBgmMuted && targetVolume > 0.0) {
        await _bgmPlayer.setVolume(0.0);
        await _bgmPlayer.play(AssetSource(trackName));
        if (token != _bgmTransitionToken) return;
        await _fadeVolume(token, from: 0.0, to: targetVolume, durationMs: 200);
      } else {
        await _bgmPlayer.setVolume(targetVolume);
        await _bgmPlayer.play(AssetSource(trackName));
      }
    } catch (e) {
      debugPrint('AudioManager playBgm error for $trackName: $e');
    }
  }

  /// Pause current BGM.
  Future<void> pauseBgm() async {
    if (!_initialized) return;
    try {
      await _bgmPlayer.pause();
    } catch (_) {}
  }

  /// Resume current BGM.
  Future<void> resumeBgm() async {
    if (!_initialized || _isBgmMuted || _isAppInBackground) return;
    if (_currentBgmTrack != null) {
      try {
        if (_bgmPlayer.state == PlayerState.paused) {
          await _bgmPlayer.resume();
        } else if (_bgmPlayer.state != PlayerState.playing) {
          await playBgm(_currentBgmTrack!, fade: false);
        }
      } catch (_) {}
    }
  }

  /// Stop current BGM.
  Future<void> stopBgm() async {
    if (!_initialized) return;
    _currentBgmTrack = null;
    _bgmTransitionToken++;
    try {
      await _bgmPlayer.stop();
    } catch (_) {}
  }

  /// Play a sound effect. Uses SFX pool for simultaneous non-blocking sounds,
  /// with duplicate debouncing to prevent accidental stacked triggers.
  Future<void> playSfx(String sfxName) async {
    if (!_initialized) {
      await init();
    }
    if (_isSfxMuted || _sfxVolume <= 0.0) return;

    // Debounce duplicate identical sound within short window
    final now = DateTime.now().millisecondsSinceEpoch;
    final lastTime = _lastSfxPlayedTime[sfxName] ?? 0;
    if (now - lastTime < _sfxDebounceMs) {
      return;
    }
    _lastSfxPlayedTime[sfxName] = now;

    if (_sfxPlayers.isEmpty) return;

    final player = _sfxPlayers[_sfxPoolIndex];
    _sfxPoolIndex = (_sfxPoolIndex + 1) % _sfxPlayers.length;

    try {
      await player.stop();
      await player.setVolume(_sfxVolume.clamp(0.0, 1.0));
      await player.play(
        AssetSource(sfxName),
        mode: PlayerMode.lowLatency,
      );
    } catch (e) {
      debugPrint('AudioManager playSfx error for $sfxName: $e');
    }
  }

  /// Volume Helpers
  double get _effectiveBgmVolume => _isBgmMuted ? 0.0 : _bgmVolume.clamp(0.0, 1.0);

  Future<void> _fadeVolume(
    int token, {
    required double from,
    required double to,
    required int durationMs,
  }) async {
    const steps = 5;
    final stepDuration = Duration(milliseconds: durationMs ~/ steps);
    final delta = (to - from) / steps;

    for (int i = 1; i <= steps; i++) {
      if (token != _bgmTransitionToken) return;
      final newVol = (from + delta * i).clamp(0.0, 1.0);
      try {
        await _bgmPlayer.setVolume(newVol);
      } catch (_) {}
      await Future.delayed(stepDuration);
    }
  }

  /// Set BGM volume (0.0 to 1.0)
  Future<void> setBgmVolume(double volume) async {
    _bgmVolume = volume.clamp(0.0, 1.0);
    bgmVolumeNotifier.value = _bgmVolume;
    if (!_isBgmMuted && _initialized) {
      try {
        await _bgmPlayer.setVolume(_bgmVolume);
      } catch (_) {}
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_prefBgmVolume, _bgmVolume);
  }

  /// Set SFX volume (0.0 to 1.0)
  Future<void> setSfxVolume(double volume) async {
    _sfxVolume = volume.clamp(0.0, 1.0);
    sfxVolumeNotifier.value = _sfxVolume;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_prefSfxVolume, _sfxVolume);
  }

  /// Mute or unmute BGM
  Future<void> setBgmMuted(bool muted) async {
    _isBgmMuted = muted;
    bgmMutedNotifier.value = _isBgmMuted;

    if (_initialized) {
      try {
        if (_isBgmMuted) {
          await _bgmPlayer.setVolume(0.0);
        } else {
          await _bgmPlayer.setVolume(_bgmVolume);
          if (_currentBgmTrack != null && _bgmPlayer.state != PlayerState.playing) {
            await _bgmPlayer.play(AssetSource(_currentBgmTrack!));
          }
        }
      } catch (_) {}
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefBgmMuted, _isBgmMuted);
  }

  /// Mute or unmute SFX
  Future<void> setSfxMuted(bool muted) async {
    _isSfxMuted = muted;
    sfxMutedNotifier.value = _isSfxMuted;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefSfxMuted, _isSfxMuted);
  }

  /// Toggle BGM mute
  Future<void> toggleBgmMute() async {
    await setBgmMuted(!_isBgmMuted);
  }

  /// Toggle SFX mute
  Future<void> toggleSfxMute() async {
    await setSfxMuted(!_isSfxMuted);
  }

  /// Lifecycle listener for app backgrounding / foregrounding
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      _isAppInBackground = true;
      if (_initialized && _bgmPlayer.state == PlayerState.playing) {
        _bgmPlayer.pause();
      }
    } else if (state == AppLifecycleState.resumed) {
      _isAppInBackground = false;
      if (_initialized && _currentBgmTrack != null && !_isBgmMuted) {
        if (_bgmPlayer.state == PlayerState.paused) {
          _bgmPlayer.resume();
        } else if (_bgmPlayer.state != PlayerState.playing) {
          playBgm(_currentBgmTrack!, fade: false);
        }
      }
    }
  }

  /// Clean up resources
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    bgmVolumeNotifier.dispose();
    sfxVolumeNotifier.dispose();
    bgmMutedNotifier.dispose();
    sfxMutedNotifier.dispose();
    _bgmPlayer.dispose();
    for (final player in _sfxPlayers) {
      player.dispose();
    }
    _sfxPlayers.clear();
    _initialized = false;
  }
}

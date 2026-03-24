import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart';

/// Synthesizes kawaii UI sounds from detuned oscillator clusters + sine harmonics.
/// Pre-generates and caches all WAV data at init for zero-latency playback.
class KawaiiSoundEngine {
  static final KawaiiSoundEngine _instance = KawaiiSoundEngine._();
  factory KawaiiSoundEngine() => _instance;
  KawaiiSoundEngine._() { _preCache(); }

  static const int _sr = 22050; // 22kHz is sufficient for UI sounds
  bool _muted = false;
  final _rng = Random();
  static const _ch = MethodChannel('kawaii_sound');
  static const _hapticCh = MethodChannel('kawaii_haptics');

  // Pre-cached WAV bytes for each sound (3 variants each for micro-variation)
  final Map<KawaiiSound, List<Uint8List>> _cache = {};
  bool _cached = false;
  bool _caching = false;

  bool get muted => _muted;
  set muted(bool v) => _muted = v;
  void toggleMute() => _muted = !_muted;

  /// Pre-generate all sounds lazily after first frame
  void _preCache() {
    if (_cached || _caching) return;
    _caching = true;
    // Defer to avoid blocking startup
    Future.microtask(() {
      for (final s in KawaiiSound.values) {
        _cache[s] = List.generate(3, (_) => _buildSound(s));
      }
      _cached = true;
      _caching = false;
    });
  }

  double _vary(double f) => f * (0.93 + _rng.nextDouble() * 0.14);

  double _tri(double phase) {
    final p = phase % (2 * pi);
    return p < pi ? -1.0 + 2.0 * p / pi : 3.0 - 2.0 * p / pi;
  }

  List<double> _hollow(double freq, double dur, double vol, double spread, double dl) {
    final n = ((dur + dl) * _sr).toInt();
    final d0 = (dl * _sr).toInt();
    final out = List<double>.filled(n, 0.0);
    for (final off in [-spread, 0.0, spread]) {
      final f = freq + off;
      for (int i = d0; i < n; i++) {
        final t = (i - d0) / _sr;
        out[i] += (vol / 3) * exp(-t / (dur * 0.7)) * _tri(2 * pi * f * t);
      }
    }
    return out;
  }

  List<double> _ping(double freq, double dur, double vol, double dl) {
    final n = ((dur + dl) * _sr).toInt();
    final d0 = (dl * _sr).toInt();
    final out = List<double>.filled(n, 0.0);
    for (int i = d0; i < n; i++) {
      final t = (i - d0) / _sr;
      out[i] = vol * exp(-t / (dur * 0.5)) * sin(2 * pi * freq * t);
    }
    return out;
  }

  List<double> _mix(List<List<double>> layers) {
    int mx = 0;
    for (final l in layers) { if (l.length > mx) mx = l.length; }
    final out = List<double>.filled(mx, 0.0);
    for (final l in layers) {
      for (int i = 0; i < l.length; i++) { out[i] += l[i]; }
    }
    return out;
  }

  Uint8List _toWav(List<double> samples) {
    final dLen = samples.length * 2;
    final buf = ByteData(44 + dLen);
    void ws(int o, String s) { for (int i = 0; i < s.length; i++) buf.setUint8(o + i, s.codeUnitAt(i)); }
    ws(0, 'RIFF'); buf.setUint32(4, 36 + dLen, Endian.little);
    ws(8, 'WAVE'); ws(12, 'fmt ');
    buf.setUint32(16, 16, Endian.little); buf.setUint16(20, 1, Endian.little);
    buf.setUint16(22, 1, Endian.little); buf.setUint32(24, _sr, Endian.little);
    buf.setUint32(28, _sr * 2, Endian.little); buf.setUint16(32, 2, Endian.little);
    buf.setUint16(34, 16, Endian.little); ws(36, 'data');
    buf.setUint32(40, dLen, Endian.little);
    for (int i = 0; i < samples.length; i++) {
      buf.setInt16(44 + i * 2, (samples[i].clamp(-1.0, 1.0) * 32767).toInt(), Endian.little);
    }
    return buf.buffer.asUint8List();
  }

  Uint8List _buildSound(KawaiiSound sound) {
    List<List<double>> layers;
    switch (sound) {
      // Rule: single syllable only. One body + one optional shimmer.
      // No staggered multi-note sequences.
      case KawaiiSound.boop:   // button press — ceramic tap
        layers = [_hollow(_vary(620), 0.07, 0.18, 6, 0), _ping(_vary(1240), 0.03, 0.03, 0.003)];
      case KawaiiSound.pop:    // hero CTA — deeper, rounder
        layers = [_hollow(_vary(460), 0.09, 0.22, 8, 0), _ping(_vary(920), 0.04, 0.04, 0.005)];
      case KawaiiSound.tick:   // lightest — tiny bead click
        layers = [_hollow(_vary(1400), 0.02, 0.07, 10, 0)];
      case KawaiiSound.toggle: // switch snap — crisp single click
        layers = [_hollow(_vary(800), 0.04, 0.14, 10, 0)];
      case KawaiiSound.chime:  // positive arrival — warm single tone
        layers = [_hollow(_vary(550), 0.1, 0.1, 3, 0), _ping(_vary(1100), 0.08, 0.06, 0.005)];
      case KawaiiSound.send:   // message sent — single upward shimmer
        layers = [_hollow(_vary(700), 0.08, 0.15, 5, 0), _ping(_vary(1400), 0.06, 0.04, 0.008)];
      case KawaiiSound.notif:  // notification — single bright ping
        layers = [_hollow(_vary(660), 0.08, 0.12, 4, 0), _ping(_vary(1320), 0.06, 0.05, 0.005)];
      case KawaiiSound.reward: // reward — single warm tone, slightly longer
        layers = [_hollow(_vary(700), 0.12, 0.14, 3, 0), _ping(_vary(1400), 0.08, 0.06, 0.005)];
    }
    return _toWav(_mix(layers));
  }

  // Per-effect cooldowns to prevent spam buzz on rapid tapping
  final Map<String, int> _hapticLastMs = {};

  bool _hapticAllowed(String effect, int minGapMs) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final last = _hapticLastMs[effect] ?? 0;
    if (now - last < minGapMs) return false;
    _hapticLastMs[effect] = now;
    return true;
  }

  void _playHaptic(KawaiiSound sound) {
    // Map sound → effect + per-effect cooldown
    final (String effect, int cooldownMs) = switch (sound) {
      KawaiiSound.tick     => ('tick', 50),        // lightest — selections
      KawaiiSound.toggle   => ('click', 70),       // switches
      KawaiiSound.boop     => ('click', 70),       // standard button
      KawaiiSound.pop      => ('heavy_click', 70), // hero button
      KawaiiSound.send     => ('click', 70),       // message sent
      KawaiiSound.chime    => ('click', 120),       // arrival
      KawaiiSound.notif    => ('heavy_click', 140), // notification
      KawaiiSound.reward   => ('heavy_click', 240), // achievement
    };
    if (!_hapticAllowed(effect, cooldownMs)) return;
    _hapticCh.invokeMethod('predefined', {'effect': effect}).catchError((_) {
      HapticFeedback.mediumImpact();
    });
  }

  /// Play a sound — picks from pre-cached variants for micro-variation
  void play(KawaiiSound sound) {
    // Native haptics via Android Vibrator API for strong, quality feedback.
    // Falls back to Flutter HapticFeedback if channel not available.
    _playHaptic(sound);
    if (_muted) return;
    final variants = _cache[sound];
    if (variants == null || variants.isEmpty) return;
    final wav = variants[_rng.nextInt(variants.length)];
    _ch.invokeMethod('playWav', wav).catchError((_) {});
  }
}

enum KawaiiSound { boop, pop, tick, toggle, chime, send, notif, reward }

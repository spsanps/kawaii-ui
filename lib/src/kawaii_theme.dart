import 'package:flutter/material.dart';
import 'theme.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  KAWAII THEME DATA
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

@immutable
class KawaiiThemeData {
  // ── Semantic colors ──────────────────────────────────────────
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color surface;
  final Color surfaceBorder;
  final List<Color> backgroundStops;
  final Color textHeading;
  final Color textBody;
  final Color textMuted;
  final Color textSubtle;
  final Color success;
  final Color warning;
  final Color error;

  // ── Button presets ───────────────────────────────────────────
  final KawaiiButtonColors buttonPrimary;
  final KawaiiButtonColors buttonSecondary;
  final KawaiiButtonColors buttonAccent;
  final KawaiiButtonColors buttonSuccess;
  final KawaiiButtonColors buttonError;

  // ── Appearance ───────────────────────────────────────────────
  final Brightness brightness;
  final Color shineColor;
  final bool soundEnabled;

  const KawaiiThemeData({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.surface,
    required this.surfaceBorder,
    required this.backgroundStops,
    required this.textHeading,
    required this.textBody,
    required this.textMuted,
    required this.textSubtle,
    required this.success,
    required this.warning,
    required this.error,
    required this.buttonPrimary,
    required this.buttonSecondary,
    required this.buttonAccent,
    required this.buttonSuccess,
    required this.buttonError,
    this.brightness = Brightness.light,
    this.shineColor = const Color(0xFFFFFFFF),
    this.soundEnabled = true,
  });

  // ── copyWith ─────────────────────────────────────────────────

  KawaiiThemeData copyWith({
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? surface,
    Color? surfaceBorder,
    List<Color>? backgroundStops,
    Color? textHeading,
    Color? textBody,
    Color? textMuted,
    Color? textSubtle,
    Color? success,
    Color? warning,
    Color? error,
    KawaiiButtonColors? buttonPrimary,
    KawaiiButtonColors? buttonSecondary,
    KawaiiButtonColors? buttonAccent,
    KawaiiButtonColors? buttonSuccess,
    KawaiiButtonColors? buttonError,
    Brightness? brightness,
    Color? shineColor,
    bool? soundEnabled,
  }) {
    return KawaiiThemeData(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      surface: surface ?? this.surface,
      surfaceBorder: surfaceBorder ?? this.surfaceBorder,
      backgroundStops: backgroundStops ?? this.backgroundStops,
      textHeading: textHeading ?? this.textHeading,
      textBody: textBody ?? this.textBody,
      textMuted: textMuted ?? this.textMuted,
      textSubtle: textSubtle ?? this.textSubtle,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      buttonPrimary: buttonPrimary ?? this.buttonPrimary,
      buttonSecondary: buttonSecondary ?? this.buttonSecondary,
      buttonAccent: buttonAccent ?? this.buttonAccent,
      buttonSuccess: buttonSuccess ?? this.buttonSuccess,
      buttonError: buttonError ?? this.buttonError,
      brightness: brightness ?? this.brightness,
      shineColor: shineColor ?? this.shineColor,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //  FACTORY: Sakura (warm pink — the default)
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  factory KawaiiThemeData.sakura({bool soundEnabled = true}) {
    return KawaiiThemeData(
      primary: KawaiiColors.pinkBottom,
      secondary: KawaiiColors.violetBottom,
      accent: KawaiiColors.goldBottom,
      surface: const Color(0xF0FFFFFF),
      surfaceBorder: KawaiiColors.cardBorder,
      backgroundStops: const [
        KawaiiColors.bgTop,
        KawaiiColors.bgMid,
        KawaiiColors.bgBottom,
      ],
      textHeading: KawaiiColors.heading,
      textBody: KawaiiColors.body,
      textMuted: KawaiiColors.muted,
      textSubtle: KawaiiColors.subtle,
      success: KawaiiColors.greenBottom,
      warning: KawaiiColors.goldBottom,
      error: const Color(0xFFE57373),
      buttonPrimary: KawaiiButtonColors.pink,
      buttonSecondary: KawaiiButtonColors.violet,
      buttonAccent: KawaiiButtonColors.gold,
      buttonSuccess: KawaiiButtonColors.green,
      buttonError: const KawaiiButtonColors(
        top: Color(0xFFEF9A9A),
        bottom: Color(0xFFE57373),
        stroke: Color(0xFFC62828),
        text: Color(0xFF7F1D1D),
        shadow: Color(0x38C62828),
      ),
      soundEnabled: soundEnabled,
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //  FACTORY: Ocean (cool blue)
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  factory KawaiiThemeData.ocean({bool soundEnabled = true}) {
    return KawaiiThemeData(
      primary: const Color(0xFF42A5F5),
      secondary: const Color(0xFF26C6DA),
      accent: const Color(0xFFFFB74D),
      surface: const Color(0xF0FFFFFF),
      surfaceBorder: const Color(0xFFB3D9F2),
      backgroundStops: const [
        Color(0xFFE1F5FE),
        Color(0xFFE8F8FF),
        Color(0xFFF0F4FF),
      ],
      textHeading: const Color(0xFF1A3A52),
      textBody: const Color(0xFF3E6180),
      textMuted: const Color(0xFF6A8DA8),
      textSubtle: const Color(0xFF98B8D0),
      success: const Color(0xFF66BB6A),
      warning: const Color(0xFFFFCA28),
      error: const Color(0xFFEF5350),
      buttonPrimary: KawaiiButtonColors.blue,
      buttonSecondary: const KawaiiButtonColors(
        top: Color(0xFF80DEEA),
        bottom: Color(0xFF26C6DA),
        stroke: Color(0xFF00838F),
        text: Color(0xFFFFFFFF),
        shadow: Color(0x3800838F),
      ),
      buttonAccent: KawaiiButtonColors.gold,
      buttonSuccess: KawaiiButtonColors.green,
      buttonError: const KawaiiButtonColors(
        top: Color(0xFFEF9A9A),
        bottom: Color(0xFFEF5350),
        stroke: Color(0xFFC62828),
        text: Color(0xFFFFFFFF),
        shadow: Color(0x38C62828),
      ),
      soundEnabled: soundEnabled,
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //  FACTORY: Forest (soft green)
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  factory KawaiiThemeData.forest({bool soundEnabled = true}) {
    return KawaiiThemeData(
      primary: const Color(0xFF66BB6A),
      secondary: const Color(0xFF81C784),
      accent: const Color(0xFFFFD54F),
      surface: const Color(0xF0FFFFFF),
      surfaceBorder: const Color(0xFFC1DFC3),
      backgroundStops: const [
        Color(0xFFE8F5E9),
        Color(0xFFF1F8E9),
        Color(0xFFFFFDE7),
      ],
      textHeading: const Color(0xFF1B3A1E),
      textBody: const Color(0xFF3E6042),
      textMuted: const Color(0xFF6A8E6E),
      textSubtle: const Color(0xFF98B89C),
      success: const Color(0xFF43A047),
      warning: const Color(0xFFFFCA28),
      error: const Color(0xFFE57373),
      buttonPrimary: KawaiiButtonColors.green,
      buttonSecondary: const KawaiiButtonColors(
        top: Color(0xFFA5D6A7),
        bottom: Color(0xFF81C784),
        stroke: Color(0xFF4CAF50),
        text: Color(0xFF1B5E20),
        shadow: Color(0x2E4CAF50),
      ),
      buttonAccent: KawaiiButtonColors.gold,
      buttonSuccess: const KawaiiButtonColors(
        top: Color(0xFF81C784),
        bottom: Color(0xFF43A047),
        stroke: Color(0xFF2E7D32),
        text: Color(0xFFFFFFFF),
        shadow: Color(0x382E7D32),
      ),
      buttonError: const KawaiiButtonColors(
        top: Color(0xFFEF9A9A),
        bottom: Color(0xFFE57373),
        stroke: Color(0xFFC62828),
        text: Color(0xFF7F1D1D),
        shadow: Color(0x38C62828),
      ),
      soundEnabled: soundEnabled,
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //  FACTORY: Lavender (soft purple)
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  factory KawaiiThemeData.lavender({bool soundEnabled = true}) {
    return KawaiiThemeData(
      primary: const Color(0xFFAB47BC),
      secondary: const Color(0xFF7E57C2),
      accent: const Color(0xFFF48FB1),
      surface: const Color(0xF0FFFFFF),
      surfaceBorder: const Color(0xFFD1B3E0),
      backgroundStops: const [
        Color(0xFFF3E5F5),
        Color(0xFFEDE7F6),
        Color(0xFFFCE4EC),
      ],
      textHeading: const Color(0xFF2E1A3E),
      textBody: const Color(0xFF5C4070),
      textMuted: const Color(0xFF8A6898),
      textSubtle: const Color(0xFFB898C4),
      success: const Color(0xFF66BB6A),
      warning: const Color(0xFFFFCA28),
      error: const Color(0xFFE57373),
      buttonPrimary: KawaiiButtonColors.violet,
      buttonSecondary: const KawaiiButtonColors(
        top: Color(0xFFB39DDB),
        bottom: Color(0xFF7E57C2),
        stroke: Color(0xFF512DA8),
        text: Color(0xFFFFFFFF),
        shadow: Color(0x38512DA8),
      ),
      buttonAccent: KawaiiButtonColors.pink,
      buttonSuccess: KawaiiButtonColors.green,
      buttonError: const KawaiiButtonColors(
        top: Color(0xFFEF9A9A),
        bottom: Color(0xFFE57373),
        stroke: Color(0xFFC62828),
        text: Color(0xFF7F1D1D),
        shadow: Color(0x38C62828),
      ),
      soundEnabled: soundEnabled,
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //  FACTORY: Sunset (warm orange / gold)
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  factory KawaiiThemeData.sunset({bool soundEnabled = true}) {
    return KawaiiThemeData(
      primary: const Color(0xFFFF8A65),
      secondary: const Color(0xFFFFB74D),
      accent: const Color(0xFFF06292),
      surface: const Color(0xF0FFFFFF),
      surfaceBorder: const Color(0xFFE8C8B0),
      backgroundStops: const [
        Color(0xFFFFF3E0),
        Color(0xFFFFF8E1),
        Color(0xFFFCE4EC),
      ],
      textHeading: const Color(0xFF3E2218),
      textBody: const Color(0xFF6D4C3E),
      textMuted: const Color(0xFF9D7868),
      textSubtle: const Color(0xFFC4A898),
      success: const Color(0xFF66BB6A),
      warning: const Color(0xFFFFD54F),
      error: const Color(0xFFE57373),
      buttonPrimary: const KawaiiButtonColors(
        top: Color(0xFFFFAB91),
        bottom: Color(0xFFFF8A65),
        stroke: Color(0xFFE64A19),
        text: Color(0xFF4E1600),
        shadow: Color(0x38E64A19),
      ),
      buttonSecondary: KawaiiButtonColors.gold,
      buttonAccent: KawaiiButtonColors.pink,
      buttonSuccess: KawaiiButtonColors.green,
      buttonError: const KawaiiButtonColors(
        top: Color(0xFFEF9A9A),
        bottom: Color(0xFFE57373),
        stroke: Color(0xFFC62828),
        text: Color(0xFF7F1D1D),
        shadow: Color(0x38C62828),
      ),
      soundEnabled: soundEnabled,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KawaiiThemeData &&
          runtimeType == other.runtimeType &&
          primary == other.primary &&
          secondary == other.secondary &&
          accent == other.accent &&
          surface == other.surface &&
          surfaceBorder == other.surfaceBorder &&
          _listEquals(backgroundStops, other.backgroundStops) &&
          textHeading == other.textHeading &&
          textBody == other.textBody &&
          textMuted == other.textMuted &&
          textSubtle == other.textSubtle &&
          success == other.success &&
          warning == other.warning &&
          error == other.error &&
          brightness == other.brightness &&
          shineColor == other.shineColor &&
          soundEnabled == other.soundEnabled;

  @override
  int get hashCode => Object.hash(
        primary, secondary, accent, surface, surfaceBorder,
        Object.hashAll(backgroundStops),
        textHeading, textBody, textMuted, textSubtle,
        success, warning, error,
        brightness, shineColor, soundEnabled,
      );

  static bool _listEquals(List<Color> a, List<Color> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  KAWAII THEME — InheritedWidget
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiTheme extends InheritedWidget {
  const KawaiiTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final KawaiiThemeData data;

  /// Returns the nearest [KawaiiThemeData] up the tree, falling back to
  /// [KawaiiThemeData.sakura()] if none is found.
  static KawaiiThemeData of(BuildContext context) {
    return maybeOf(context) ?? KawaiiThemeData.sakura();
  }

  /// Returns the nearest [KawaiiThemeData] or `null`.
  static KawaiiThemeData? maybeOf(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<KawaiiTheme>();
    return widget?.data;
  }

  @override
  bool updateShouldNotify(KawaiiTheme oldWidget) => data != oldWidget.data;
}

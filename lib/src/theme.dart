import 'package:flutter/material.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  COLOR PALETTE — Sakura theme (warm pink)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiColors {
  KawaiiColors._();

  // Pink
  static const pinkTop = Color(0xFFFFC0D8);
  static const pinkBottom = Color(0xFFF08CAE);
  static const pinkStroke = Color(0xFFD0688A);
  static const pinkText = Color(0xFF6D2042);
  static const pinkShadow = Color(0x38D0688A);

  // Violet
  static const violetTop = Color(0xFFCE93D8);
  static const violetBottom = Color(0xFFAB47BC);
  static const violetStroke = Color(0xFF7B1FA2);
  static const violetShadow = Color(0x387B1FA2);

  // Green
  static const greenTop = Color(0xFFA5D6A7);
  static const greenBottom = Color(0xFF66BB6A);
  static const greenStroke = Color(0xFF388E3C);
  static const greenText = Color(0xFF1B5E20);
  static const greenShadow = Color(0x2E388E3C);

  // Gold
  static const goldTop = Color(0xFFFFE082);
  static const goldBottom = Color(0xFFFFD54F);
  static const goldStroke = Color(0xFFF9A825);
  static const goldText = Color(0xFF5D4010);
  static const goldShadow = Color(0x2EF9A825);

  // Blue
  static const blueTop = Color(0xFF90CAF9);
  static const blueBottom = Color(0xFF42A5F5);
  static const blueStroke = Color(0xFF1976D2);
  static const blueShadow = Color(0x381976D2);

  // Semantics
  static const heading = Color(0xFF3E1E2C);
  static const body = Color(0xFF6D4C5E);
  static const muted = Color(0xFF9D7088);
  static const subtle = Color(0xFFB898A8);
  static const ownBubbleText = Color(0xFF6D5A64);

  // Card
  static const cardBorder = Color(0xFFE8C0D8);
  static const cardFillTop = Color(0xF0FFFFFF);
  static const cardFillBottom = Color(0xD6FFF8FC);

  // Star/sparkle
  static const starFill = Color(0xFFFFD54F);
  static const starStroke = Color(0xFFD4940C);

  // Background gradient
  static const bgTop = Color(0xFFE4F2FA);
  static const bgMid = Color(0xFFFFF2F6);
  static const bgBottom = Color(0xFFF6F0FF);

  // Neutral glass
  static const glass = Color(0xFFC8A0B4);
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  BUTTON COLOR PRESETS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

@immutable
class KawaiiButtonColors {
  final Color top, bottom, stroke, text, shadow;
  const KawaiiButtonColors({
    required this.top, required this.bottom,
    required this.stroke, required this.text, required this.shadow,
  });

  static const pink = KawaiiButtonColors(
    top: KawaiiColors.pinkTop, bottom: KawaiiColors.pinkBottom,
    stroke: KawaiiColors.pinkStroke, text: KawaiiColors.pinkText, shadow: KawaiiColors.pinkShadow);
  static const violet = KawaiiButtonColors(
    top: KawaiiColors.violetTop, bottom: KawaiiColors.violetBottom,
    stroke: KawaiiColors.violetStroke, text: Color(0xFFFFFFFF), shadow: KawaiiColors.violetShadow);
  static const green = KawaiiButtonColors(
    top: KawaiiColors.greenTop, bottom: KawaiiColors.greenBottom,
    stroke: KawaiiColors.greenStroke, text: KawaiiColors.greenText, shadow: KawaiiColors.greenShadow);
  static const gold = KawaiiButtonColors(
    top: KawaiiColors.goldTop, bottom: KawaiiColors.goldBottom,
    stroke: KawaiiColors.goldStroke, text: KawaiiColors.goldText, shadow: KawaiiColors.goldShadow);
  static const blue = KawaiiButtonColors(
    top: KawaiiColors.blueTop, bottom: KawaiiColors.blueBottom,
    stroke: KawaiiColors.blueStroke, text: Color(0xFFFFFFFF), shadow: KawaiiColors.blueShadow);
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  SPACING — 4px base grid
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiSpacing {
  KawaiiSpacing._();
  static const double xs   = 2;
  static const double sm   = 4;
  static const double md   = 8;
  static const double lg   = 12;
  static const double xl   = 16;
  static const double xxl  = 20;
  static const double page = 28;
  static const double huge = 40;

  // Semantic aliases
  static const double sectionGap      = 20;
  static const double sectionLabelBot = 14;
  static const double cardPad         = 20;
  static const double chatGap         = 12;
  static const double notifGap        = 9;
  static const double iconGap         = 7;
  static const double wrapSpacing     = 8;
  static const double wrapRunSpacing  = 8;
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  BORDER RADII
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiBorderRadius {
  KawaiiBorderRadius._();
  static const double xs   = 8;
  static const double sm   = 10;
  static const double md   = 14;
  static const double lg   = 16;
  static const double xl   = 18;
  static const double xxl  = 20;
  static const double card = 22;
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  BORDER WIDTHS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiBorderWidth {
  KawaiiBorderWidth._();
  static const double thin   = 1.0;
  static const double light  = 1.5;
  static const double medium = 2.0;
  static const double thick  = 2.5;
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  SHADOW DEPTH TIERS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiShadows {
  KawaiiShadows._();

  /// Tight — toggle knobs, small interactive elements
  static BoxShadow soft(Color c) => BoxShadow(
    color: c.withValues(alpha: 0.1), blurRadius: 5, offset: const Offset(0, 2));

  /// Medium — badges, avatars, stats, inputs, notifications
  static BoxShadow medium(Color c) => BoxShadow(
    color: c.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 3));

  /// Wide — cards, hero buttons, floating panels
  static BoxShadow deep(Color c) => BoxShadow(
    color: c.withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 5));

  /// Card-specific shadow
  static const card = BoxShadow(
    color: Color(0x1AB4648C), blurRadius: 20, offset: Offset(0, 6));
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  OPACITY SCALE
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiOpacity {
  KawaiiOpacity._();
  static const double ghost     = 0.03;  // barely-there backgrounds
  static const double whisper   = 0.06;  // tag/typing backgrounds
  static const double hint      = 0.1;   // notification badge bg, borders
  static const double soft      = 0.12;  // stat pill bg
  static const double muted     = 0.2;   // toggle shadow, badge borders
  static const double medium    = 0.35;  // avatar borders, unread glow
  static const double strong    = 0.5;   // input icon
  static const double prominent = 0.6;   // avatar gradient
  static const double heavy     = 0.75;  // progress fill, toggle gradient
  static const double solid     = 0.85;  // near-opaque
  static const double decorative = 0.4;  // corner sparkles
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  CHARACTER DATA
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

@immutable
class KawaiiCharacter {
  final String name;
  final String? tagline;
  final String? description;
  final Color primary;
  final Color accent;
  final bool online;

  const KawaiiCharacter({
    required this.name,
    this.tagline,
    this.description,
    required this.primary,
    required this.accent,
    this.online = false,
  });

  static const mika = KawaiiCharacter(
    name: 'Mika', tagline: 'Gyaru',
    description: "Your bold best friend who won't let you leave the house in that outfit.",
    primary: Color(0xFFF06292), accent: Color(0xFFFFABC8), online: true);

  static const ren = KawaiiCharacter(
    name: 'Ren',
    primary: Color(0xFF66BB6A), accent: Color(0xFFA5D6A7), online: true);

  static const sora = KawaiiCharacter(
    name: 'Sora',
    primary: Color(0xFF7C4DFF), accent: Color(0xFFB388FF));

  static const hana = KawaiiCharacter(
    name: 'Hana',
    primary: Color(0xFFFF8A65), accent: Color(0xFFFFCCBC), online: true);

  static const kira = KawaiiCharacter(
    name: 'Kira',
    primary: Color(0xFFAB47BC), accent: Color(0xFFCE93D8));

  static const mei = KawaiiCharacter(
    name: 'Mei',
    primary: Color(0xFF42A5F5), accent: Color(0xFF90CAF9));

  static const all = [mika, ren, sora, hana, kira, mei];
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  ANIMATION CURVES
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiCurves {
  KawaiiCurves._();
  static const spring = Cubic(0.34, 1.56, 0.64, 1.0);
  static const soft = Cubic(0.25, 0.46, 0.45, 0.94);
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';
import 'painters.dart';
import 'sound_engine.dart';
import 'gloss.dart';

// ━━━ SHARED HELPERS ━━━

/// Shorthand for creating an icon from a CustomPainter
Widget kawaiiIcon(CustomPainter painter, {double size = 16}) =>
    SizedBox(width: size, height: size, child: CustomPaint(painter: painter));

// [OPT #6] Cache base TextStyle objects from GoogleFonts to avoid
// creating new TextStyle instances on every build() call. GoogleFonts
// already has an internal cache but the function call overhead and
// map lookup per-frame adds up with dozens of text widgets.

final TextStyle _fredokaBase = GoogleFonts.fredoka(
    fontWeight: FontWeight.w700, color: KawaiiColors.heading);
final TextStyle _nunitoBase = GoogleFonts.nunito(
    fontWeight: FontWeight.w700, color: KawaiiColors.body);

/// Heading font (Fredoka — display only)
TextStyle kHeading({double size = 14, Color? color}) => _fredokaBase.copyWith(
    fontSize: size, color: color);

/// Body font (Nunito — everything else)
TextStyle kBody({double size = 13, FontWeight weight = FontWeight.w700, Color? color}) =>
    _nunitoBase.copyWith(fontSize: size, fontWeight: weight, color: color);

/// Small sparkle icon
class Star4Icon extends StatelessWidget {
  final double size;
  final Color fill, stroke;
  const Star4Icon({super.key, this.size = 14,
    this.fill = const Color(0xFFFFD54F), this.stroke = const Color(0xFFD4940C)});
  @override
  Widget build(BuildContext context) =>
      kawaiiIcon(Star4Painter(fill: fill, stroke: stroke, strokeWidth: 1.5), size: size);
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  GLOSSY BUTTON — the signature element
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiButton extends StatelessWidget {
  final String label;
  final KawaiiButtonColors colors;
  final bool hero, small;
  final Widget? icon;
  final VoidCallback? onTap;
  final bool playSound;

  const KawaiiButton({super.key, required this.label, required this.colors,
    this.hero = false, this.small = false, this.icon, this.onTap,
    this.playSound = true});

  factory KawaiiButton.pink(String l, {bool hero = false, bool small = false, Widget? i, VoidCallback? onTap, Key? key, bool playSound = true}) =>
      KawaiiButton(key: key, label: l, colors: KawaiiButtonColors.pink, hero: hero, small: small, icon: i, onTap: onTap, playSound: playSound);
  factory KawaiiButton.violet(String l, {bool hero = false, bool small = false, Widget? i, VoidCallback? onTap, Key? key, bool playSound = true}) =>
      KawaiiButton(key: key, label: l, colors: KawaiiButtonColors.violet, hero: hero, small: small, icon: i, onTap: onTap, playSound: playSound);
  factory KawaiiButton.green(String l, {bool hero = false, bool small = false, Widget? i, VoidCallback? onTap, Key? key, bool playSound = true}) =>
      KawaiiButton(key: key, label: l, colors: KawaiiButtonColors.green, hero: hero, small: small, icon: i, onTap: onTap, playSound: playSound);
  factory KawaiiButton.gold(String l, {bool hero = false, bool small = false, Widget? i, VoidCallback? onTap, Key? key, bool playSound = true}) =>
      KawaiiButton(key: key, label: l, colors: KawaiiButtonColors.gold, hero: hero, small: small, icon: i, onTap: onTap, playSound: playSound);
  factory KawaiiButton.blue(String l, {bool hero = false, bool small = false, Widget? i, VoidCallback? onTap, Key? key, bool playSound = true}) =>
      KawaiiButton(key: key, label: l, colors: KawaiiButtonColors.blue, hero: hero, small: small, icon: i, onTap: onTap, playSound: playSound);

  double get _h => small ? 32 : hero ? 50 : 40;
  double get _fs => small ? 11.5 : hero ? 14.5 : 13;
  double get _rx => hero ? KawaiiBorderRadius.xl : small ? 11.0 : KawaiiBorderRadius.md;
  EdgeInsets get _pad => small
      ? const EdgeInsets.symmetric(horizontal: 14)
      : hero ? const EdgeInsets.symmetric(horizontal: 28)
      : const EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    final c = colors;
    return KawaiiPressable(
      onTap: () {
        if (playSound) KawaiiSoundEngine().play(hero ? KawaiiSound.pop : KawaiiSound.boop);
        onTap?.call();
      },
      child: KawaiiSurface(tactile: false,
        gloss: GlossLevel.full,
        height: _h,
        padding: _pad,
        shineHeight: 0.36,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [c.top, c.bottom]),
          borderRadius: BorderRadius.circular(_rx),
          border: Border.all(color: c.stroke, width: KawaiiBorderWidth.thick),
          boxShadow: [
            hero ? KawaiiShadows.deep(c.stroke) : KawaiiShadows.medium(c.stroke),
            if (hero) BoxShadow(
              color: Color.lerp(c.bottom, c.stroke, 0.35)!.withValues(alpha: 0.8),
              blurRadius: 1, spreadRadius: -1, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[icon!, const SizedBox(width: KawaiiSpacing.iconGap)],
          Text(label, style: _fredokaBase.copyWith(
            fontSize: _fs, color: c.text, letterSpacing: 0.4,
            shadows: c.text == Colors.white || c.text == const Color(0xFFFFFFFF)
                ? [const Shadow(color: Colors.black26, offset: Offset(0, 1), blurRadius: 2)] : null,
          )),
        ]),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  CARD — glass panel with inner bevel
//  [OPT #7] KawaiiCard is a heavy subtree — callers wrap with
//  RepaintBoundary in main.dart where appropriate.
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final bool showSparkles;
  const KawaiiCard({super.key, required this.child,
    this.padding = const EdgeInsets.all(KawaiiSpacing.cardPad),
    this.showSparkles = true});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [KawaiiColors.cardFillTop, KawaiiColors.cardFillBottom]),
          borderRadius: BorderRadius.circular(KawaiiBorderRadius.card),
          border: Border.all(color: KawaiiColors.cardBorder, width: KawaiiBorderWidth.thick),
          boxShadow: const [KawaiiShadows.card],
        ),
        child: Stack(children: [
          // Inner bevel border (behind content)
          Positioned.fill(child: IgnorePointer(child: Container(margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(KawaiiBorderRadius.xl),
              border: Border.all(color: const Color(0x8CFFFFFF), width: KawaiiBorderWidth.thin))))),
          // Corner sparkles (behind content)
          if (showSparkles)
            for (final pos in [
              const Alignment(-0.92, -0.92), const Alignment(0.92, -0.92),
              const Alignment(-0.92, 0.92), const Alignment(0.92, 0.92)])
              Align(alignment: pos, child: IgnorePointer(child: Padding(
                padding: const EdgeInsets.all(6),
                child: Opacity(opacity: KawaiiOpacity.decorative, child: const Star4Icon(size: 6))))),
          // Content with padding on top
          Padding(padding: padding, child: child),
        ]),
      ),
    );
  }
}

// ━━━ SECTION LABEL ━━━
class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: KawaiiSpacing.sectionLabelBot),
    child: Row(children: [
      const Star4Icon(size: 10), const SizedBox(width: KawaiiSpacing.md),
      Text(text.toUpperCase(), style: kBody(size: 11, weight: FontWeight.w800,
          color: KawaiiColors.muted).copyWith(letterSpacing: 1.5)),
    ]));
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  BADGE — glossy circle with icon
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiBadge extends StatelessWidget {
  final Widget child;
  final Color bg, border;
  final double size;
  final bool interactive;
  final bool playSound;
  const KawaiiBadge({super.key, required this.child,
    this.bg = const Color(0xFFFFF0F5), this.border = const Color(0xFFE8C0D8),
    this.size = 46, this.interactive = false, this.playSound = true});

  @override
  Widget build(BuildContext context) {
    final surface = KawaiiSurface(tactile: false,
      gloss: GlossLevel.medium,
      height: size, width: size,
      shineHeight: 0.36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [bg, bg.withValues(alpha: 0.8)]),
        border: Border.all(color: border, width: KawaiiBorderWidth.medium),
        boxShadow: [KawaiiShadows.medium(border)],
      ),
      child: child,
    );
    if (!interactive) return surface;
    return KawaiiPressable(
      pressScale: 0.92,
      onTap: () { if (playSound) KawaiiSoundEngine().play(KawaiiSound.chime); },
      child: surface,
    );
  }
}

// ━━━ TAG — subtle shine, tappable ━━━
class KawaiiTag extends StatelessWidget {
  final String text;
  final Color color;
  final bool interactive;
  final bool playSound;
  const KawaiiTag(this.text, {super.key, this.color = const Color(0xFFD0688A),
    this.interactive = false, this.playSound = true});

  @override
  Widget build(BuildContext context) {
    final surface = KawaiiSurface(tactile: false,
      gloss: GlossLevel.subtle,
      shineOpacity: 0.25,
      shineHeight: 0.38,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: KawaiiOpacity.whisper),
        borderRadius: BorderRadius.circular(KawaiiBorderRadius.md),
        border: Border.all(color: color.withValues(alpha: KawaiiOpacity.hint), width: KawaiiBorderWidth.light),
      ),
      child: Text(text, style: kBody(size: 11, weight: FontWeight.w800, color: color)),
    );
    if (!interactive) return surface;
    return KawaiiPressable(
      pressScale: 0.93,
      onTap: () { if (playSound) KawaiiSoundEngine().play(KawaiiSound.tick); },
      child: surface,
    );
  }
}

// ━━━ AVATAR — tappable ━━━
class KawaiiAvatar extends StatelessWidget {
  final Widget icon;
  final Color color;
  final Color? accent;
  final double size;
  final bool status;
  final String? name;
  final bool interactive;
  final bool playSound;
  const KawaiiAvatar({super.key, required this.icon, required this.color,
    this.accent, this.size = 44, this.status = false, this.name,
    this.interactive = false, this.playSound = true});

  @override
  Widget build(BuildContext context) {
    Widget avatar = Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(width: size + 4, height: size + 4, child: Stack(children: [
        KawaiiSurface(tactile: false,
          gloss: GlossLevel.medium,
          height: size, width: size,
          shineHeight: 0.35,
          shineOpacity: 0.22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [(accent ?? color).withValues(alpha: KawaiiOpacity.prominent),
                       color.withValues(alpha: 0.45)]),
            border: Border.all(color: color.withValues(alpha: KawaiiOpacity.medium), width: KawaiiBorderWidth.thick),
            boxShadow: [KawaiiShadows.medium(color)],
          ),
          child: icon,
        ),
        if (status) Positioned(bottom: 0, right: 0,
          child: Container(width: size * 0.28, height: size * 0.28,
            decoration: BoxDecoration(shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [KawaiiColors.greenTop, KawaiiColors.greenBottom]),
              border: Border.all(color: Colors.white, width: KawaiiBorderWidth.medium)))),
      ])),
      if (name != null) ...[const SizedBox(height: 5),
        Text(name!, style: kBody(size: 10, weight: FontWeight.w800, color: KawaiiColors.heading))],
    ]);
    if (!interactive) return avatar;
    return KawaiiPressable(
      pressScale: 0.90,
      onTap: () { if (playSound) KawaiiSoundEngine().play(KawaiiSound.boop); },
      child: avatar,
    );
  }
}

// ━━━ STAT ━━━
class KawaiiStat extends StatefulWidget {
  final int value;
  final String label;
  final Color color;
  final bool playSound;
  const KawaiiStat({super.key, required this.value, required this.label, required this.color,
    this.playSound = true});
  @override
  State<KawaiiStat> createState() => _KawaiiStatState();
}

class _KawaiiStatState extends State<KawaiiStat> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<int> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(milliseconds: 900), vsync: this);
    _anim = IntTween(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return KawaiiPressable(
      pressScale: 0.92,
      onTap: () { if (widget.playSound) KawaiiSoundEngine().play(KawaiiSound.tick); },
      child: Column(children: [
        KawaiiSurface(tactile: false,
          gloss: GlossLevel.medium,
          shineOpacity: 0.25,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [widget.color.withValues(alpha: KawaiiOpacity.soft),
                       widget.color.withValues(alpha: KawaiiOpacity.ghost)]),
            borderRadius: BorderRadius.circular(KawaiiBorderRadius.xxl),
            border: Border.all(color: widget.color.withValues(alpha: KawaiiOpacity.muted), width: KawaiiBorderWidth.medium),
            boxShadow: [KawaiiShadows.medium(widget.color)],
          ),
          child: AnimatedBuilder(animation: _anim,
            builder: (context, _) => Text('${_anim.value}+', style: kHeading(size: 21, color: widget.color))),
        ),
        const SizedBox(height: 6),
        Text(widget.label.toUpperCase(), style: kBody(size: 10, weight: FontWeight.w800, color: KawaiiColors.muted)
            .copyWith(letterSpacing: 1)),
      ]),
    );
  }
}

// ━━━ PROGRESS (animated fill) ━━━
class KawaiiProgress extends StatefulWidget {
  final double pct;
  final Color color;
  final String label;
  final Duration delay;
  const KawaiiProgress({super.key, required this.pct, required this.color,
    required this.label, this.delay = Duration.zero});
  @override
  State<KawaiiProgress> createState() => _KawaiiProgressState();
}

class _KawaiiProgressState extends State<KawaiiProgress> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fill;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _fill = Tween<double>(begin: 0, end: widget.pct / 100).animate(
      CurvedAnimation(parent: _ctrl, curve: KawaiiCurves.soft));
    Future.delayed(widget.delay, () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(widget.label, style: kBody(size: 12, weight: FontWeight.w800, color: KawaiiColors.heading)),
        AnimatedBuilder(animation: _fill,
          builder: (context, _) => Text('${(_fill.value * 100).toInt()}%',
            style: kBody(size: 12, weight: FontWeight.w800, color: widget.color))),
      ]),
      const SizedBox(height: 5),
      Container(height: 18, decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(KawaiiBorderRadius.sm),
        color: const Color(0x1AC8A0B4),
        border: Border.all(color: const Color(0x20C8A0B4), width: KawaiiBorderWidth.light)),
        child: ClipRRect(borderRadius: BorderRadius.circular(KawaiiBorderRadius.xs),
          child: AnimatedBuilder(
            animation: _fill,
            builder: (context, _) => Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(widthFactor: _fill.value.clamp(0.01, 1.0),
                child: KawaiiSurface(tactile: false,
                  gloss: GlossLevel.medium,
                  shineOpacity: 0.50,
                  shineHeight: 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(KawaiiBorderRadius.xs),
                    gradient: LinearGradient(colors: [
                      widget.color.withValues(alpha: KawaiiOpacity.heavy), widget.color])),
                  child: const SizedBox.expand(),
                )),
            ),
          ))),
    ]);
  }
}

// ━━━ TOGGLE ━━━
class KawaiiToggle extends StatefulWidget {
  final String label;
  final Color color;
  final bool playSound;
  const KawaiiToggle({super.key, required this.label, this.color = const Color(0xFFF08CAE),
    this.playSound = true});
  @override
  State<KawaiiToggle> createState() => _KawaiiToggleState();
}

class _KawaiiToggleState extends State<KawaiiToggle> {
  bool _on = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { setState(() => _on = !_on); if (widget.playSound) KawaiiSoundEngine().play(KawaiiSound.toggle); },
      child: Row(children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250), curve: KawaiiCurves.spring,
          width: 48, height: 28, padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(KawaiiBorderRadius.md),
            gradient: LinearGradient(colors: _on
              ? [widget.color.withValues(alpha: KawaiiOpacity.heavy), widget.color]
              : [const Color(0x20C8A0B4), const Color(0x20C8A0B4)]),
            border: Border.all(
              color: _on ? widget.color : const Color(0x30C8A0B4), width: KawaiiBorderWidth.medium),
            boxShadow: [BoxShadow(
              color: _on ? widget.color.withValues(alpha: 0.2) : Colors.transparent,
              blurRadius: 5, offset: const Offset(0, 2))]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(KawaiiBorderRadius.md - KawaiiBorderWidth.medium),
            child: Stack(children: [
              // Track shine — same top-lit gradient as KawaiiSurface
              Positioned.fill(child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    stops: const [0.0, 0.4, 0.45],
                    colors: [
                      Colors.white.withValues(alpha: _on ? 0.25 : 0.12),
                      Colors.white.withValues(alpha: _on ? 0.04 : 0.02),
                      Colors.transparent,
                    ])))),
              AnimatedAlign(
                duration: const Duration(milliseconds: 250), curve: KawaiiCurves.spring,
                alignment: _on ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(width: 20, height: 20,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                    gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      colors: [Colors.white, Color(0xFFF8F0F4)]),
                    border: Border.all(color: const Color(0x38C8A0B4), width: KawaiiBorderWidth.light),
                    boxShadow: [KawaiiShadows.soft(Colors.black)]),
                  // Knob shine
                  child: ClipOval(child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        stops: const [0.0, 0.45, 0.5],
                        colors: [
                          Colors.white.withValues(alpha: 0.55),
                          Colors.white.withValues(alpha: 0.08),
                          Colors.transparent,
                        ])),
                    child: const SizedBox.expand(),
                  )))),
            ]))),
        const SizedBox(width: KawaiiSpacing.sm + 6),
        Text(widget.label, style: kBody(size: 13, weight: FontWeight.w800, color: KawaiiColors.heading)),
      ]),
    );
  }
}

// ━━━ CHAT MESSAGE (fixed avatar alignment) ━━━
class ChatMessage extends StatelessWidget {
  final String text;
  final bool isMe;
  final String? name;
  final String time;
  final bool read;
  final Color color;
  final Widget? avatar;
  const ChatMessage({super.key, required this.text, this.isMe = false,
    this.name, required this.time, this.read = false,
    this.color = const Color(0xFFF06292), this.avatar});

  @override
  Widget build(BuildContext context) {
    final bubbleRadius = BorderRadius.only(
      topLeft: const Radius.circular(KawaiiBorderRadius.lg),
      topRight: const Radius.circular(KawaiiBorderRadius.lg),
      bottomLeft: Radius.circular(isMe ? KawaiiBorderRadius.lg : 4),
      bottomRight: Radius.circular(isMe ? 4 : KawaiiBorderRadius.lg));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMe && avatar != null) ...[
          Padding(padding: const EdgeInsets.only(top: 2), child: avatar!),
          const SizedBox(width: KawaiiSpacing.md)],
        Flexible(child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (name != null && !isMe) Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 3),
              child: Text(name!, style: kBody(size: 10, weight: FontWeight.w800, color: color)
                  .copyWith(letterSpacing: 0.3))),
            !isMe
              ? KawaiiSurface(tactile: false,
                  gloss: GlossLevel.subtle,
                  shineOpacity: 0.3,
                  shineHeight: 0.36,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
                  decoration: BoxDecoration(
                    borderRadius: bubbleRadius,
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      colors: [color.withValues(alpha: 0.09), color.withValues(alpha: 0.05)]),
                    border: Border.all(color: color.withValues(alpha: 0.09), width: KawaiiBorderWidth.light),
                    boxShadow: [BoxShadow(color: color.withValues(alpha: KawaiiOpacity.ghost),
                      blurRadius: 8, offset: const Offset(0, 2))]),
                  child: Text(text, style: kBody(size: 13.5, color: KawaiiColors.heading).copyWith(height: 1.55)),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
                  decoration: BoxDecoration(
                    borderRadius: bubbleRadius,
                    gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      colors: [Color(0x1AC8A0B4), Color(0x0DC8A0B4)]),
                    border: Border.all(color: const Color(0x1AC8A0B4), width: KawaiiBorderWidth.light)),
                  child: Text(text, style: kBody(size: 13.5, color: KawaiiColors.ownBubbleText).copyWith(height: 1.55)),
                ),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(time, style: kBody(size: 9, color: KawaiiColors.subtle)),
                if (read && isMe) ...[const SizedBox(width: KawaiiSpacing.sm),
                  kawaiiIcon(const CheckPainter(color: KawaiiColors.greenBottom), size: 10)],
              ])),
          ],
        )),
      ],
    );
  }
}

// ━━━ TYPING INDICATOR ━━━
class TypingIndicator extends StatefulWidget {
  final Color color;
  const TypingIndicator({super.key, this.color = const Color(0xFFF06292)});
  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() { super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(); }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: KawaiiSpacing.xl, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(KawaiiBorderRadius.lg),
            topRight: Radius.circular(KawaiiBorderRadius.lg),
            bottomRight: Radius.circular(KawaiiBorderRadius.lg),
            bottomLeft: Radius.circular(4)),
          color: widget.color.withValues(alpha: KawaiiOpacity.whisper),
          border: Border.all(color: widget.color.withValues(alpha: KawaiiOpacity.whisper))),
        child: Row(mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) => AnimatedBuilder(
            animation: _ctrl,
            builder: (context, _) {
              final t = (_ctrl.value - i * 0.15) % 1.0;
              double op = 0.2, dy = 0;
              if (t > 0 && t < 0.3) { op = 0.2 + 0.3 * (t / 0.3); dy = -3 * (t / 0.3); }
              else if (t >= 0.3 && t < 0.6) { op = 0.5 - 0.3 * ((t - 0.3) / 0.3); dy = -3 + 3 * ((t - 0.3) / 0.3); }
              return Container(margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                child: Transform.translate(offset: Offset(0, dy),
                  child: Opacity(opacity: op,
                    child: Container(width: 6, height: 6,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color)))));
            },
          ))),
      ),
    );
  }
}

// ━━━ INPUT ━━━
class KawaiiInput extends StatelessWidget {
  final String placeholder, btnLabel;
  final Color color;
  final Widget? icon;
  const KawaiiInput({super.key, required this.placeholder, this.btnLabel = 'Send',
    this.color = const Color(0xFFE8C0D8), this.icon});

  @override
  Widget build(BuildContext context) {
    return KawaiiSurface(
      gloss: GlossLevel.subtle,
      shineOpacity: 0.20,
      shineHeight: 0.36,
      padding: const EdgeInsets.fromLTRB(14, 5, 5, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(KawaiiBorderRadius.lg),
        gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Color(0xBFFFFFFF), Color(0x8CFFF8FC)]),
        border: Border.all(color: color, width: KawaiiBorderWidth.medium),
        boxShadow: [KawaiiShadows.medium(color)]),
      child: Row(children: [
        if (icon != null) ...[Opacity(opacity: KawaiiOpacity.strong, child: icon!),
          const SizedBox(width: KawaiiSpacing.md)],
        Expanded(child: TextField(
          decoration: InputDecoration(
            hintText: placeholder, hintStyle: kBody(size: 13, color: KawaiiColors.subtle),
            border: InputBorder.none, isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8)),
          style: kBody(size: 13, color: KawaiiColors.heading),
        )),
        const SizedBox(width: KawaiiSpacing.md),
        KawaiiButton.pink(btnLabel, small: true,
          i: kawaiiIcon(const SendPainter(color: KawaiiColors.pinkText), size: 12),
          onTap: () => KawaiiSoundEngine().play(KawaiiSound.send)),
      ]),
    );
  }
}

// ━━━ TEXT FIELD (no button) ━━━
class KawaiiTextField extends StatelessWidget {
  final String placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final Color color;
  final int maxLines;
  final TextInputType? keyboardType;
  const KawaiiTextField({super.key, required this.placeholder,
    this.controller, this.onChanged,
    this.color = KawaiiColors.cardBorder,
    this.maxLines = 1, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return KawaiiSurface(
      gloss: GlossLevel.subtle,
      shineOpacity: 0.20,
      shineHeight: 0.36,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(KawaiiBorderRadius.lg),
        gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Color(0xBFFFFFFF), Color(0x8CFFF8FC)]),
        border: Border.all(color: color, width: KawaiiBorderWidth.medium),
        boxShadow: [KawaiiShadows.medium(color)]),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: placeholder, hintStyle: kBody(size: 13, color: KawaiiColors.subtle),
          border: InputBorder.none, isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8)),
        style: kBody(size: 13, color: KawaiiColors.heading),
      ),
    );
  }
}

// ━━━ NOTIFICATION ━━━
// [OPT #7] Callers wrap KawaiiNotification in RepaintBoundary in main.dart.
class KawaiiNotification extends StatelessWidget {
  final String title, text, time;
  final Color color;
  final Widget icon;
  final bool playSound;
  const KawaiiNotification({super.key, required this.title, required this.text,
    required this.color, required this.icon, this.time = 'just now',
    this.playSound = true});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: KawaiiPressable(
        onTap: () { if (playSound) KawaiiSoundEngine().play(KawaiiSound.notif); },
        pressScale: 0.98,
        child: KawaiiSurface(tactile: false,
          gloss: GlossLevel.subtle,
          shineOpacity: 0.35,
          shineHeight: 0.40,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(KawaiiBorderRadius.lg),
            gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Color(0xA6FFFFFF), Color(0x73FFF8FC)]),
            border: Border.all(color: color.withValues(alpha: KawaiiOpacity.hint), width: KawaiiBorderWidth.light),
            boxShadow: [BoxShadow(color: color.withValues(alpha: KawaiiOpacity.ghost),
              blurRadius: 8, offset: const Offset(0, 3))]),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            KawaiiBadge(size: 36, interactive: false,
              bg: color.withValues(alpha: KawaiiOpacity.hint),
              border: color.withValues(alpha: KawaiiOpacity.muted), child: icon),
            const SizedBox(width: 11),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(title, style: kHeading(size: 12.5)),
                Text(time, style: kBody(size: 9.5, color: KawaiiColors.subtle)),
              ]),
              const SizedBox(height: 2),
              Text(text, style: kBody(size: 11.5, color: const Color(0xFF7D5A6C)).copyWith(height: 1.5)),
            ])),
            const SizedBox(width: KawaiiSpacing.md),
            Container(width: 7, height: 7, margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(shape: BoxShape.circle, color: color,
                boxShadow: [BoxShadow(color: color.withValues(alpha: KawaiiOpacity.medium), blurRadius: 5)])),
          ]),
        ),
      ),
    );
  }
}

// ━━━ SOUND CARD ━━━
// [OPT #7] Callers wrap SoundCard in RepaintBoundary in main.dart.
class SoundCard extends StatelessWidget {
  final String label, id, desc;
  final Color color, accent;
  final KawaiiSound sound;
  final bool playSound;
  const SoundCard({super.key, required this.label, required this.id, required this.desc,
    required this.color, required this.accent, required this.sound,
    this.playSound = true});

  @override
  Widget build(BuildContext context) {
    return KawaiiPressable(
      onTap: () { if (playSound) KawaiiSoundEngine().play(sound); },
      pressScale: 0.98,
      child: KawaiiSurface(tactile: false,
        gloss: GlossLevel.subtle,
        shineOpacity: 0.25,
        shineHeight: 0.40,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(KawaiiBorderRadius.lg),
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [color.withValues(alpha: KawaiiOpacity.ghost),
                     color.withValues(alpha: 0.02)]),
          border: Border.all(color: color.withValues(alpha: KawaiiOpacity.hint), width: KawaiiBorderWidth.light)),
        child: Row(children: [
          KawaiiBadge(size: 38, interactive: false, bg: accent, border: color,
            child: Padding(padding: const EdgeInsets.only(left: 2),
              child: kawaiiIcon(const PlayTrianglePainter(), size: 14))),
          const SizedBox(width: KawaiiSpacing.lg),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(label, style: kHeading(size: 13.5)),
              const SizedBox(width: KawaiiSpacing.md),
              Text(id.toUpperCase(), style: kBody(size: 10, weight: FontWeight.w800, color: color)
                  .copyWith(letterSpacing: 0.5)),
            ]),
            const SizedBox(height: 2),
            Text(desc, style: kBody(size: 11, color: KawaiiColors.muted).copyWith(height: 1.45)),
          ])),
        ]),
      ),
    );
  }
}

// ━━━ SOUND PRINCIPLE CHIP ━━━
class SoundPrinciple extends StatelessWidget {
  final String title, desc;
  final Color color;
  const SoundPrinciple({super.key, required this.title, required this.desc, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(KawaiiBorderRadius.md),
        color: color.withValues(alpha: KawaiiOpacity.ghost),
        border: Border.all(color: color.withValues(alpha: KawaiiOpacity.hint), width: KawaiiBorderWidth.light)),
      child: Column(children: [
        Text(title, style: kHeading(size: 11.5, color: color)),
        const SizedBox(height: 2),
        Text(desc, style: kBody(size: 10, color: KawaiiColors.muted), textAlign: TextAlign.center),
      ]),
    ));
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  AMBIENT SPARKLE FIELD — background decoration
//  [OPT #4] Slowed animation duration to 12s (was 6s) and the visual
//  cycle is already slow. The sparkles are subtle ambient decoration
//  that don't need high-frequency updates.
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

@immutable
class _Sparkle {
  final double x, y, size, phase;
  final Color fill, stroke;
  const _Sparkle(this.x, this.y, this.size, this.phase, this.fill, this.stroke);
}

class KawaiiSparkleField extends StatefulWidget {
  final int count;
  final Widget? child;
  const KawaiiSparkleField({super.key, this.count = 14, this.child});
  @override
  State<KawaiiSparkleField> createState() => _KawaiiSparkleFieldState();
}

class _KawaiiSparkleFieldState extends State<KawaiiSparkleField> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late List<_Sparkle> _sparkles;

  static const _palette = [
    [Color(0xFFFFD54F), Color(0xFFD4940C)],  // gold
    [Color(0xFFF8BBD0), Color(0xFFD0688A)],  // pink
    [Color(0xFFCE93D8), Color(0xFF7B1FA2)],  // violet
    [Color(0xFFA5D6A7), Color(0xFF388E3C)],  // green
    [Color(0xFF90CAF9), Color(0xFF1976D2)],  // blue
  ];

  @override
  void initState() {
    super.initState();
    // [OPT #4] 12-second cycle for ambient sparkles — they're subtle
    // background decoration that don't need fast updates.
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();
    final rng = Random();
    _sparkles = List.generate(widget.count, (i) {
      final colors = _palette[i % _palette.length];
      return _Sparkle(
        rng.nextDouble(), rng.nextDouble(),
        4 + rng.nextDouble() * 10,
        rng.nextDouble(),
        colors[0], colors[1]);
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) => CustomPaint(
            painter: _SparkleFieldPainter(_sparkles, _ctrl.value))))),
      if (widget.child != null) widget.child!,
    ]);
  }
}

class _SparkleFieldPainter extends CustomPainter {
  final List<_Sparkle> sparkles;
  final double t;
  const _SparkleFieldPainter(this.sparkles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in sparkles) {
      final phase = (t + s.phase) % 1.0;
      final scale = 0.5 + 0.5 * sin(2 * pi * phase);
      final opacity = (0.12 + 0.28 * sin(2 * pi * phase)).clamp(0.0, 1.0);
      final dy = sin(2 * pi * phase) * 3;
      final cx = s.x * size.width;
      final cy = s.y * size.height + dy;
      final r = s.size * scale / 2;

      canvas.save();
      canvas.translate(cx, cy);

      final path = Path()
        ..moveTo(0, -r)
        ..cubicTo(0, -r, r * 0.16, -r * 0.3, r, 0)
        ..cubicTo(r * 0.16, r * 0.3, 0, r, 0, r)
        ..cubicTo(0, r, -r * 0.16, r * 0.3, -r, 0)
        ..cubicTo(-r * 0.16, -r * 0.3, 0, -r, 0, -r)
        ..close();
      canvas.drawPath(path, Paint()..color = s.fill.withValues(alpha: opacity));
      canvas.drawPath(path, Paint()
        ..color = s.stroke.withValues(alpha: opacity * 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_SparkleFieldPainter old) => old.t != t;
}

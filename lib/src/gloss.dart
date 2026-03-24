import 'package:flutter/material.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  DESIGN TOKENS — all magic numbers live here, not in widgets
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Controls how much glossy treatment a surface gets.
enum GlossLevel {
  /// Thin shine gradient only (tags, chat bubbles, sound cards)
  subtle,
  /// Shine gradient + inset highlight (badges, avatars, stat pills)
  medium,
  /// Shine gradient + radial highlight (buttons — the signature element)
  full,
}

/// Spacing/sizing tokens derived from the design language.
class KawaiiTokens {
  KawaiiTokens._();

  // Shine highlight (matches React: top:2, left:6, right:6)
  static const shineInsetTop = 2.0;
  static const shineInsetH = 6.0;

  // Shine opacity per gloss level (flat white, not gradient)
  static double shineOpacity(GlossLevel level) => switch (level) {
    GlossLevel.subtle => 0.25,
    GlossLevel.medium => 0.35,
    GlossLevel.full   => 0.28,
  };

  // Radial highlight (full gloss only) — matches ellipse at 30% 20%
  static const radialCenter = Alignment(-0.4, -0.6);
  static const radialRadius = 1.3;
  static const radialOpacity = 0.35;

  // Press animation
  static const pressDuration = Duration(milliseconds: 100);
  static const pressScale = 0.97;
  static const pressTranslateY = 2.0;
  static const pressCurve = Cubic(0.34, 1.56, 0.64, 1.0);

  // Entrance animation
  static const entranceDuration = Duration(milliseconds: 600);
  static const entranceSlide = 32.0;
  static const entranceCurve = Cubic(0.22, 1.0, 0.36, 1.0);
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  KAWAII SURFACE — the core abstraction
//  [OPT #2] Removed LayoutBuilder — shine uses Positioned.fill directly.
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Adds the kawaii material treatment (glossy shine, radial highlight)
/// to any decorated container. Every glossy element goes through this.
///
/// The shine bar uses a top-to-transparent gradient (not flat color)
/// and sizes relative to the actual container via [FractionallySizedBox].
class KawaiiSurface extends StatelessWidget {
  final Widget child;
  final BoxDecoration decoration;
  final GlossLevel gloss;
  final EdgeInsets padding;
  final double? height;
  final double? width;
  final double? shineOpacity;
  final double shineHeight;

  const KawaiiSurface({
    super.key,
    required this.child,
    required this.decoration,
    this.gloss = GlossLevel.subtle,
    this.padding = EdgeInsets.zero,
    this.height,
    this.width,
    this.shineOpacity,
    this.shineHeight = 0.36,
  });

  double get _shine => shineOpacity ?? KawaiiTokens.shineOpacity(gloss);

  bool get _isCircle => decoration.shape == BoxShape.circle;

  BorderRadius get _clipRadius {
    if (_isCircle) return BorderRadius.circular(9999);
    final br = decoration.borderRadius;
    if (br is BorderRadius) {
      return BorderRadius.only(
        topLeft: Radius.circular((br.topLeft.x - 1).clamp(0, 999)),
        topRight: Radius.circular((br.topRight.x - 1).clamp(0, 999)),
        bottomLeft: Radius.circular((br.bottomLeft.x - 1).clamp(0, 999)),
        bottomRight: Radius.circular((br.bottomRight.x - 1).clamp(0, 999)),
      );
    }
    return BorderRadius.circular(11);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: decoration,
      child: _isCircle
        ? ClipOval(child: _buildStack())
        : ClipRRect(borderRadius: _clipRadius, child: _buildStack()),
    );
  }

  Widget _buildStack() {
    return Stack(
          alignment: Alignment.center,
          children: [
            // Invisible sizer — padding + child defines intrinsic width
            if (padding != EdgeInsets.zero)
              Visibility(
                visible: false,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Padding(padding: padding, child: child),
              ),

            // Radial highlight (full gloss only — buttons)
            if (gloss == GlossLevel.full)
              Positioned.fill(child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: KawaiiTokens.radialCenter,
                    radius: KawaiiTokens.radialRadius,
                    colors: [
                      Colors.white.withValues(alpha: KawaiiTokens.radialOpacity),
                      Colors.transparent,
                    ],
                  ),
                ),
              )),

            // Shine — full-width top-lit surface (no LayoutBuilder needed)
            Positioned.fill(child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, shineHeight, shineHeight + 0.05],
                  colors: [
                    Colors.white.withValues(alpha: _shine),
                    Colors.white.withValues(alpha: _shine * 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            )),

            // Content ON TOP (highest z-order, like CSS z-index: 1)
            Padding(padding: padding, child: child),
          ],
        );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  KAWAII PRESSABLE — zero-delay press, bouncy release
//  [OPT #3] Consolidated 3 implicit animations (AnimatedScale +
//  AnimatedSlide + AnimatedOpacity) into a single TweenAnimationBuilder
//  that drives scale, translate, and opacity together.
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiPressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressScale;
  final double pressTranslateY;

  const KawaiiPressable({
    super.key,
    required this.child,
    this.onTap,
    this.pressScale = 0.88,
    this.pressTranslateY = 4.0,
  });

  @override
  State<KawaiiPressable> createState() => _KawaiiPressableState();
}

class _KawaiiPressableState extends State<KawaiiPressable>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _translateAnim;
  late Animation<double> _opacityAnim;
  DateTime _pressedAt = DateTime(0);

  @override
  void initState() {
    super.initState();
    // Controller value 1 = normal (resting), value 0 = pressed.
    // Starts at 1 (normal state).
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: 1.0,
    );
    final curved = CurvedAnimation(
      parent: _ctrl,
      curve: KawaiiTokens.pressCurve,
    );
    // begin = pressed values (controller at 0), end = normal values (controller at 1)
    _scaleAnim = Tween<double>(begin: widget.pressScale, end: 1.0).animate(curved);
    _translateAnim = Tween<double>(begin: widget.pressTranslateY, end: 0.0).animate(curved);
    _opacityAnim = Tween<double>(begin: 0.85, end: 1.0).animate(curved);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _press() {
    _pressedAt = DateTime.now();
    // Instant snap to pressed state (value 0)
    _ctrl.value = 0.0;
  }

  void _release() {
    final elapsed = DateTime.now().difference(_pressedAt);
    final remaining = const Duration(milliseconds: 80) - elapsed;
    if (remaining > Duration.zero) {
      // Hold pressed state briefly, then animate to normal
      Future.delayed(remaining, () {
        if (mounted) _ctrl.forward();
      });
    } else {
      // Animate back to normal with spring curve
      _ctrl.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _press(),
      onTapUp: (_) {
        _release();
        widget.onTap?.call();
      },
      onTapCancel: () => _release(),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _translateAnim.value),
            child: Transform.scale(
              scale: _scaleAnim.value,
              child: Opacity(
                opacity: _opacityAnim.value.clamp(0.0, 1.0),
                child: child,
              ),
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  KAWAII ENTRANCE — staggered fade + slide-up
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiEntrance extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double slideOffset;

  const KawaiiEntrance({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = KawaiiTokens.entranceDuration,
    this.slideOffset = KawaiiTokens.entranceSlide,
  });

  @override
  State<KawaiiEntrance> createState() => _KawaiiEntranceState();
}

class _KawaiiEntranceState extends State<KawaiiEntrance>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)));
    _slide = Tween<Offset>(
      begin: Offset(0, widget.slideOffset),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _ctrl,
      curve: KawaiiTokens.entranceCurve,
    ));

    // Start after delay
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) => Transform.translate(
        offset: _slide.value,
        child: Opacity(opacity: _opacity.value, child: child),
      ),
      child: widget.child,
    );
  }
}

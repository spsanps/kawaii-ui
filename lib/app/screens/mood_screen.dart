import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kawaii_ui/kawaii_ui.dart';
import '../models/models.dart';
import '../models/store.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  MOOD FACE PAINTERS — cute minimal faces drawn with simple arcs
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Happy: smiling face with upturned crescent eyes and a wide smile
class _HappyFacePainter extends CustomPainter {
  final Color color;
  _HappyFacePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.07
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.38;

    // Upturned crescent eyes (arcs curving upward)
    final eyeY = cy - r * 0.22;
    final eyeSpread = r * 0.48;
    final eyeR = r * 0.22;
    // Left eye — upward arc
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx - eyeSpread, eyeY), width: eyeR * 2, height: eyeR * 1.6),
      pi + 0.3, pi - 0.6, false, paint,
    );
    // Right eye — upward arc
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx + eyeSpread, eyeY), width: eyeR * 2, height: eyeR * 1.6),
      pi + 0.3, pi - 0.6, false, paint,
    );

    // Wide smile
    final smileW = r * 0.8;
    final smileH = r * 0.55;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy + r * 0.18), width: smileW * 2, height: smileH * 2),
      0.15, pi - 0.3, false, paint,
    );
  }

  @override
  bool shouldRepaint(_HappyFacePainter old) => old.color != color;
}

/// Calm: serene closed eyes (horizontal lines curving slightly down) and gentle smile
class _CalmFacePainter extends CustomPainter {
  final Color color;
  _CalmFacePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.07
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.38;

    // Closed eyes — gentle downward arcs
    final eyeY = cy - r * 0.15;
    final eyeSpread = r * 0.48;
    final eyeR = r * 0.2;
    // Left eye
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx - eyeSpread, eyeY), width: eyeR * 2, height: eyeR * 1.0),
      0.2, pi - 0.4, false, paint,
    );
    // Right eye
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx + eyeSpread, eyeY), width: eyeR * 2, height: eyeR * 1.0),
      0.2, pi - 0.4, false, paint,
    );

    // Gentle smile (small)
    final smileW = r * 0.5;
    final smileH = r * 0.3;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy + r * 0.28), width: smileW * 2, height: smileH * 2),
      0.2, pi - 0.4, false, paint,
    );
  }

  @override
  bool shouldRepaint(_CalmFacePainter old) => old.color != color;
}

/// Neutral: open dot eyes and a straight mouth
class _NeutralFacePainter extends CustomPainter {
  final Color color;
  _NeutralFacePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.38;

    // Open dot eyes
    final eyeY = cy - r * 0.18;
    final eyeSpread = r * 0.45;
    final dotR = r * 0.12;
    canvas.drawCircle(Offset(cx - eyeSpread, eyeY), dotR, paint);
    canvas.drawCircle(Offset(cx + eyeSpread, eyeY), dotR, paint);

    // Straight mouth
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.07;
    final mouthY = cy + r * 0.32;
    final mouthW = r * 0.42;
    canvas.drawLine(
      Offset(cx - mouthW, mouthY),
      Offset(cx + mouthW, mouthY),
      paint,
    );
  }

  @override
  bool shouldRepaint(_NeutralFacePainter old) => old.color != color;
}

/// Anxious: wide open circle eyes and a wavy mouth
class _AnxiousFacePainter extends CustomPainter {
  final Color color;
  _AnxiousFacePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.38;

    // Wide open circle eyes
    final eyeY = cy - r * 0.2;
    final eyeSpread = r * 0.45;
    final eyeR = r * 0.16;
    canvas.drawCircle(Offset(cx - eyeSpread, eyeY), eyeR, paint);
    canvas.drawCircle(Offset(cx + eyeSpread, eyeY), eyeR, paint);
    // Tiny pupils
    paint.style = PaintingStyle.fill;
    final pupilR = r * 0.06;
    canvas.drawCircle(Offset(cx - eyeSpread, eyeY), pupilR, paint);
    canvas.drawCircle(Offset(cx + eyeSpread, eyeY), pupilR, paint);

    // Wavy mouth
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06;
    final mouthY = cy + r * 0.35;
    final mouthW = r * 0.55;
    final wave = r * 0.12;
    final path = Path()
      ..moveTo(cx - mouthW, mouthY)
      ..cubicTo(
        cx - mouthW * 0.5, mouthY - wave,
        cx, mouthY + wave,
        cx + mouthW * 0.5, mouthY - wave,
      )
      ..cubicTo(
        cx + mouthW * 0.75, mouthY - wave * 0.5,
        cx + mouthW * 0.9, mouthY,
        cx + mouthW, mouthY,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_AnxiousFacePainter old) => old.color != color;
}

/// Sad: droopy eyes (downward arcs) and a downturned frown
class _SadFacePainter extends CustomPainter {
  final Color color;
  _SadFacePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.07
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.38;

    // Droopy eyes — downward arcs
    final eyeY = cy - r * 0.1;
    final eyeSpread = r * 0.45;
    final eyeR = r * 0.2;
    // Left eye — droops right side
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx - eyeSpread, eyeY), width: eyeR * 2, height: eyeR * 1.2),
      0.3, pi - 0.6, false, paint,
    );
    // Right eye — droops left side
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx + eyeSpread, eyeY), width: eyeR * 2, height: eyeR * 1.2),
      0.3, pi - 0.6, false, paint,
    );

    // Downturned frown — inverted arc
    final smileW = r * 0.58;
    final smileH = r * 0.4;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy + r * 0.52), width: smileW * 2, height: smileH * 2),
      pi + 0.2, pi - 0.4, false, paint,
    );
  }

  @override
  bool shouldRepaint(_SadFacePainter old) => old.color != color;
}

/// Returns the correct face painter for a given mood and color
CustomPainter _facePainterFor(Mood mood, Color color) => switch (mood) {
  Mood.happy   => _HappyFacePainter(color: color),
  Mood.calm    => _CalmFacePainter(color: color),
  Mood.neutral => _NeutralFacePainter(color: color),
  Mood.anxious => _AnxiousFacePainter(color: color),
  Mood.sad     => _SadFacePainter(color: color),
};

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  MOOD SCREEN
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class MoodScreen extends StatefulWidget {
  final AppStore store;
  const MoodScreen({super.key, required this.store});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen>
    with TickerProviderStateMixin {
  Mood _selectedMood = Mood.happy;
  Set<Feeling> _selectedFeelings = {};
  double _intensity = 0.5;
  final _noteCtrl = TextEditingController();

  // Pulse animation for selected mood face
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  // Save animation
  late AnimationController _saveCtrl;
  late Animation<double> _saveScaleAnim;
  late Animation<double> _saveFloatAnim;
  late Animation<double> _saveFadeAnim;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Pulse glow — continuous loop
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    // Save bounce + float
    _saveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _saveScaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3)
          .chain(CurveTween(curve: Curves.easeOut)), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 0.95)
          .chain(CurveTween(curve: Curves.easeIn)), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.1)
          .chain(CurveTween(curve: Curves.easeOut)), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 0.0)
          .chain(CurveTween(curve: Curves.easeIn)), weight: 25),
    ]).animate(_saveCtrl);
    _saveFloatAnim = Tween<double>(begin: 0, end: -60).animate(
      CurvedAnimation(parent: _saveCtrl, curve: const Interval(0.3, 1.0, curve: Curves.easeOut)),
    );
    _saveFadeAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _saveCtrl, curve: const Interval(0.6, 1.0, curve: Curves.easeIn)),
    );
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    _pulseCtrl.dispose();
    _saveCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_isSaving) return;

    final note = _noteCtrl.text.trim();
    widget.store.addMood(_selectedMood, _selectedFeelings.toList(), _intensity, note.isEmpty ? null : note);
    _noteCtrl.clear();

    // Trigger save animation
    setState(() => _isSaving = true);
    _saveCtrl.forward(from: 0).then((_) {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _selectedMood = Mood.happy;
          _selectedFeelings = {};
          _intensity = 0.5;
        });
      }
    });

    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Mood saved!',
          style: kBody(size: 13, weight: FontWeight.w700, color: Colors.white),
        ),
        backgroundColor: _selectedMood.color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KawaiiBorderRadius.md)),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.symmetric(horizontal: KawaiiSpacing.page, vertical: KawaiiSpacing.lg),
      ),
    );
  }

  String _relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.month}/${dt.day}';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.store,
      builder: (context, _) {
        final entries = widget.store.moods;
        return ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: KawaiiSpacing.page,
            vertical: KawaiiSpacing.xl,
          ),
          children: [
            // ── Prompt ──
            Text(
              'How are you feeling?',
              style: kHeading(size: 22, color: KawaiiColors.heading),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: KawaiiSpacing.xxl),

            // ── Mood Picker with Animated Faces ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: Mood.values.map((mood) {
                final selected = mood == _selectedMood;
                return KawaiiPressable(
                  pressScale: 0.93,
                  pressTranslateY: 2,
                  onTap: () {
                    setState(() => _selectedMood = mood);
                    KawaiiSoundEngine().play(KawaiiSound.tick);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBuilder(
                        animation: _pulseAnim,
                        builder: (context, child) {
                          final glowOpacity = selected
                              ? 0.15 + _pulseAnim.value * 0.15
                              : 0.0;
                          final scale = selected
                              ? 1.0 + _pulseAnim.value * 0.06
                              : 1.0;
                          return Transform.scale(
                            scale: scale,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: selected
                                    ? [
                                        BoxShadow(
                                          color: mood.color.withValues(alpha: glowOpacity),
                                          blurRadius: 16 + _pulseAnim.value * 8,
                                          spreadRadius: 2 + _pulseAnim.value * 3,
                                        ),
                                      ]
                                    : [],
                              ),
                              child: child,
                            ),
                          );
                        },
                        child: KawaiiSurface(
                          gloss: selected ? GlossLevel.full : GlossLevel.subtle,
                          width: 54,
                          height: 54,
                          shineOpacity: selected ? 0.35 : 0.15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: selected
                                  ? [mood.accent, mood.color]
                                  : [
                                      mood.color.withValues(alpha: KawaiiOpacity.whisper),
                                      mood.color.withValues(alpha: KawaiiOpacity.ghost),
                                    ],
                            ),
                            border: Border.all(
                              color: selected
                                  ? mood.color
                                  : mood.color.withValues(alpha: KawaiiOpacity.hint),
                              width: selected
                                  ? KawaiiBorderWidth.thick
                                  : KawaiiBorderWidth.thin,
                            ),
                            boxShadow: selected
                                ? [KawaiiShadows.medium(mood.color)]
                                : [],
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: CustomPaint(
                                painter: _facePainterFor(
                                  mood,
                                  selected ? Colors.white : mood.color,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        mood.label,
                        style: kBody(
                          size: 10,
                          weight: selected ? FontWeight.w800 : FontWeight.w600,
                          color: selected ? mood.color : KawaiiColors.muted,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: KawaiiSpacing.xl),

            // ── Feeling Tags (multi-select, max 3) ──
            Text('Tell me more...', style: kBody(size: 12, weight: FontWeight.w800, color: KawaiiColors.muted)),
            const SizedBox(height: KawaiiSpacing.md),
            Wrap(
              spacing: 6, runSpacing: 6,
              children: () {
                // Sort: promoted feelings first, then the rest
                final promoted = FeelingX.promotedFor(_selectedMood);
                final sorted = [...promoted, ...Feeling.values.where((f) => !promoted.contains(f))];
                return sorted.map((f) {
                  final selected = _selectedFeelings.contains(f);
                  final atMax = _selectedFeelings.length >= 3 && !selected;
                  return KawaiiPressable(
                    pressScale: 0.92,
                    pressTranslateY: 2,
                    onTap: atMax ? null : () {
                      setState(() {
                        if (selected) { _selectedFeelings.remove(f); }
                        else { _selectedFeelings.add(f); }
                      });
                      KawaiiSoundEngine().play(KawaiiSound.tick);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: KawaiiCurves.spring,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(KawaiiBorderRadius.md),
                        gradient: selected ? LinearGradient(
                          colors: [f.color.withValues(alpha: 0.25), f.color.withValues(alpha: 0.12)]) : null,
                        color: selected ? null : (atMax
                          ? KawaiiColors.glass.withValues(alpha: 0.04)
                          : KawaiiColors.glass.withValues(alpha: 0.08)),
                        border: Border.all(
                          color: selected ? f.color.withValues(alpha: 0.5)
                            : KawaiiColors.glass.withValues(alpha: atMax ? 0.06 : 0.15),
                          width: KawaiiBorderWidth.light),
                      ),
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: kBody(size: 11, weight: FontWeight.w800,
                          color: selected ? f.color : (atMax ? KawaiiColors.subtle : KawaiiColors.muted)),
                        child: Text(f.label),
                      ),
                    ),
                  );
                }).toList();
              }(),
            ),
            const SizedBox(height: KawaiiSpacing.xxl),

            // ── Intensity Slider with Orb Visualization ──
            Row(
              children: [
                Text(
                  'Intensity',
                  style: kBody(size: 12, weight: FontWeight.w800, color: KawaiiColors.heading),
                ),
                const Spacer(),
                Text(
                  '${(_intensity * 100).round()}%',
                  style: kBody(size: 12, weight: FontWeight.w800, color: _selectedMood.color),
                ),
              ],
            ),
            const SizedBox(height: KawaiiSpacing.sm),
            KawaiiSlider(
              value: _intensity,
              color: _selectedMood.color,
              onChanged: (v) => setState(() => _intensity = v),
            ),
            const SizedBox(height: KawaiiSpacing.lg),

            // ── Intensity Orb ──
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                width: 24 + _intensity * 36,
                height: 24 + _intensity * 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _selectedMood.accent,
                      _selectedMood.color.withValues(alpha: 0.7),
                      _selectedMood.color.withValues(alpha: 0.0),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _selectedMood.color.withValues(alpha: 0.15 + _intensity * 0.25),
                      blurRadius: 12 + _intensity * 20,
                      spreadRadius: _intensity * 6,
                    ),
                  ],
                ),
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    width: 12 + _intensity * 18,
                    height: 12 + _intensity * 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _selectedMood.accent.withValues(alpha: 0.9),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.6),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: KawaiiSpacing.xl),

            // ── Journal Note Input ──
            KawaiiSurface(
              gloss: GlossLevel.subtle,
              shineOpacity: 0.20,
              shineHeight: 0.36,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(KawaiiBorderRadius.lg),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xBFFFFFFF), Color(0x8CFFF8FC)],
                ),
                border: Border.all(
                  color: KawaiiColors.cardBorder,
                  width: KawaiiBorderWidth.medium,
                ),
                boxShadow: [KawaiiShadows.medium(KawaiiColors.cardBorder)],
              ),
              child: TextField(
                controller: _noteCtrl,
                decoration: InputDecoration(
                  hintText: 'Add a note about your day...',
                  hintStyle: kBody(size: 13, color: KawaiiColors.subtle),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                style: kBody(size: 13, color: KawaiiColors.heading),
                maxLines: 2,
                textInputAction: TextInputAction.done,
              ),
            ),
            const SizedBox(height: KawaiiSpacing.xxl),

            // ── Save Button with Animated Face ──
            Center(
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Floating face animation during save
                  if (_isSaving)
                    AnimatedBuilder(
                      animation: _saveCtrl,
                      builder: (context, _) {
                        return Transform.translate(
                          offset: Offset(0, _saveFloatAnim.value),
                          child: Transform.scale(
                            scale: _saveScaleAnim.value.clamp(0.0, 2.0),
                            child: Opacity(
                              opacity: _saveFadeAnim.value.clamp(0.0, 1.0),
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: CustomPaint(
                                  painter: _facePainterFor(
                                    _selectedMood,
                                    _selectedMood.color,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  KawaiiButton(
                    label: 'Save Entry',
                    colors: KawaiiButtonColors(
                      top: _selectedMood.accent,
                      bottom: _selectedMood.color,
                      stroke: _selectedMood.color,
                      text: Colors.white,
                      shadow: _selectedMood.color,
                    ),
                    hero: true,
                    onTap: _save,
                  ),
                ],
              ),
            ),

            // ── Divider ──
            const Padding(
              padding: EdgeInsets.symmetric(vertical: KawaiiSpacing.lg),
              child: KawaiiDivider(),
            ),

            // ── 7-Day Mood Streak ──
            if (entries.isNotEmpty) ...[
              const SectionLabel('Mood Streak'),
              _buildMoodStreak(entries),
              const SizedBox(height: KawaiiSpacing.xl),
            ],

            // ── Recent Entries Header ──
            const SectionLabel('Recent Entries'),

            // ── Empty State ──
            if (entries.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: KawaiiSpacing.xxl),
                child: Column(
                  children: [
                    SizedBox(
                      width: 64,
                      height: 64,
                      child: CustomPaint(
                        painter: _CalmFacePainter(
                          color: KawaiiColors.muted.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                    const SizedBox(height: KawaiiSpacing.lg),
                    Text(
                      'No entries yet',
                      style: kHeading(size: 16, color: KawaiiColors.muted),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: KawaiiSpacing.sm),
                    Text(
                      'Log your first mood to start\ntracking how you feel!',
                      style: kBody(size: 13, color: KawaiiColors.subtle),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            // ── Entry Cards ──
            else
              ...entries.map((entry) => _buildEntryCard(entry)),

            // Bottom padding for scroll clearance
            const SizedBox(height: KawaiiSpacing.huge),
          ],
        );
      },
    );
  }

  // ── 7-Day Mood Streak Row ──
  Widget _buildMoodStreak(List<MoodEntry> entries) {
    // Take the last 7 entries (or fewer if not enough)
    final recent = entries.take(7).toList().reversed.toList();

    return KawaiiSurface(
      gloss: GlossLevel.subtle,
      shineOpacity: 0.20,
      shineHeight: 0.36,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(KawaiiBorderRadius.lg),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xA6FFFFFF), Color(0x73FFF8FC)],
        ),
        border: Border.all(
          color: KawaiiColors.cardBorder.withValues(alpha: KawaiiOpacity.hint),
          width: KawaiiBorderWidth.light,
        ),
        boxShadow: [
          BoxShadow(
            color: KawaiiColors.glass.withValues(alpha: KawaiiOpacity.ghost),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < 7; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            if (i < recent.length)
              _StreakDot(mood: recent[i].mood, intensity: recent[i].intensity)
            else
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: KawaiiColors.subtle.withValues(alpha: 0.08),
                  border: Border.all(
                    color: KawaiiColors.subtle.withValues(alpha: 0.12),
                    width: 1.5,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  // ── Beautiful Entry Card ──
  Widget _buildEntryCard(MoodEntry entry) {
    final tintColor = entry.mood.color.withValues(alpha: 0.03);
    final intensityPercent = (entry.intensity * 100).round();

    return Padding(
      padding: const EdgeInsets.only(bottom: KawaiiSpacing.md),
      child: KawaiiSurface(
        gloss: GlossLevel.subtle,
        shineOpacity: 0.30,
        shineHeight: 0.38,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(KawaiiBorderRadius.lg),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.lerp(const Color(0xF0FFFFFF), tintColor, 0.5)!,
              Color.lerp(const Color(0xD6FFF8FC), entry.mood.accent.withValues(alpha: 0.06), 0.5)!,
            ],
          ),
          border: Border.all(
            color: entry.mood.color.withValues(alpha: KawaiiOpacity.hint),
            width: KawaiiBorderWidth.light,
          ),
          boxShadow: [
            BoxShadow(
              color: entry.mood.color.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Mini mood face
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [entry.mood.accent, entry.mood.color],
                ),
                boxShadow: [
                  BoxShadow(
                    color: entry.mood.color.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CustomPaint(
                    painter: _facePainterFor(entry.mood, Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(width: KawaiiSpacing.lg),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Mood label + timestamp row
                  Row(
                    children: [
                      Text(
                        entry.mood.label,
                        style: kHeading(size: 13, color: entry.mood.color),
                      ),
                      const Spacer(),
                      Text(
                        _relativeTime(entry.createdAt),
                        style: kBody(size: 10, color: KawaiiColors.subtle),
                      ),
                    ],
                  ),
                  // Feeling tags (if any)
                  if (entry.feelings.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Wrap(spacing: 4, runSpacing: 4, children: entry.feelings.map((f) =>
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: f.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: f.color.withValues(alpha: 0.2), width: 1)),
                        child: Text(f.label, style: kBody(size: 9, weight: FontWeight.w800, color: f.color)),
                      )).toList()),
                  ],
                  const SizedBox(height: 6),
                  // Intensity bar
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: SizedBox(
                            height: 6,
                            child: Stack(
                              children: [
                                // Track
                                Container(
                                  decoration: BoxDecoration(
                                    color: entry.mood.color.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                // Fill
                                FractionallySizedBox(
                                  widthFactor: entry.intensity,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [entry.mood.accent, entry.mood.color],
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$intensityPercent%',
                        style: kBody(
                          size: 10,
                          weight: FontWeight.w800,
                          color: entry.mood.color,
                        ),
                      ),
                    ],
                  ),
                  // Note text
                  if (entry.note != null && entry.note!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      entry.note!,
                      style: kBody(
                        size: 12,
                        weight: FontWeight.w600,
                        color: KawaiiColors.body,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  STREAK DOT — small colored mood dot with mini face
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _StreakDot extends StatelessWidget {
  final Mood mood;
  final double intensity;
  const _StreakDot({required this.mood, required this.intensity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [mood.accent, mood.color],
        ),
        boxShadow: [
          BoxShadow(
            color: mood.color.withValues(alpha: 0.25),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          width: 16,
          height: 16,
          child: CustomPaint(
            painter: _facePainterFor(mood, Colors.white),
          ),
        ),
      ),
    );
  }
}

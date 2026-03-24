import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kawaii_ui/kawaii_ui.dart';

import '../models/models.dart';
import '../models/store.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  HOME / DASHBOARD SCREEN — award-winning edition
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class HomeScreen extends StatelessWidget {
  final AppStore store;
  final void Function(int)? onNavigateToTab;
  const HomeScreen({super.key, required this.store, this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final incompleteTasks = store.tasks.where((t) => !t.done).toList();
        final previewTasks = incompleteTasks.take(5).toList();
        final activeGoals =
            store.goals.where((g) => !g.completed).toList();
        final todayMood = store.todaysMood;

        final sections = <Widget>[
          // ── 1. Animated Hero Greeting ──
          _entranceAt(0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: KawaiiSpacing.page),
              child: _HeroGreeting(),
            ),
          ),

          const SizedBox(height: KawaiiSpacing.xxl),

          // ── 2. Mood Ring Visualization ──
          _entranceAt(1,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: KawaiiSpacing.page),
              child: todayMood != null
                  ? _MoodRing(entry: todayMood)
                  : const _MoodPrompt(),
            ),
          ),

          const SizedBox(height: KawaiiSpacing.sectionGap + 4),

          // ── 3. Stats as Circular Progress Rings ──
          _entranceAt(2,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: KawaiiSpacing.page),
              child: _StatsRingsRow(store: store),
            ),
          ),

          const SizedBox(height: KawaiiSpacing.sectionGap + 4),

          // ── 4. Quick Action Buttons ──
          _entranceAt(3,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: KawaiiSpacing.page),
              child: const _QuickActions(),
            ),
          ),

          const SizedBox(height: KawaiiSpacing.sectionGap + 4),

          // ── 5. Today's Tasks as Swipeable Cards ──
          _entranceAt(4,
            child: _TasksSection(
              tasks: previewTasks,
              totalIncomplete: incompleteTasks.length,
              store: store,
            ),
          ),

          const SizedBox(height: KawaiiSpacing.sectionGap + 4),

          // ── 6. Goals as Horizontal Carousel ──
          _entranceAt(5,
            child: _GoalsCarousel(goals: activeGoals, store: store),
          ),

          // Bottom safety padding
          const SizedBox(height: KawaiiSpacing.huge + 20),
        ];

        return ListView.builder(
          padding: const EdgeInsets.only(top: KawaiiSpacing.xl),
          physics: const BouncingScrollPhysics(),
          itemCount: sections.length,
          itemBuilder: (context, i) => sections[i],
        );
      },
    );
  }

  Widget _entranceAt(int index, {required Widget child}) {
    return KawaiiEntrance(
      delay: Duration(milliseconds: 100 * index),
      child: child,
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  1. HERO GREETING — animated headline with time-of-day painter
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _HeroGreeting extends StatefulWidget {
  @override
  State<_HeroGreeting> createState() => _HeroGreetingState();
}

class _HeroGreetingState extends State<_HeroGreeting>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  int _subtitleIndex = 0;

  static const _subtitles = [
    'Ready to be amazing?',
    "Let's crush today!",
    'You got this!',
    'Make it sparkle!',
    'One step at a time.',
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() =>
              _subtitleIndex = (_subtitleIndex + 1) % _subtitles.length);
          _ctrl.forward(from: 0);
        }
      });
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  bool get _isDaytime {
    final h = DateTime.now().hour;
    return h >= 6 && h < 18;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main greeting
              Row(
                children: [
                  Text(
                    _greeting,
                    style: kHeading(size: 28),
                  ),
                  const SizedBox(width: 8),
                  const SparkleWidget(size: 22),
                ],
              ),
              const SizedBox(height: 6),
              // Animated subtitle
              AnimatedBuilder(
                animation: _ctrl,
                builder: (context, _) {
                  // Fade in 0-0.15, hold 0.15-0.85, fade out 0.85-1.0
                  final t = _ctrl.value;
                  double opacity;
                  if (t < 0.15) {
                    opacity = (t / 0.15).clamp(0.0, 1.0);
                  } else if (t > 0.85) {
                    opacity = ((1.0 - t) / 0.15).clamp(0.0, 1.0);
                  } else {
                    opacity = 1.0;
                  }
                  return Opacity(
                    opacity: opacity,
                    child: Text(
                      _subtitles[_subtitleIndex],
                      style: kBody(
                        size: 14,
                        weight: FontWeight.w600,
                        color: KawaiiColors.muted,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        // Time-of-day icon
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: KawaiiBadge(
            bg: _isDaytime
                ? const Color(0xFFFFF8E1)
                : const Color(0xFFEDE7F6),
            border: _isDaytime
                ? const Color(0xFFFFC107)
                : const Color(0xFF9575CD),
            size: 44,
            interactive: false,
            child: kawaiiIcon(
              _isDaytime
                  ? _SunPainter()
                  : MoonPainter(
                      fill: const Color(0xFFD1C4E9),
                      stroke: const Color(0xFF7C4DFF),
                    ),
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  SUN PAINTER — custom painter for daytime icon
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _SunPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    final r = w * 0.22;

    // Rays
    final rayPaint = Paint()
      ..color = const Color(0xFFFFC107)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 8; i++) {
      final angle = (i * pi / 4);
      final inner = r + w * 0.06;
      final outer = r + w * 0.18;
      canvas.drawLine(
        Offset(cx + inner * cos(angle), cy + inner * sin(angle)),
        Offset(cx + outer * cos(angle), cy + outer * sin(angle)),
        rayPaint,
      );
    }

    // Center circle
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()..color = const Color(0xFFFFE082),
    );
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..color = const Color(0xFFFFC107)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  2. MOOD RING — animated pulsing arc when mood is logged
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _MoodRing extends StatefulWidget {
  final MoodEntry entry;
  const _MoodRing({required this.entry});

  @override
  State<_MoodRing> createState() => _MoodRingState();
}

class _MoodRingState extends State<_MoodRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mood = widget.entry.mood;
    final intensity = widget.entry.intensity;

    return KawaiiCard(
      padding: const EdgeInsets.all(KawaiiSpacing.xl),
      child: Row(
        children: [
          // Mood ring
          AnimatedBuilder(
            animation: _pulse,
            builder: (context, child) {
              final scale = 1.0 + 0.06 * _pulse.value;
              return Transform.scale(
                scale: scale,
                child: child,
              );
            },
            child: SizedBox(
              width: 64,
              height: 64,
              child: CustomPaint(
                painter: _MoodRingPainter(
                  color: mood.color,
                  accent: mood.accent,
                  sweep: intensity,
                ),
                child: Center(
                  child: KawaiiBadge(
                    bg: mood.accent.withValues(alpha: 0.4),
                    border: mood.color.withValues(alpha: 0.5),
                    size: 38,
                    interactive: false,
                    child: Center(
                      child: Text(
                        mood.label[0],
                        style: kHeading(size: 16, color: mood.color),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: KawaiiSpacing.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Mood",
                  style: kBody(
                    size: 10,
                    weight: FontWeight.w800,
                    color: KawaiiColors.muted,
                  ).copyWith(letterSpacing: 1.2),
                ),
                const SizedBox(height: 4),
                Text(
                  mood.label,
                  style: kHeading(size: 20, color: mood.color),
                ),
                if (widget.entry.note != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.entry.note!,
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
    );
  }
}

class _MoodRingPainter extends CustomPainter {
  final Color color;
  final Color accent;
  final double sweep; // 0..1

  _MoodRingPainter({
    required this.color,
    required this.accent,
    required this.sweep,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    final r = size.width / 2 - 4;

    // Background ring
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..color = accent.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );

    // Foreground arc
    final sweepAngle = sweep * 2 * pi;
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
    canvas.drawArc(
      rect,
      -pi / 2,
      sweepAngle,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_MoodRingPainter old) =>
      old.color != color || old.sweep != sweep;
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  MOOD PROMPT — inviting CTA with bouncing arrow
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _MoodPrompt extends StatefulWidget {
  const _MoodPrompt();

  @override
  State<_MoodPrompt> createState() => _MoodPromptState();
}

class _MoodPromptState extends State<_MoodPrompt>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounce;

  @override
  void initState() {
    super.initState();
    _bounce = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KawaiiCard(
      padding: const EdgeInsets.symmetric(
        horizontal: KawaiiSpacing.cardPad,
        vertical: KawaiiSpacing.xl,
      ),
      child: Row(
        children: [
          KawaiiBadge(
            bg: const Color(0xFFF3E5F5),
            border: KawaiiColors.violetBottom,
            size: 44,
            interactive: false,
            child: kawaiiIcon(MoonPainter(), size: 22),
          ),
          const SizedBox(width: KawaiiSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How are you feeling?',
                  style: kHeading(size: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tap to log your mood for today',
                  style: kBody(
                    size: 11,
                    weight: FontWeight.w600,
                    color: KawaiiColors.muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: KawaiiSpacing.md),
          AnimatedBuilder(
            animation: _bounce,
            builder: (context, child) {
              final dy = -4.0 + 8.0 * _bounce.value;
              return Transform.translate(
                offset: Offset(dy, 0),
                child: child,
              );
            },
            child: kawaiiIcon(
              ArrowPainter(color: KawaiiColors.violetBottom),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  3. STATS — circular progress rings
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _StatsRingsRow extends StatelessWidget {
  final AppStore store;
  const _StatsRingsRow({required this.store});

  @override
  Widget build(BuildContext context) {
    final done = store.tasksCompleted;
    final total = store.tasksTotal;
    final taskPct = total > 0 ? done / total : 0.0;

    // Streak: count consecutive days with at least one mood entry
    final streak = _calculateStreak(store.moods);

    final goalsTotal = store.goals.length;
    final goalsDone = store.goals.where((g) => g.completed).length;
    final goalPct = goalsTotal > 0 ? goalsDone / goalsTotal : 0.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _CircularProgressRing(
          value: taskPct,
          label: 'Tasks',
          displayText: '$done/$total',
          color: KawaiiColors.pinkBottom,
          delay: const Duration(milliseconds: 200),
        ),
        _CircularProgressRing(
          value: (streak / 7).clamp(0.0, 1.0),
          label: 'Streak',
          displayText: '${streak}d',
          color: KawaiiColors.violetBottom,
          delay: const Duration(milliseconds: 350),
        ),
        _CircularProgressRing(
          value: goalPct,
          label: 'Goals',
          displayText: '$goalsDone/$goalsTotal',
          color: KawaiiColors.greenBottom,
          delay: const Duration(milliseconds: 500),
        ),
      ],
    );
  }

  int _calculateStreak(List<MoodEntry> moods) {
    if (moods.isEmpty) return 0;
    int streak = 0;
    var day = DateTime.now();
    for (int i = 0; i < 365; i++) {
      final hasEntry = moods.any((m) =>
          m.createdAt.day == day.day &&
          m.createdAt.month == day.month &&
          m.createdAt.year == day.year);
      if (hasEntry) {
        streak++;
        day = day.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }
}

class _CircularProgressRing extends StatefulWidget {
  final double value; // 0..1
  final String label;
  final String displayText;
  final Color color;
  final Duration delay;

  const _CircularProgressRing({
    required this.value,
    required this.label,
    required this.displayText,
    required this.color,
    this.delay = Duration.zero,
  });

  @override
  State<_CircularProgressRing> createState() => _CircularProgressRingState();
}

class _CircularProgressRingState extends State<_CircularProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fill;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fill = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _ctrl, curve: KawaiiCurves.soft),
    );
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KawaiiPressable(
      pressScale: 0.92,
      onTap: () => KawaiiSoundEngine().play(KawaiiSound.tick),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: AnimatedBuilder(
              animation: _fill,
              builder: (context, _) {
                return CustomPaint(
                  painter: _RingPainter(
                    progress: _fill.value,
                    color: widget.color,
                    bgColor:
                        widget.color.withValues(alpha: KawaiiOpacity.soft),
                    strokeWidth: 6,
                  ),
                  child: Center(
                    child: Text(
                      widget.displayText,
                      style:
                          kHeading(size: 14, color: widget.color),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.label.toUpperCase(),
            style: kBody(
              size: 10,
              weight: FontWeight.w800,
              color: KawaiiColors.muted,
            ).copyWith(letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color bgColor;
  final double strokeWidth;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.bgColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    final r = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);

    // Background ring
    canvas.drawArc(
      rect,
      0,
      2 * pi,
      false,
      Paint()
        ..color = bgColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    // Progress arc
    if (progress > 0) {
      canvas.drawArc(
        rect,
        -pi / 2,
        progress * 2 * pi,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  4. QUICK ACTION BUTTONS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: KawaiiButton.pink('Task', small: true,
            onTap: () {}),
        ),
        const SizedBox(width: KawaiiSpacing.md),
        Expanded(
          child: KawaiiButton.violet('Mood', small: true,
            onTap: () {}),
        ),
        const SizedBox(width: KawaiiSpacing.md),
        Expanded(
          child: KawaiiButton.green('Goal', small: true,
            onTap: () {}),
        ),
      ],
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  5. TODAY'S TASKS — swipeable cards with color accent stripe
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _TasksSection extends StatelessWidget {
  final List<TodoTask> tasks;
  final int totalIncomplete;
  final AppStore store;

  const _TasksSection({
    required this.tasks,
    required this.totalIncomplete,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: KawaiiSpacing.page),
          child: const SectionLabel("Today's Tasks"),
        ),
        if (tasks.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: KawaiiSpacing.page),
            child: KawaiiCard(
              padding: const EdgeInsets.all(KawaiiSpacing.xl),
              child: Row(
                children: [
                  kawaiiIcon(
                    Star4Painter(
                      fill: KawaiiColors.goldTop,
                      stroke: KawaiiColors.goldStroke,
                    ),
                    size: 20,
                  ),
                  const SizedBox(width: KawaiiSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'All done!',
                          style: kHeading(size: 14),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Enjoy your well-earned rest.',
                          style: kBody(
                            size: 12,
                            weight: FontWeight.w600,
                            color: KawaiiColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        else ...[
          // Build task cards lazily
          ...List.generate(tasks.length, (i) {
            final task = tasks[i];
            return Padding(
              padding: const EdgeInsets.only(
                left: KawaiiSpacing.page,
                right: KawaiiSpacing.page,
                bottom: KawaiiSpacing.md,
              ),
              child: _SwipeableTaskCard(
                task: task,
                onComplete: () => store.toggleTask(task.id),
              ),
            );
          }),
          if (totalIncomplete > tasks.length)
            Padding(
              padding: const EdgeInsets.only(
                right: KawaiiSpacing.page,
                top: KawaiiSpacing.sm,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: KawaiiButton.pink(
                  'See all $totalIncomplete tasks',
                  small: true,
                  onTap: () {},
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class _SwipeableTaskCard extends StatefulWidget {
  final TodoTask task;
  final VoidCallback onComplete;

  const _SwipeableTaskCard({
    required this.task,
    required this.onComplete,
  });

  @override
  State<_SwipeableTaskCard> createState() => _SwipeableTaskCardState();
}

class _SwipeableTaskCardState extends State<_SwipeableTaskCard> {
  bool _checked = false;

  void _handleCheck(bool val) {
    if (_checked) return;
    setState(() => _checked = true);
    KawaiiSoundEngine().play(KawaiiSound.boop);
    // Delay actual completion so the user sees the check + can undo
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted || !_checked) return;
      widget.onComplete();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${widget.task.title} done!',
          style: kBody(size: 13, color: Colors.white)),
        backgroundColor: KawaiiColors.greenBottom,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () => widget.onComplete(), // toggles back
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final cat = widget.task.category;

    return AnimatedOpacity(
      opacity: _checked ? 0.5 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: RepaintBoundary(
          child: Stack(
            children: [
              KawaiiSurface(
                gloss: GlossLevel.subtle,
                shineOpacity: 0.30,
                shineHeight: 0.38,
                padding: const EdgeInsets.fromLTRB(0, 0, 14, 0),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(KawaiiBorderRadius.lg),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xA6FFFFFF), Color(0x73FFF8FC)],
                  ),
                  border: Border.all(
                    color: KawaiiColors.cardBorder
                        .withValues(alpha: KawaiiOpacity.hint),
                    width: KawaiiBorderWidth.light,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: KawaiiColors.glass
                          .withValues(alpha: KawaiiOpacity.ghost),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Color accent stripe
                    Container(
                      width: 5,
                      height: 52,
                      decoration: BoxDecoration(
                        color: cat.color,
                        borderRadius: const BorderRadius.only(
                          topLeft:
                              Radius.circular(KawaiiBorderRadius.lg),
                          bottomLeft:
                              Radius.circular(KawaiiBorderRadius.lg),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Checkbox
                    KawaiiCheckbox(
                      value: _checked || widget.task.done,
                      color: cat.color,
                      onChanged: _handleCheck,
                    ),
                    const SizedBox(width: 10),
                    // Task info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.task.title,
                            style: kHeading(size: 12.5),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            cat.label,
                            style: kBody(
                              size: 10,
                              weight: FontWeight.w700,
                              color: cat.color,
                            ),
                          ),
                        ],
                      ),
                    ),
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
//  6. GOALS CAROUSEL — horizontal scrollable cards
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _GoalsCarousel extends StatelessWidget {
  final List<Goal> goals;
  final AppStore store;
  const _GoalsCarousel({required this.goals, required this.store});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: KawaiiSpacing.page),
          child: const SectionLabel('Active Goals'),
        ),
        if (goals.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: KawaiiSpacing.page),
            child: KawaiiCard(
              padding: const EdgeInsets.all(KawaiiSpacing.xl),
              child: Row(
                children: [
                  kawaiiIcon(
                    Star4Painter(
                      fill: KawaiiColors.violetTop,
                      stroke: KawaiiColors.violetStroke,
                    ),
                    size: 20,
                  ),
                  const SizedBox(width: KawaiiSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'No active goals yet',
                          style: kHeading(size: 14),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Set a goal to start tracking progress!',
                          style: kBody(
                            size: 12,
                            weight: FontWeight.w600,
                            color: KawaiiColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SizedBox(
            height: 175,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                  horizontal: KawaiiSpacing.page),
              itemCount: goals.length,
              itemBuilder: (context, i) {
                final goal = goals[i];
                return Padding(
                  padding: EdgeInsets.only(
                    right: i < goals.length - 1
                        ? KawaiiSpacing.lg
                        : 0,
                  ),
                  child: _GoalCard(goal: goal, store: store),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _GoalCard extends StatefulWidget {
  final Goal goal;
  final AppStore store;
  const _GoalCard({required this.goal, required this.store});

  @override
  State<_GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<_GoalCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fill;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fill = Tween<double>(begin: 0, end: widget.goal.progress)
        .animate(CurvedAnimation(
      parent: _ctrl,
      curve: KawaiiCurves.soft,
    ));
    // Slight delay before animating in
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  static const _motivations = [
    'Keep going!',
    'Almost there!',
    'You can do it!',
    'Stay focused!',
    'Great progress!',
  ];

  @override
  Widget build(BuildContext context) {
    final goal = widget.goal;
    final pctInt = (goal.progress * 100).toInt();
    // Deterministic motivational text per goal
    final motiv = _motivations[goal.title.length % _motivations.length];

    return KawaiiPressable(
      pressScale: 0.96,
      onTap: () {
        KawaiiSoundEngine().play(KawaiiSound.boop);
        widget.store.incrementGoal(goal.id);
      },
      child: SizedBox(
        width: 160,
        child: KawaiiCard(
          padding: const EdgeInsets.all(KawaiiSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular progress ring
              SizedBox(
                width: 68,
                height: 68,
                child: AnimatedBuilder(
                  animation: _fill,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: _RingPainter(
                        progress: _fill.value,
                        color: goal.color,
                        bgColor: goal.color
                            .withValues(alpha: KawaiiOpacity.soft),
                        strokeWidth: 6,
                      ),
                      child: Center(
                        child: Text(
                          '$pctInt%',
                          style: kHeading(
                            size: 15,
                            color: goal.color,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: KawaiiSpacing.md),
              Text(
                goal.title,
                style: kHeading(size: 12),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                '${goal.current}/${goal.target}',
                style: kBody(
                  size: 10,
                  weight: FontWeight.w700,
                  color: goal.color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                motiv,
                style: kBody(
                  size: 9,
                  weight: FontWeight.w600,
                  color: KawaiiColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kawaii_ui/kawaii_ui.dart';
import '../models/models.dart';
import '../models/store.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  GOALS SCREEN — award-winning circular progress rings
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class GoalsScreen extends StatelessWidget {
  final AppStore store;
  const GoalsScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final goals = store.goals;
        return ListView(
          padding: const EdgeInsets.all(KawaiiSpacing.xl),
          children: [
            // ── Summary stats ──
            KawaiiEntrance(
              child: _SummaryStats(goals: goals),
            ),
            const SizedBox(height: KawaiiSpacing.xxl),

            // ── Add goal button ──
            KawaiiEntrance(
              delay: const Duration(milliseconds: 60),
              child: Center(
                child: KawaiiButton.pink(
                  '+ New Goal',
                  hero: true,
                  i: const Icon(Icons.flag_rounded, size: 18, color: Color(0xFF6D2042)),
                  onTap: () => _showAddDialog(context),
                ),
              ),
            ),
            const SizedBox(height: KawaiiSpacing.xxl),

            // ── Empty state ──
            if (goals.isEmpty)
              KawaiiEntrance(
                delay: const Duration(milliseconds: 120),
                child: const _EmptyState(),
              ),

            // ── Goal cards ──
            for (int i = 0; i < goals.length; i++)
              KawaiiEntrance(
                delay: Duration(milliseconds: 120 + 80 * i),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: KawaiiSpacing.lg),
                  child: Dismissible(
                    key: ValueKey(goals[i].id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: KawaiiSpacing.xxl),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(KawaiiBorderRadius.card),
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            const Color(0xFFF06292).withValues(alpha: 0.08),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.delete_rounded, color: KawaiiColors.muted, size: 24),
                          const SizedBox(height: 2),
                          Text('Delete', style: kBody(size: 10, color: KawaiiColors.muted)),
                        ],
                      ),
                    ),
                    confirmDismiss: (_) => _confirmDelete(context, goals[i].title),
                    onDismissed: (_) => store.deleteGoal(goals[i].id),
                    child: _GoalCard(goal: goals[i], store: store),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, String title) {
    return showKawaiiDialog<bool>(
      context: context,
      title: 'Delete Goal?',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.sentiment_dissatisfied_rounded, size: 36, color: KawaiiColors.muted),
          const SizedBox(height: KawaiiSpacing.md),
          Text(
            'Are you sure you want to remove "$title"?\nThis cannot be undone.',
            textAlign: TextAlign.center,
            style: kBody(color: KawaiiColors.body),
          ),
        ],
      ),
      actions: [
        KawaiiButton.pink('Keep it', small: true, onTap: () => Navigator.pop(context, false)),
        KawaiiButton.violet('Delete', small: true, onTap: () => Navigator.pop(context, true)),
      ],
    );
  }

  void _showAddDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final targetCtrl = TextEditingController();
    Color selected = const Color(0xFFF06292);

    const colors = <Color>[
      Color(0xFFF06292),
      Color(0xFF7C4DFF),
      Color(0xFF66BB6A),
      Color(0xFFFFB74D),
      Color(0xFF42A5F5),
    ];

    showKawaiiDialog(
      context: context,
      title: 'New Goal',
      content: StatefulBuilder(
        builder: (ctx, setState) {
          final titleText = titleCtrl.text.trim();
          final targetVal = int.tryParse(targetCtrl.text.trim()) ?? 0;
          final hasPreview = titleText.isNotEmpty && targetVal > 0;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Title input ──
              _kawaiiTextField(titleCtrl, 'Goal title (e.g. Read 12 books)', onChanged: (_) => setState(() {})),
              const SizedBox(height: KawaiiSpacing.lg),

              // ── Target input ──
              _kawaiiTextField(targetCtrl, 'Target number', keyboard: TextInputType.number, onChanged: (_) => setState(() {})),
              const SizedBox(height: KawaiiSpacing.xl),

              // ── Color picker ──
              Text('Pick a color', style: kBody(size: 11, weight: FontWeight.w800, color: KawaiiColors.muted)),
              const SizedBox(height: KawaiiSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final c in colors) ...[
                    GestureDetector(
                      onTap: () => setState(() => selected = c),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: KawaiiCurves.spring,
                        width: selected == c ? 38 : 32,
                        height: selected == c ? 38 : 32,
                        child: KawaiiBadge(
                          size: selected == c ? 38 : 32,
                          bg: c,
                          border: selected == c ? KawaiiColors.heading : c.withValues(alpha: 0.4),
                          interactive: false,
                          child: selected == c
                              ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                    if (c != colors.last) const SizedBox(width: KawaiiSpacing.md),
                  ],
                ],
              ),

              // ── Live preview ──
              if (hasPreview) ...[
                const SizedBox(height: KawaiiSpacing.xl),
                Text('Preview', style: kBody(size: 11, weight: FontWeight.w800, color: KawaiiColors.muted)),
                const SizedBox(height: KawaiiSpacing.md),
                _GoalPreviewCard(
                  title: titleText,
                  target: targetVal,
                  color: selected,
                ),
              ],
            ],
          );
        },
      ),
      actions: [
        KawaiiButton.pink('Cancel', small: true, onTap: () => Navigator.pop(context)),
        KawaiiButton.green('Create Goal', small: true, onTap: () {
          final title = titleCtrl.text.trim();
          final target = int.tryParse(targetCtrl.text.trim()) ?? 0;
          if (title.isNotEmpty && target > 0) {
            store.addGoal(title, target, selected);
            Navigator.pop(context);
            showKawaiiSnackbar(
              context: context,
              message: 'New goal created! You got this!',
              type: KawaiiSnackbarType.info,
            );
          }
        }),
      ],
    );
  }

  Widget _kawaiiTextField(
    TextEditingController ctrl,
    String hint, {
    TextInputType? keyboard,
    ValueChanged<String>? onChanged,
  }) {
    return KawaiiSurface(
      gloss: GlossLevel.subtle,
      shineOpacity: 0.20,
      shineHeight: 0.36,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(KawaiiBorderRadius.lg),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xBFFFFFFF), Color(0x8CFFF8FC)],
        ),
        border: Border.all(color: KawaiiColors.cardBorder, width: KawaiiBorderWidth.medium),
        boxShadow: [KawaiiShadows.medium(KawaiiColors.cardBorder)],
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboard,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: kBody(size: 13, color: KawaiiColors.subtle),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
        style: kBody(size: 13, color: KawaiiColors.heading),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  SUMMARY STATS BAR
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _SummaryStats extends StatelessWidget {
  final List<Goal> goals;
  const _SummaryStats({required this.goals});

  @override
  Widget build(BuildContext context) {
    final total = goals.length;
    final completed = goals.where((g) => g.completed).length;
    final overallProgress = total > 0
        ? goals.fold<double>(0, (sum, g) => sum + g.progress) / total
        : 0.0;

    return KawaiiCard(
      padding: const EdgeInsets.all(KawaiiSpacing.xl),
      child: Column(
        children: [
          Row(
            children: [
              const Star4Icon(size: 12),
              const SizedBox(width: KawaiiSpacing.md),
              Text('Goal Progress', style: kHeading(size: 14)),
              const Spacer(),
              Text(
                '${(overallProgress * 100).toInt()}%',
                style: kHeading(size: 18, color: KawaiiColors.pinkBottom),
              ),
            ],
          ),
          const SizedBox(height: KawaiiSpacing.lg),

          // Mini overall progress bar
          KawaiiProgress(
            color: KawaiiColors.pinkBottom,
            pct: overallProgress * 100,
            label: '',
          ),
          const SizedBox(height: KawaiiSpacing.lg),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatPill(
                label: 'Total',
                value: '$total',
                color: KawaiiColors.blueBottom,
              ),
              _StatPill(
                label: 'Done',
                value: '$completed',
                color: KawaiiColors.greenBottom,
              ),
              _StatPill(
                label: 'Active',
                value: '${total - completed}',
                color: KawaiiColors.violetBottom,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatPill({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return KawaiiSurface(
      gloss: GlossLevel.subtle,
      shineOpacity: 0.20,
      shineHeight: 0.36,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(KawaiiBorderRadius.md),
        color: color.withValues(alpha: KawaiiOpacity.whisper),
        border: Border.all(color: color.withValues(alpha: KawaiiOpacity.hint), width: KawaiiBorderWidth.light),
      ),
      child: Column(
        children: [
          Text(value, style: kHeading(size: 16, color: color)),
          Text(label, style: kBody(size: 10, weight: FontWeight.w800, color: KawaiiColors.muted)),
        ],
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  EMPTY STATE
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return KawaiiCard(
      padding: const EdgeInsets.symmetric(horizontal: KawaiiSpacing.xxl, vertical: KawaiiSpacing.huge),
      child: Column(
        children: [
          const Icon(Icons.flag_rounded, size: 48, color: KawaiiColors.subtle),
          const SizedBox(height: KawaiiSpacing.lg),
          Text('No goals yet!', style: kHeading(size: 16)),
          const SizedBox(height: KawaiiSpacing.md),
          Text(
            'Set a goal to start tracking your progress.\nEvery big achievement starts with one small step.',
            textAlign: TextAlign.center,
            style: kBody(size: 12, color: KawaiiColors.muted),
          ),
          const SizedBox(height: KawaiiSpacing.lg),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Star4Icon(size: 10),
              const SizedBox(width: KawaiiSpacing.sm),
              Text('Tap "+ New Goal" to begin', style: kBody(size: 11, weight: FontWeight.w800, color: KawaiiColors.pinkBottom)),
              const SizedBox(width: KawaiiSpacing.sm),
              const Star4Icon(size: 10),
            ],
          ),
        ],
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  GOAL RING PAINTER — circular progress arc
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _GoalRingPainter extends CustomPainter {
  final double progress; // 0.0 – 1.0
  final Color color;
  final double strokeWidth;
  final Color trackColor;
  final double glowRadius;

  _GoalRingPainter({
    required this.progress,
    required this.color,
    this.strokeWidth = 6.0,
    this.trackColor = const Color(0x1AC8A0B4),
    this.glowRadius = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Track (background circle)
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

    // Optional glow behind the progress arc
    if (glowRadius > 0) {
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + glowRadius
        ..strokeCap = StrokeCap.round
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowRadius);
      canvas.drawArc(
        rect,
        -pi / 2,
        2 * pi * progress.clamp(0.0, 1.0),
        false,
        glowPaint,
      );
    }

    // Progress arc with gradient
    final sweepAngle = 2 * pi * progress.clamp(0.0, 1.0);
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: -pi / 2,
        endAngle: -pi / 2 + sweepAngle,
        colors: [
          color.withValues(alpha: 0.7),
          color,
          Color.lerp(color, Colors.white, 0.25)!,
        ],
        stops: const [0.0, 0.6, 1.0],
        transform: const GradientRotation(-pi / 2),
      ).createShader(rect);
    canvas.drawArc(rect, -pi / 2, sweepAngle, false, progressPaint);

    // Bright dot at the tip of the arc
    if (progress > 0.02) {
      final tipAngle = -pi / 2 + sweepAngle;
      final tipX = center.dx + radius * cos(tipAngle);
      final tipY = center.dy + radius * sin(tipAngle);
      final tipPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.85)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawCircle(Offset(tipX, tipY), strokeWidth * 0.35, tipPaint);
    }
  }

  @override
  bool shouldRepaint(_GoalRingPainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.glowRadius != glowRadius;
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  ANIMATED GOAL RING — wraps the painter with entrance animation
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _AnimatedGoalRing extends StatefulWidget {
  final double progress;
  final Color color;
  final double size;
  final bool completed;

  const _AnimatedGoalRing({
    required this.progress,
    required this.color,
    this.size = 60,
    this.completed = false,
  });

  @override
  State<_AnimatedGoalRing> createState() => _AnimatedGoalRingState();
}

class _AnimatedGoalRingState extends State<_AnimatedGoalRing>
    with TickerProviderStateMixin {
  late AnimationController _fillCtrl;
  late Animation<double> _fillAnim;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();

    // Fill animation — sweeps from 0 to target progress
    _fillCtrl = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _fillAnim = Tween<double>(begin: 0, end: widget.progress).animate(
      CurvedAnimation(parent: _fillCtrl, curve: KawaiiCurves.soft),
    );

    // Pulse animation for completed goals
    _pulseCtrl = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _glowAnim = Tween<double>(begin: 0.0, end: 5.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    // Kick off fill
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _fillCtrl.forward();
    });

    if (widget.completed) {
      _pulseCtrl.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_AnimatedGoalRing old) {
    super.didUpdateWidget(old);

    if (old.progress != widget.progress) {
      _fillAnim = Tween<double>(begin: _fillAnim.value, end: widget.progress).animate(
        CurvedAnimation(parent: _fillCtrl, curve: KawaiiCurves.soft),
      );
      _fillCtrl.forward(from: 0);
    }

    if (widget.completed && !old.completed) {
      _pulseCtrl.repeat(reverse: true);
    } else if (!widget.completed && old.completed) {
      _pulseCtrl.stop();
      _pulseCtrl.value = 0;
    }
  }

  @override
  void dispose() {
    _fillCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_fillCtrl, _pulseCtrl]),
      builder: (context, child) {
        final scale = widget.completed ? _pulseAnim.value : 1.0;
        final glow = widget.completed ? _glowAnim.value : 0.0;

        return Transform.scale(
          scale: scale,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Ring
                CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _GoalRingPainter(
                    progress: _fillAnim.value,
                    color: widget.color,
                    strokeWidth: 5.5,
                    glowRadius: glow,
                  ),
                ),
                // Percentage text in center
                Text(
                  '${(_fillAnim.value * 100).toInt()}%',
                  style: kHeading(
                    size: widget.size > 50 ? 13 : 11,
                    color: widget.completed
                        ? widget.color
                        : KawaiiColors.heading,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  GOLDEN SHIMMER OVERLAY — for completed goals
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _GoldenShimmer extends StatefulWidget {
  const _GoldenShimmer();

  @override
  State<_GoldenShimmer> createState() => _GoldenShimmerState();
}

class _GoldenShimmerState extends State<_GoldenShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(KawaiiBorderRadius.card),
              gradient: LinearGradient(
                begin: Alignment(-2.0 + 4.0 * _ctrl.value, -0.5),
                end: Alignment(-1.0 + 4.0 * _ctrl.value, 0.5),
                colors: const [
                  Color(0x00FFD54F),
                  Color(0x12FFD54F),
                  Color(0x08FFE082),
                  Color(0x00FFD54F),
                ],
                stops: const [0.0, 0.4, 0.6, 1.0],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  COMPLETED TAG WITH SPRING ANIMATION
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _CompletedTag extends StatefulWidget {
  const _CompletedTag();

  @override
  State<_CompletedTag> createState() => _CompletedTagState();
}

class _CompletedTagState extends State<_CompletedTag>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: KawaiiCurves.spring),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Star4Icon(size: 10),
          const SizedBox(width: 3),
          KawaiiTag('Completed!', color: KawaiiColors.greenBottom, interactive: false),
          const SizedBox(width: 3),
          const Star4Icon(size: 10),
        ],
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  GOAL CARD — main card widget with ring + actions
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _GoalCard extends StatelessWidget {
  final Goal goal;
  final AppStore store;
  const _GoalCard({required this.goal, required this.store});

  @override
  Widget build(BuildContext context) {
    return KawaiiCard(
      child: Stack(
        children: [
          // Golden shimmer for completed goals
          if (goal.completed)
            Positioned.fill(child: const _GoldenShimmer()),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── Circular progress ring ──
                  _AnimatedGoalRing(
                    progress: goal.progress,
                    color: goal.color,
                    size: 60,
                    completed: goal.completed,
                  ),

                  const SizedBox(width: KawaiiSpacing.xl),

                  // ── Title + progress text ──
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.title,
                          style: kHeading(size: 15),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: KawaiiSpacing.sm),
                        Row(
                          children: [
                            // Current / target badge
                            KawaiiSurface(
                              gloss: GlossLevel.subtle,
                              shineOpacity: 0.18,
                              shineHeight: 0.36,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(KawaiiBorderRadius.xs),
                                color: goal.color.withValues(alpha: KawaiiOpacity.whisper),
                                border: Border.all(
                                  color: goal.color.withValues(alpha: KawaiiOpacity.hint),
                                  width: KawaiiBorderWidth.thin,
                                ),
                              ),
                              child: Text(
                                '${goal.current} / ${goal.target}',
                                style: kBody(
                                  size: 11,
                                  weight: FontWeight.w800,
                                  color: goal.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: KawaiiSpacing.lg),

              // ── Action buttons + completed tag ──
              Row(
                children: [
                  KawaiiButton(
                    label: '+1',
                    colors: _btnColors(goal.color),
                    small: true,
                    onTap: goal.completed ? null : () => _increment(context, goal.id, 1),
                  ),
                  const SizedBox(width: KawaiiSpacing.md),
                  KawaiiButton(
                    label: '+5',
                    colors: _btnColors(goal.color),
                    small: true,
                    onTap: goal.completed ? null : () => _increment(context, goal.id, 5),
                  ),
                  const Spacer(),
                  if (goal.completed) const _CompletedTag(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _increment(BuildContext context, String id, int amount) {
    final wasCompleted = goal.completed;
    store.incrementGoal(id, amount);
    if (!wasCompleted) {
      final updated = store.goals.where((g) => g.id == id).firstOrNull;
      if (updated != null && updated.completed) {
        showKawaiiSnackbar(
          context: context,
          message: 'Goal achieved! You are amazing!',
          type: KawaiiSnackbarType.success,
        );
      }
    }
  }

  KawaiiButtonColors _btnColors(Color c) => KawaiiButtonColors(
        top: c.withValues(alpha: 0.7),
        bottom: c,
        stroke: c.withValues(alpha: 0.85),
        text: Colors.white,
        shadow: c.withValues(alpha: 0.3),
      );
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  GOAL PREVIEW CARD — shown in the add dialog
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _GoalPreviewCard extends StatelessWidget {
  final String title;
  final int target;
  final Color color;

  const _GoalPreviewCard({
    required this.title,
    required this.target,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: KawaiiCurves.soft,
      padding: const EdgeInsets.all(KawaiiSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(KawaiiBorderRadius.lg),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: 0.06),
            color.withValues(alpha: 0.02),
          ],
        ),
        border: Border.all(
          color: color.withValues(alpha: KawaiiOpacity.hint),
          width: KawaiiBorderWidth.light,
        ),
      ),
      child: Row(
        children: [
          // Mini ring preview
          SizedBox(
            width: 40,
            height: 40,
            child: CustomPaint(
              painter: _GoalRingPainter(
                progress: 0.0,
                color: color,
                strokeWidth: 4,
              ),
              child: Center(
                child: Text('0%', style: kBody(size: 9, weight: FontWeight.w800, color: KawaiiColors.muted)),
              ),
            ),
          ),
          const SizedBox(width: KawaiiSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: kHeading(size: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '0 / $target',
                  style: kBody(size: 11, color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

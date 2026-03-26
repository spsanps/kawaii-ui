import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kawaii_ui/kawaii_ui.dart';
import '../models/models.dart';
import '../models/store.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  MOOD FACE PAINTERS (duplicated locally from mood_screen.dart
//  to keep each screen self-contained)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _HappyFacePainter extends CustomPainter {
  final Color color;
  _HappyFacePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08..strokeCap = StrokeCap.round;
    final cx = size.width / 2, cy = size.height / 2, r = size.width * 0.38;
    final eyeY = cy - r * 0.22, eyeSpread = r * 0.48, eyeR = r * 0.22;
    canvas.drawArc(Rect.fromCenter(center: Offset(cx - eyeSpread, eyeY),
        width: eyeR * 2, height: eyeR * 1.6), pi + 0.3, pi - 0.6, false, paint);
    canvas.drawArc(Rect.fromCenter(center: Offset(cx + eyeSpread, eyeY),
        width: eyeR * 2, height: eyeR * 1.6), pi + 0.3, pi - 0.6, false, paint);
    canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy + r * 0.18),
        width: r * 1.6, height: r * 1.1), 0.15, pi - 0.3, false, paint);
  }
  @override
  bool shouldRepaint(_HappyFacePainter old) => old.color != color;
}

class _CalmFacePainter extends CustomPainter {
  final Color color;
  _CalmFacePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08..strokeCap = StrokeCap.round;
    final cx = size.width / 2, cy = size.height / 2, r = size.width * 0.38;
    final eyeY = cy - r * 0.15, eyeSpread = r * 0.48, eyeR = r * 0.2;
    canvas.drawArc(Rect.fromCenter(center: Offset(cx - eyeSpread, eyeY),
        width: eyeR * 2, height: eyeR), 0.2, pi - 0.4, false, paint);
    canvas.drawArc(Rect.fromCenter(center: Offset(cx + eyeSpread, eyeY),
        width: eyeR * 2, height: eyeR), 0.2, pi - 0.4, false, paint);
    canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy + r * 0.3),
        width: r * 1.0, height: r * 0.6), 0.2, pi - 0.4, false, paint);
  }
  @override
  bool shouldRepaint(_CalmFacePainter old) => old.color != color;
}

class _NeutralFacePainter extends CustomPainter {
  final Color color;
  _NeutralFacePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08..strokeCap = StrokeCap.round;
    final cx = size.width / 2, cy = size.height / 2, r = size.width * 0.38;
    final eyeR = r * 0.08;
    canvas.drawCircle(Offset(cx - r * 0.4, cy - r * 0.15), eyeR, Paint()..color = color);
    canvas.drawCircle(Offset(cx + r * 0.4, cy - r * 0.15), eyeR, Paint()..color = color);
    canvas.drawLine(Offset(cx - r * 0.35, cy + r * 0.3),
        Offset(cx + r * 0.35, cy + r * 0.3), paint);
  }
  @override
  bool shouldRepaint(_NeutralFacePainter old) => old.color != color;
}

class _AnxiousFacePainter extends CustomPainter {
  final Color color;
  _AnxiousFacePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08..strokeCap = StrokeCap.round;
    final cx = size.width / 2, cy = size.height / 2, r = size.width * 0.38;
    final eyeR = r * 0.1;
    canvas.drawCircle(Offset(cx - r * 0.4, cy - r * 0.15), eyeR, Paint()..color = color);
    canvas.drawCircle(Offset(cx + r * 0.4, cy - r * 0.15), eyeR, Paint()..color = color);
    final path = Path()
      ..moveTo(cx - r * 0.35, cy + r * 0.35)
      ..quadraticBezierTo(cx, cy + r * 0.15, cx + r * 0.35, cy + r * 0.35);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(_AnxiousFacePainter old) => old.color != color;
}

class _SadFacePainter extends CustomPainter {
  final Color color;
  _SadFacePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08..strokeCap = StrokeCap.round;
    final cx = size.width / 2, cy = size.height / 2, r = size.width * 0.38;
    final eyeY = cy - r * 0.1, eyeSpread = r * 0.45, eyeR = r * 0.2;
    canvas.drawArc(Rect.fromCenter(center: Offset(cx - eyeSpread, eyeY),
        width: eyeR * 2, height: eyeR * 1.2), 0.3, pi - 0.6, false, paint);
    canvas.drawArc(Rect.fromCenter(center: Offset(cx + eyeSpread, eyeY),
        width: eyeR * 2, height: eyeR * 1.2), 0.3, pi - 0.6, false, paint);
    canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy + r * 0.52),
        width: r * 1.16, height: r * 0.8), pi + 0.2, pi - 0.4, false, paint);
  }
  @override
  bool shouldRepaint(_SadFacePainter old) => old.color != color;
}

CustomPainter _facePainterFor(Mood mood, Color color) => switch (mood) {
  Mood.happy   => _HappyFacePainter(color: color),
  Mood.calm    => _CalmFacePainter(color: color),
  Mood.neutral => _NeutralFacePainter(color: color),
  Mood.anxious => _AnxiousFacePainter(color: color),
  Mood.sad     => _SadFacePainter(color: color),
};

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  WARM CREAM COLORS — diary-specific palette
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _DiaryColors {
  _DiaryColors._();
  static const creamTop    = Color(0xFFFFFDF5);
  static const creamBottom = Color(0xFFFFF8EC);
  static const creamBorder = Color(0xFFE8D8C4);
  static const warmBrown   = Color(0xFF5C4033);
  static const softBrown   = Color(0xFF8B7262);
  static const mutedBrown  = Color(0xFFA89282);
  static const penOrange   = Color(0xFFFF8A65);
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  DIARY SCREEN
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class DiaryScreen extends StatefulWidget {
  final AppStore store;
  const DiaryScreen({super.key, required this.store});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final _textCtrl = TextEditingController();
  bool _hasLoadedToday = false;

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  // ── Date formatting helpers ──

  static const _weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  static const _months = ['January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'];

  String _formatDate(DateTime date) {
    final weekday = _weekdays[date.weekday - 1];
    final month = _months[date.month - 1];
    return '$weekday, $month ${date.day}';
  }

  String _timeAgo(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return '$diff days ago';
    if (diff < 30) return '${(diff / 7).floor()} weeks ago';
    return '${(diff / 30).floor()} months ago';
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.day == b.day && a.month == b.month && a.year == b.year;

  void _saveDiary() {
    final text = _textCtrl.text.trim();
    if (text.isEmpty) return;
    widget.store.saveDiary(text, DateTime.now());
    showKawaiiSnackbar(
      context: context,
      message: 'Diary entry saved!',
      type: KawaiiSnackbarType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.store,
      builder: (context, _) {
        final now = DateTime.now();
        final todayEntry = widget.store.getDiaryForDate(now);
        final todayMood = widget.store.todaysMood;

        // Pre-fill the text controller with today's existing entry
        if (!_hasLoadedToday && todayEntry != null) {
          _textCtrl.text = todayEntry.text;
          _hasLoadedToday = true;
        } else if (!_hasLoadedToday) {
          _hasLoadedToday = true;
        }

        // Past entries: all entries except today, reverse chronological
        final pastEntries = widget.store.diaryEntries
            .where((e) => !_isSameDay(e.date, now))
            .toList();

        return KawaiiListView(
          staggerEntrance: true,
          staggerDelay: const Duration(milliseconds: 80),
          header: [
            // ── Header ──
            _buildHeader(),
            const SizedBox(height: KawaiiSpacing.xxl),

            // ── Today's Entry ──
            _buildTodayCard(todayEntry, todayMood),
            const SizedBox(height: KawaiiSpacing.sectionGap + 8),

            // ── Past Entries Label ──
            if (pastEntries.isNotEmpty)
              const SectionLabel('Past Entries'),
          ],
          itemCount: pastEntries.isEmpty ? 1 : pastEntries.length,
          itemBuilder: (context, index) {
            if (pastEntries.isEmpty) {
              return _buildEmptyState();
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: KawaiiSpacing.lg),
              child: _buildPastEntryCard(pastEntries[index]),
            );
          },
        );
      },
    );
  }

  // ━━━ HEADER ━━━
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: KawaiiSpacing.sm),
      child: Row(
        children: [
          kawaiiIcon(const PenPainter(stroke: _DiaryColors.penOrange), size: 24),
          const SizedBox(width: KawaiiSpacing.md),
          Text('My Diary', style: kHeading(size: 22, color: _DiaryColors.warmBrown)),
          const SizedBox(width: KawaiiSpacing.md),
          const SparkleWidget(
            size: 16,
            fill: Color(0xFFFFE0B2),
            stroke: Color(0xFFFF8A65),
          ),
        ],
      ),
    );
  }

  // ━━━ TODAY'S ENTRY CARD ━━━
  Widget _buildTodayCard(DiaryEntry? todayEntry, MoodEntry? todayMood) {
    return _WarmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date row with optional mood badge
          Row(
            children: [
              Expanded(
                child: Text(
                  _formatDate(DateTime.now()),
                  style: kHeading(size: 16, color: _DiaryColors.warmBrown),
                ),
              ),
              if (todayMood != null)
                _MoodBadge(mood: todayMood.mood),
            ],
          ),
          const SizedBox(height: KawaiiSpacing.xl),

          // Text field
          KawaiiTextField(
            placeholder: 'Dear diary...',
            controller: _textCtrl,
            maxLines: 6,
            color: _DiaryColors.creamBorder,
          ),

          const SizedBox(height: KawaiiSpacing.xl),

          // Save button
          Center(
            child: KawaiiButton.pink(
              todayEntry != null ? 'Update' : 'Save',
              hero: true,
              i: Icon(
                todayEntry != null ? Icons.edit_rounded : Icons.bookmark_rounded,
                size: 18,
                color: KawaiiColors.pinkText,
              ),
              onTap: _saveDiary,
            ),
          ),
        ],
      ),
    );
  }

  // ━━━ PAST ENTRY CARD ━━━
  Widget _buildPastEntryCard(DiaryEntry entry) {
    // Find linked mood
    MoodEntry? linkedMood;
    if (entry.linkedMoodId != null) {
      linkedMood = widget.store.getMoodById(entry.linkedMoodId!);
    }
    linkedMood ??= widget.store.getMoodForDate(entry.date);

    // Find feelings for the day
    final dayMood = widget.store.getMoodForDate(entry.date);
    final feelings = dayMood?.feelings ?? [];

    return _WarmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date row with mood badge
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(entry.date),
                      style: kHeading(size: 15, color: _DiaryColors.warmBrown),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _timeAgo(entry.date),
                      style: kBody(size: 11, weight: FontWeight.w600, color: _DiaryColors.mutedBrown),
                    ),
                  ],
                ),
              ),
              if (linkedMood != null)
                _MoodBadge(mood: linkedMood.mood),
            ],
          ),
          const SizedBox(height: KawaiiSpacing.lg),

          // Diary text
          Text(
            entry.text,
            style: kBody(
              size: 14,
              weight: FontWeight.w600,
              color: _DiaryColors.softBrown,
            ).copyWith(height: 1.8),
          ),

          // Feeling tags
          if (feelings.isNotEmpty) ...[
            const SizedBox(height: KawaiiSpacing.lg),
            Wrap(
              spacing: KawaiiSpacing.wrapSpacing,
              runSpacing: KawaiiSpacing.wrapRunSpacing,
              children: feelings.map((f) => KawaiiTag(
                f.label,
                color: f.color,
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // ━━━ EMPTY STATE ━━━
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: KawaiiSpacing.huge),
      child: Center(
        child: Column(
          children: [
            kawaiiIcon(
              const PenPainter(stroke: _DiaryColors.mutedBrown),
              size: 48,
            ),
            const SizedBox(height: KawaiiSpacing.xl),
            Text(
              'Your story starts here...',
              style: kHeading(size: 16, color: _DiaryColors.softBrown),
            ),
            const SizedBox(height: KawaiiSpacing.md),
            Text(
              'Every day is worth remembering.',
              style: kBody(size: 13, weight: FontWeight.w600, color: _DiaryColors.mutedBrown),
            ),
          ],
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  WARM CARD — cream-tinted variant of KawaiiCard
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _WarmCard extends StatelessWidget {
  final Widget child;
  const _WarmCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_DiaryColors.creamTop, _DiaryColors.creamBottom],
          ),
          borderRadius: BorderRadius.circular(KawaiiBorderRadius.card),
          border: Border.all(
            color: _DiaryColors.creamBorder,
            width: KawaiiBorderWidth.thick,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14A08060),
              blurRadius: 20,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Inner bevel
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(KawaiiBorderRadius.xl),
                    border: Border.all(
                      color: const Color(0x66FFFFFF),
                      width: KawaiiBorderWidth.thin,
                    ),
                  ),
                ),
              ),
            ),
            // Corner sparkles
            for (final pos in [
              const Alignment(-0.92, -0.92),
              const Alignment(0.92, -0.92),
              const Alignment(-0.92, 0.92),
              const Alignment(0.92, 0.92),
            ])
              Align(
                alignment: pos,
                child: IgnorePointer(
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Opacity(
                      opacity: KawaiiOpacity.decorative,
                      child: const Star4Icon(
                        size: 6,
                        fill: Color(0xFFFFE0B2),
                        stroke: Color(0xFFDEB887),
                      ),
                    ),
                  ),
                ),
              ),
            // Content
            Padding(
              padding: const EdgeInsets.all(KawaiiSpacing.cardPad + 4),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  MOOD BADGE — small inline mood indicator
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _MoodBadge extends StatelessWidget {
  final Mood mood;
  const _MoodBadge({required this.mood});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [mood.accent, mood.color.withValues(alpha: 0.7)],
        ),
        border: Border.all(
          color: mood.color.withValues(alpha: 0.5),
          width: KawaiiBorderWidth.medium,
        ),
        boxShadow: [KawaiiShadows.soft(mood.color)],
      ),
      child: Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CustomPaint(
            painter: _facePainterFor(mood, Colors.white),
          ),
        ),
      ),
    );
  }
}

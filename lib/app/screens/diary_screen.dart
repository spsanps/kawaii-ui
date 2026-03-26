import 'package:flutter/material.dart';
import 'package:kawaii_ui/kawaii_ui.dart';
import '../models/models.dart';
import '../models/store.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  DIARY — full-page experience. Swipe between days like pages.
//  Feels like opening a real diary book.
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _C {
  static const bg = Color(0xFFFFF8F0);
  static const bgBottom = Color(0xFFFFF0E8);
  static const line = Color(0x18C8A090);
  static const text = Color(0xFF5D3A2E);
  static const muted = Color(0xFF9D7060);
  static const accent = Color(0xFFD4940C);
}

void openDiary(BuildContext context, AppStore store) {
  Navigator.of(context).push(PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 150),
    reverseTransitionDuration: const Duration(milliseconds: 100),
    pageBuilder: (ctx, anim, _) => _DiaryPage(store: store),
    transitionsBuilder: (ctx, anim, _, child) => FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.04), end: Offset.zero)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
        child: child)),
  ));
}

class _DiaryPage extends StatefulWidget {
  final AppStore store;
  const _DiaryPage({required this.store});
  @override
  State<_DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<_DiaryPage> {
  late PageController _pageCtrl;
  late List<DateTime> _dates;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dates = List.generate(31, (i) =>
      DateTime(now.year, now.month, now.day).subtract(Duration(days: 30 - i)));
    _current = _dates.length - 1;
    _pageCtrl = PageController(initialPage: _current);
  }

  @override
  void dispose() { _pageCtrl.dispose(); super.dispose(); }

  String _fmt(DateTime d) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = ['January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'];
    return '${days[d.weekday - 1]}, ${months[d.month - 1]} ${d.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [_C.bg, _C.bgBottom])),
        child: SafeArea(child: Column(children: [
          // ── Top bar ──
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
            child: Row(children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded, color: _C.text)),
              const Spacer(),
              kawaiiIcon(const PenPainter(stroke: _C.accent), size: 16),
              const SizedBox(width: 6),
              Text('My Diary', style: kHeading(size: 18, color: _C.text)),
              const Spacer(),
              const SizedBox(width: 48),
            ]),
          ),

          // ── Date ──
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(_fmt(_dates[_current]),
              style: kBody(size: 13, weight: FontWeight.w800, color: _C.muted)),
          ),

          // ── Pages ──
          Expanded(child: PageView.builder(
            controller: _pageCtrl,
            itemCount: _dates.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (ctx, i) => _Page(date: _dates[i], store: widget.store),
          )),

          // ── Footer ──
          Padding(
            padding: const EdgeInsets.only(bottom: 12, top: 4),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('← swipe →', style: kBody(size: 10, color: _C.muted.withValues(alpha: 0.5))),
              if (_current < _dates.length - 1) ...[
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => _pageCtrl.animateToPage(_dates.length - 1,
                    duration: const Duration(milliseconds: 300), curve: Curves.easeOut),
                  child: Text('Today →', style: kBody(size: 11, weight: FontWeight.w800, color: _C.accent)),
                ),
              ],
            ]),
          ),
        ])),
      ),
    );
  }
}

// ━━━ One diary page ━━━
class _Page extends StatefulWidget {
  final DateTime date;
  final AppStore store;
  const _Page({required this.date, required this.store});
  @override
  State<_Page> createState() => _PageState();
}

class _PageState extends State<_Page> with AutomaticKeepAliveClientMixin {
  late TextEditingController _ctrl;
  bool _dirty = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final existing = widget.store.getDiaryForDate(widget.date);
    _ctrl = TextEditingController(text: existing?.text ?? '');
  }

  @override
  void dispose() {
    _autoSave();
    _ctrl.dispose();
    super.dispose();
  }

  void _autoSave() {
    final text = _ctrl.text.trim();
    if (text.isNotEmpty && _dirty) {
      widget.store.saveDiary(text, widget.date);
    }
  }

  bool get _isToday {
    final now = DateTime.now();
    return widget.date.day == now.day && widget.date.month == now.month && widget.date.year == now.year;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // required by AutomaticKeepAliveClientMixin
    final mood = widget.store.getMoodForDate(widget.date);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _C.line.withValues(alpha: 0.4), width: 1),
          boxShadow: [BoxShadow(color: _C.line, blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(children: [
            // ── Header ──
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
              decoration: const BoxDecoration(
                color: Color(0xFFFFFBF5),
                border: Border(bottom: BorderSide(color: _C.line, width: 1))),
              child: Row(children: [
                if (mood != null) ...[
                  Container(width: 24, height: 24,
                    decoration: BoxDecoration(shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [mood.mood.accent, mood.mood.color])),
                    child: Center(child: Text(mood.mood.label[0],
                      style: kHeading(size: 10, color: Colors.white)))),
                  const SizedBox(width: 8),
                ],
                Text(_isToday ? 'Today' : _relative(widget.date),
                  style: kHeading(size: 14, color: _C.text)),
                const Spacer(),
                if (_dirty)
                  KawaiiPressable(
                    sound: KawaiiSound.send,
                    onTap: () {
                      _autoSave();
                      setState(() => _dirty = false);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _C.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10)),
                      child: Text('Save', style: kBody(size: 10, weight: FontWeight.w800, color: _C.accent)),
                    ),
                  ),
              ]),
            ),

            // ── Writing area with lines ──
            Expanded(child: Stack(children: [
              Positioned.fill(child: CustomPaint(painter: _LinesPainter())),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: TextField(
                  controller: _ctrl,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  onChanged: (_) { if (!_dirty) setState(() => _dirty = true); },
                  style: kBody(size: 15, color: _C.text).copyWith(height: 2.0),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: _isToday ? 'Write about your day...' : null,
                    hintStyle: kBody(size: 15, color: _C.muted.withValues(alpha: 0.35)),
                  ),
                ),
              ),
            ])),

            // ── Feeling tags footer ──
            if (mood != null && mood.feelings.isNotEmpty)
              Container(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: _C.line, width: 1))),
                child: Wrap(spacing: 5, children: mood.feelings.map((f) =>
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: f.color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6)),
                    child: Text(f.label, style: kBody(size: 9, weight: FontWeight.w800, color: f.color)),
                  )).toList()),
              ),
          ]),
        ),
      ),
    );
  }

  String _relative(DateTime d) {
    final diff = DateTime.now().difference(d).inDays;
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return '$diff days ago';
    return '${d.month}/${d.day}';
  }
}

class _LinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = _C.line..strokeWidth = 0.5;
    var y = 30.0;
    while (y < size.height) {
      canvas.drawLine(Offset(16, y), Offset(size.width - 16, y), paint);
      y += 30;
    }
  }

  @override
  bool shouldRepaint(_LinesPainter old) => false;
}

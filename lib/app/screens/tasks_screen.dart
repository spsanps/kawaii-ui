import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kawaii_ui/kawaii_ui.dart';
import '../models/models.dart';
import '../models/store.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  TASKS SCREEN — award-winning kawaii task management
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

enum _TaskPriority { low, medium, high }

extension _TaskPriorityX on _TaskPriority {
  String get label => switch (this) {
    _TaskPriority.low => 'Low',
    _TaskPriority.medium => 'Medium',
    _TaskPriority.high => 'High',
  };
  Color get color => switch (this) {
    _TaskPriority.low => KawaiiColors.greenBottom,
    _TaskPriority.medium => KawaiiColors.goldBottom,
    _TaskPriority.high => const Color(0xFFE57373),
  };
}

class TasksScreen extends StatefulWidget {
  final AppStore store;
  const TasksScreen({super.key, required this.store});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  int _selectedFilter = 0;
  final Set<String> _recentlyCompleted = {};
  bool _showingAddForm = false;
  final _addTitleCtrl = TextEditingController();
  TaskCategory _addCategory = TaskCategory.personal;

  @override
  void dispose() {
    _addTitleCtrl.dispose();
    super.dispose();
  }

  static const _filters = ['All', 'Personal', 'Work', 'Health', 'Creative'];

  TaskCategory? get _selectedCategory => switch (_selectedFilter) {
    1 => TaskCategory.personal,
    2 => TaskCategory.work,
    3 => TaskCategory.health,
    4 => TaskCategory.creative,
    _ => null,
  };

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }

  void _onToggleTask(TodoTask task) {
    widget.store.toggleTask(task.id);
  }

  void _confirmDelete(TodoTask task) {
    showKawaiiDialog(
      context: context,
      title: 'Delete Task?',
      content: Text(
        'Remove "${task.title}"?',
        style: kBody(size: 13, color: KawaiiColors.body),
        textAlign: TextAlign.center,
      ),
      actions: [
        KawaiiButton.gold('Cancel', small: true,
            onTap: () => Navigator.pop(context)),
        KawaiiButton.pink('Delete', small: true, onTap: () {
          widget.store.deleteTask(task.id);
          Navigator.pop(context);
        }),
      ],
    );
  }

  void _showAddTask() {
    final titleCtrl = TextEditingController();
    var selectedCat = TaskCategory.personal;
    var selectedPriority = _TaskPriority.medium;
    int charCount = 0;
    StateSetter? _sheetState;

    // Listen outside the builder to avoid adding listeners on every rebuild
    titleCtrl.addListener(() {
      final len = titleCtrl.text.length;
      if (len != charCount) {
        charCount = len;
        _sheetState?.call(() {});
      }
    });
    showKawaiiBottomSheet(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          _sheetState = setSheetState;
          return Padding(
            padding: const EdgeInsets.fromLTRB(
              KawaiiSpacing.page, KawaiiSpacing.lg,
              KawaiiSpacing.page, KawaiiSpacing.xxl,
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              // ── Title ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  kawaiiIcon(Star4Painter(), size: 14),
                  const SizedBox(width: KawaiiSpacing.md),
                  Text('New Task', style: kHeading(size: 18)),
                  const SizedBox(width: KawaiiSpacing.md),
                  kawaiiIcon(Star4Painter(), size: 14),
                ],
              ),
              const SizedBox(height: KawaiiSpacing.xl),

              // ── Title input with char count ──
              KawaiiSurface(
                gloss: GlossLevel.subtle,
                shineOpacity: 0.20,
                shineHeight: 0.36,
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(KawaiiBorderRadius.lg),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xBFFFFFFF), Color(0x8CFFF8FC)],
                  ),
                  border: Border.all(
                      color: KawaiiColors.cardBorder,
                      width: KawaiiBorderWidth.medium),
                  boxShadow: [
                    KawaiiShadows.medium(KawaiiColors.cardBorder)
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: titleCtrl,
                      autofocus: false,
                      maxLength: 80,
                      decoration: InputDecoration(
                        hintText: 'What needs doing?',
                        hintStyle: kBody(
                            size: 13, color: KawaiiColors.subtle),
                        border: InputBorder.none,
                        isDense: true,
                        counterText: '',
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 8),
                      ),
                      style: kBody(
                          size: 13, color: KawaiiColors.heading),
                    ),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: kBody(
                        size: 10,
                        color: charCount > 70
                            ? const Color(0xFFE57373)
                            : KawaiiColors.subtle,
                      ),
                      child: Text('$charCount / 80'),
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
              ),
              const SizedBox(height: KawaiiSpacing.xl),

              // ── Category pills with spring ──
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Category',
                    style: kBody(
                        size: 11,
                        weight: FontWeight.w800,
                        color: KawaiiColors.muted)),
              ),
              const SizedBox(height: KawaiiSpacing.md),
              Wrap(
                spacing: KawaiiSpacing.wrapSpacing,
                runSpacing: KawaiiSpacing.wrapRunSpacing,
                children: TaskCategory.values.map((cat) {
                  final selected = cat == selectedCat;
                  return KawaiiPressable(
                    pressScale: 0.92,
                    pressTranslateY: 2,
                    onTap: () {
                        setSheetState(() => selectedCat = cat);
                    },
                    child: AnimatedScale(
                      scale: selected ? 1.08 : 1.0,
                      duration: const Duration(milliseconds: 250),
                      curve: KawaiiCurves.spring,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          gradient: selected
                              ? LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    cat.color.withValues(
                                        alpha:
                                            KawaiiOpacity.heavy),
                                    cat.color,
                                  ],
                                )
                              : null,
                          color: selected
                              ? null
                              : cat.color.withValues(
                                  alpha: KawaiiOpacity.whisper),
                          borderRadius: BorderRadius.circular(
                              KawaiiBorderRadius.md),
                          border: Border.all(
                            color: selected
                                ? cat.color.withValues(
                                    alpha: KawaiiOpacity.medium)
                                : cat.color.withValues(
                                    alpha: KawaiiOpacity.hint),
                            width: selected
                                ? KawaiiBorderWidth.medium
                                : KawaiiBorderWidth.thin,
                          ),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                    color: cat.color
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : null,
                        ),
                        child: Text(
                          cat.label,
                          style: kBody(
                            size: 12,
                            weight: selected
                                ? FontWeight.w800
                                : FontWeight.w600,
                            color: selected
                                ? Colors.white
                                : cat.color,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: KawaiiSpacing.xl),

              // ── Priority selector with KawaiiRadio ──
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Priority',
                    style: kBody(
                        size: 11,
                        weight: FontWeight.w800,
                        color: KawaiiColors.muted)),
              ),
              const SizedBox(height: KawaiiSpacing.md),
              Row(
                children: _TaskPriority.values.map((p) {
                  return Expanded(
                    child: KawaiiPressable(
                      pressScale: 0.92,
                      pressTranslateY: 2,
                      onTap: () {
                          setSheetState(
                              () => selectedPriority = p);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          KawaiiRadio<_TaskPriority>(
                            value: p,
                            groupValue: selectedPriority,
                            color: p.color,
                            playSound: false,
                            onChanged: (v) => setSheetState(
                                () => selectedPriority = v),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            p.label,
                            style: kBody(
                              size: 12,
                              weight: p == selectedPriority
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: p == selectedPriority
                                  ? p.color
                                  : KawaiiColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: KawaiiSpacing.xxl),

              // ── Add hero button ──
              KawaiiButton.pink(
                'Add Task',
                hero: true,
                i: kawaiiIcon(
                    CheckPainter(color: KawaiiColors.pinkText),
                    size: 16),
                onTap: () {
                  final title = titleCtrl.text.trim();
                  if (title.isEmpty) return;
                  widget.store.addTask(title, selectedCat);
                  Navigator.pop(ctx);
                },
              ),
            ]),
          );
        },
      ),
    ).whenComplete(() => titleCtrl.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return KawaiiScaffold(
      appBar: KawaiiAppBar(
        title: Row(mainAxisSize: MainAxisSize.min, children: [
          kawaiiIcon(CheckPainter(color: KawaiiColors.heading), size: 20),
          const SizedBox(width: KawaiiSpacing.md),
          const Text('Tasks'),
        ]),
      ),
      body: ListenableBuilder(
        listenable: widget.store,
        builder: (context, _) {
          final filtered =
              widget.store.tasksByCategory(_selectedCategory);
          final pending = filtered.where((t) => !t.done).toList();
          final completed = filtered.where((t) => t.done).toList();
          final totalAll = widget.store.tasksTotal;
          final doneAll = widget.store.tasksCompleted;

          return Column(children: [
            // ── Animated header with progress arc ──
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  KawaiiSpacing.xl, KawaiiSpacing.md,
                  KawaiiSpacing.xl, 0),
              child: _ProgressHeader(
                done: doneAll,
                total: totalAll,
              ),
            ),
            const SizedBox(height: KawaiiSpacing.lg),

            // ── Category filter pills ──
            SizedBox(
              height: 52,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                padding: const EdgeInsets.symmetric(
                    horizontal: KawaiiSpacing.xl, vertical: 4),
                itemCount: _filters.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: KawaiiSpacing.md),
                itemBuilder: (context, i) {
                  final selected = i == _selectedFilter;
                  final color = i == 0
                      ? KawaiiColors.pinkBottom
                      : TaskCategory.values[i - 1].color;
                  return KawaiiPressable(
                    pressScale: 0.92,
                    pressTranslateY: 2,
                    onTap: () {
                      setState(() => _selectedFilter = i);
                    },
                    child: AnimatedScale(
                      scale: selected ? 1.06 : 1.0,
                      duration: const Duration(milliseconds: 250),
                      curve: KawaiiCurves.spring,
                      child: KawaiiSurface(
                        gloss: selected
                            ? GlossLevel.full
                            : GlossLevel.subtle,
                        shineOpacity: selected ? 0.40 : 0.20,
                        shineHeight: 0.38,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              KawaiiBorderRadius.xxl),
                          gradient: selected
                              ? LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    color.withValues(
                                        alpha:
                                            KawaiiOpacity.heavy),
                                    color,
                                  ],
                                )
                              : LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    color.withValues(
                                        alpha:
                                            KawaiiOpacity.whisper),
                                    color.withValues(
                                        alpha:
                                            KawaiiOpacity.ghost),
                                  ],
                                ),
                          border: Border.all(
                            color: selected
                                ? color.withValues(
                                    alpha: KawaiiOpacity.medium)
                                : color.withValues(
                                    alpha: KawaiiOpacity.hint),
                            width: selected
                                ? KawaiiBorderWidth.medium
                                : KawaiiBorderWidth.thin,
                          ),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                    color: color
                                        .withValues(alpha: 0.35),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : [
                                  KawaiiShadows.soft(color),
                                ],
                        ),
                        child: Text(
                          _filters[i],
                          style: kBody(
                            size: 12,
                            weight: selected
                                ? FontWeight.w800
                                : FontWeight.w600,
                            color: selected
                                ? Colors.white
                                : color.withValues(
                                    alpha: KawaiiOpacity.strong),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: KawaiiSpacing.md),

            // ── Task list ──
            Expanded(
              child: (pending.isEmpty && completed.isEmpty)
                  ? _EmptyState(filterIndex: _selectedFilter)
                  : _TaskListView(
                      pending: pending,
                      completed: completed,
                      recentlyCompleted: _recentlyCompleted,
                      onToggle: _onToggleTask,
                      onDelete: _confirmDelete,
                      timeAgo: _timeAgo,
                    ),
            ),

            // ── Inline add form (instant, no sheet animation) ──
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: KawaiiCurves.soft,
              child: _showingAddForm
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: KawaiiSpacing.xl, vertical: KawaiiSpacing.md),
                    child: KawaiiCard(showSparkles: false, child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        KawaiiTextField(
                          placeholder: 'What needs doing?',
                          controller: _addTitleCtrl,
                          color: _addCategory.color,
                        ),
                        const SizedBox(height: KawaiiSpacing.lg),
                        Wrap(spacing: 6, runSpacing: 6, children: TaskCategory.values.map((cat) {
                          final sel = cat == _addCategory;
                          return KawaiiPressable(
                            pressScale: 0.92, pressTranslateY: 2,
                            onTap: () => setState(() => _addCategory = cat),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(KawaiiBorderRadius.md),
                                gradient: sel ? LinearGradient(colors: [cat.accent, cat.color]) : null,
                                color: sel ? null : cat.color.withValues(alpha: KawaiiOpacity.whisper),
                                border: Border.all(color: cat.color.withValues(alpha: sel ? 0.5 : 0.15)),
                              ),
                              child: Text(cat.label, style: kBody(size: 11, weight: FontWeight.w800,
                                color: sel ? Colors.white : cat.color)),
                            ),
                          );
                        }).toList()),
                        const SizedBox(height: KawaiiSpacing.lg),
                        Row(children: [
                          Expanded(child: KawaiiButton.pink('Add', onTap: () {
                            final title = _addTitleCtrl.text.trim();
                            if (title.isEmpty) return;
                            widget.store.addTask(title, _addCategory);
                            _addTitleCtrl.clear();
                            setState(() => _showingAddForm = false);
                            showKawaiiSnackbar(context: context, message: 'Task added!',
                              type: KawaiiSnackbarType.success);
                          })),
                          const SizedBox(width: KawaiiSpacing.md),
                          KawaiiButton.green('Cancel', small: true, onTap: () {
                            _addTitleCtrl.clear();
                            setState(() => _showingAddForm = false);
                          }),
                        ]),
                      ],
                    )),
                  )
                : Padding(
                    padding: const EdgeInsets.only(
                      bottom: KawaiiSpacing.xxl, top: KawaiiSpacing.md),
                    child: KawaiiButton.pink('Add New Task', hero: true,
                      i: kawaiiIcon(const Star4Painter(), size: 16),
                      onTap: () => setState(() => _showingAddForm = true)),
                  ),
            ),
          ]);
        },
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  PROGRESS HEADER — animated arc + task count
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _ProgressHeader extends StatelessWidget {
  final int done;
  final int total;
  const _ProgressHeader({required this.done, required this.total});

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? done.toDouble() / total : 0.0;
    return KawaiiSurface(tactile: false,
      gloss: GlossLevel.subtle,
      shineOpacity: 0.30,
      shineHeight: 0.40,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(KawaiiBorderRadius.card),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xBFFFFFFF), Color(0x8CFFF8FC)],
        ),
        border: Border.all(
            color: KawaiiColors.cardBorder, width: KawaiiBorderWidth.light),
        boxShadow: [KawaiiShadows.soft(KawaiiColors.pinkShadow)],
      ),
      child: Row(children: [
        // Animated arc
        SizedBox(
          width: 52,
          height: 52,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: pct),
            duration: const Duration(milliseconds: 800),
            curve: KawaiiCurves.soft,
            builder: (context, value, _) {
              return CustomPaint(
                painter: _ProgressArcPainter(
                  progress: value,
                  trackColor:
                      KawaiiColors.pinkBottom.withValues(alpha: KawaiiOpacity.hint),
                  fillColor: KawaiiColors.pinkBottom,
                ),
                child: Center(
                  child: Text(
                    '${(value * 100).round()}%',
                    style: kHeading(
                        size: 13, color: KawaiiColors.pinkBottom),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: KawaiiSpacing.xl),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: done),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                builder: (context, value, _) {
                  return RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '$value',
                        style: kHeading(
                            size: 22, color: KawaiiColors.pinkBottom),
                      ),
                      TextSpan(
                        text: ' of $total done',
                        style: kBody(
                            size: 14, color: KawaiiColors.body),
                      ),
                    ]),
                  );
                },
              ),
              const SizedBox(height: 4),
              Text(
                total == done && total > 0
                    ? 'All done! You\'re amazing~'
                    : total - done == 1
                        ? 'Almost there! 1 left'
                        : '${total - done} tasks remaining',
                style: kBody(size: 11, color: KawaiiColors.muted),
              ),
            ],
          ),
        ),
        // Decorative sparkle
        if (pct >= 1.0)
          SparkleWidget(
            size: 24,
            fill: KawaiiColors.starFill,
            stroke: KawaiiColors.starStroke,
          ),
      ]),
    );
  }
}

class _ProgressArcPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color fillColor;

  _ProgressArcPainter({
    required this.progress,
    required this.trackColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - 4;
    const strokeWidth = 5.0;
    const startAngle = -pi / 2;

    // Track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    // Fill arc
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        2 * pi * progress,
        false,
        Paint()
          ..color = fillColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_ProgressArcPainter old) =>
      old.progress != progress ||
      old.trackColor != trackColor ||
      old.fillColor != fillColor;
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  EMPTY STATE — cute per-category messages
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _EmptyState extends StatelessWidget {
  final int filterIndex;
  const _EmptyState({required this.filterIndex});

  static const _emptyMessages = <int, (String, String)>{
    0: ('Nothing here yet!', 'Tap + to add your first task'),
    1: ('No personal tasks', 'Self-care starts with a plan~'),
    2: ('Work inbox clear!', 'You deserve a break~'),
    3: ('No health tasks', 'Time to move that body!'),
    4: ('No creative tasks', 'Let your imagination bloom~'),
  };

  @override
  Widget build(BuildContext context) {
    final msgs = _emptyMessages[filterIndex] ?? _emptyMessages[0]!;
    return Center(
      child: KawaiiEntrance(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          kawaiiIcon(Star4Painter(), size: 44),
          const SizedBox(height: KawaiiSpacing.xl),
          Text(msgs.$1,
              style: kHeading(size: 17, color: KawaiiColors.muted)),
          const SizedBox(height: KawaiiSpacing.sm),
          Text(msgs.$2,
              style: kBody(size: 12, color: KawaiiColors.subtle)),
        ]),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  TASK LIST VIEW — sectioned with headers + animated reorder
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _TaskListView extends StatelessWidget {
  final List<TodoTask> pending;
  final List<TodoTask> completed;
  final Set<String> recentlyCompleted;
  final ValueChanged<TodoTask> onToggle;
  final ValueChanged<TodoTask> onDelete;
  final String Function(DateTime) timeAgo;

  const _TaskListView({
    required this.pending,
    required this.completed,
    required this.recentlyCompleted,
    required this.onToggle,
    required this.onDelete,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    // Build a flat list of widgets: [active header, ...active cards, completed header, ...completed cards]
    final items = <Widget>[];

    if (pending.isNotEmpty) {
      items.add(_SectionHeader(
          label: 'Active', count: pending.length, active: true));
      items.add(const SizedBox(height: KawaiiSpacing.md));
      for (int i = 0; i < pending.length; i++) {
        items.add(_TaskCardEntry(
          task: pending[i],
          index: i,
          recentlyCompleted: recentlyCompleted,
          onToggle: onToggle,
          onDelete: onDelete,
          timeAgo: timeAgo,
        ));
      }
    }

    if (completed.isNotEmpty) {
      items.add(const SizedBox(height: KawaiiSpacing.md));
      items.add(_SectionHeader(
          label: 'Completed',
          count: completed.length,
          active: false));
      items.add(const SizedBox(height: KawaiiSpacing.md));
      for (int i = 0; i < completed.length; i++) {
        items.add(_TaskCardEntry(
          task: completed[i],
          index: pending.length + i,
          recentlyCompleted: recentlyCompleted,
          onToggle: onToggle,
          onDelete: onDelete,
          timeAgo: timeAgo,
        ));
      }
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
          horizontal: KawaiiSpacing.xl, vertical: KawaiiSpacing.md),
      itemCount: items.length,
      itemBuilder: (context, index) => items[index],
    );
  }
}

class _TaskCardEntry extends StatelessWidget {
  final TodoTask task;
  final int index;
  final Set<String> recentlyCompleted;
  final ValueChanged<TodoTask> onToggle;
  final ValueChanged<TodoTask> onDelete;
  final String Function(DateTime) timeAgo;

  const _TaskCardEntry({
    required this.task,
    required this.index,
    required this.recentlyCompleted,
    required this.onToggle,
    required this.onDelete,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: KawaiiSpacing.md),
      child: _TaskCard(
        task: task,
        showSparkle: recentlyCompleted.contains(task.id),
        onToggle: () => onToggle(task),
        onDelete: () => onDelete(task),
        timeAgo: timeAgo(task.createdAt),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  SECTION HEADER — "Active (5)" / "Completed (2)" with count badge
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _SectionHeader extends StatelessWidget {
  final String label;
  final int count;
  final bool active;
  const _SectionHeader(
      {required this.label, required this.count, required this.active});

  @override
  Widget build(BuildContext context) {
    final color = active ? KawaiiColors.heading : KawaiiColors.muted;
    return Row(children: [
      if (active)
        Padding(
          padding: const EdgeInsets.only(right: KawaiiSpacing.md),
          child: kawaiiIcon(Star4Painter(
            fill: KawaiiColors.starFill,
            stroke: KawaiiColors.starStroke,
            strokeWidth: 1.0,
          ), size: 10),
        ),
      Text(
        label,
        style: kBody(
          size: 11,
          weight: FontWeight.w800,
          color: color,
        ).copyWith(letterSpacing: 1.5),
      ),
      const SizedBox(width: KawaiiSpacing.md),
      // Count badge
      Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: (active
                  ? KawaiiColors.pinkBottom
                  : KawaiiColors.glass)
              .withValues(alpha: KawaiiOpacity.hint),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: (active
                    ? KawaiiColors.pinkBottom
                    : KawaiiColors.glass)
                .withValues(alpha: KawaiiOpacity.whisper),
            width: KawaiiBorderWidth.thin,
          ),
        ),
        child: Text(
          '$count',
          style: kBody(
            size: 10,
            weight: FontWeight.w800,
            color: active
                ? KawaiiColors.pinkBottom
                : KawaiiColors.muted,
          ),
        ),
      ),
      const Spacer(),
      // Decorative line
      Expanded(
        flex: 3,
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.transparent,
              color.withValues(alpha: KawaiiOpacity.hint),
              Colors.transparent,
            ]),
          ),
        ),
      ),
    ]);
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  TASK CARD — the star of the show
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _TaskCard extends StatelessWidget {
  final TodoTask task;
  final bool showSparkle;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final String timeAgo;

  const _TaskCard({
    required this.task,
    required this.showSparkle,
    required this.onToggle,
    required this.onDelete,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = task.done;
    final catColor = task.category.color;

    return Dismissible(
      key: ValueKey(task.id),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          onDelete();
          return false;
        } else {
          onToggle();
          return false;
        }
      },
      background: _buildSwipeBackground(
        alignment: Alignment.centerLeft,
        color: KawaiiColors.greenBottom,
        icon: CheckPainter(color: KawaiiColors.greenBottom),
        label: isDone ? 'Undo' : 'Done',
      ),
      secondaryBackground: _buildSwipeBackground(
        alignment: Alignment.centerRight,
        color: const Color(0xFFE57373),
        icon: CheckPainter(color: const Color(0xFFE57373)),
        label: 'Delete',
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isDone ? 0.60 : 1.0,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Card body
            // Kawaii task pill — tinted by category, glossy, no left stripe
            KawaiiSurface(tactile: false,
              gloss: isDone ? GlossLevel.subtle : GlossLevel.medium,
              shineOpacity: isDone ? 0.15 : 0.30,
              shineHeight: 0.36,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(KawaiiBorderRadius.xl),
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [
                    catColor.withValues(alpha: isDone ? 0.06 : 0.12),
                    catColor.withValues(alpha: isDone ? 0.02 : 0.05),
                  ]),
                border: Border.all(
                  color: catColor.withValues(alpha: isDone ? 0.06 : 0.14),
                  width: KawaiiBorderWidth.light),
                boxShadow: [BoxShadow(
                  color: catColor.withValues(alpha: isDone ? 0.02 : 0.06),
                  blurRadius: 10, offset: const Offset(0, 3))],
              ),
              child: Row(
                children: [
                  // Checkbox
                  KawaiiCheckbox(value: isDone, color: catColor,
                    onChanged: (_) => onToggle()),
                  const SizedBox(width: KawaiiSpacing.lg),

                  // Title + category tag
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                                AnimatedDefaultTextStyle(
                                  duration:
                                      const Duration(
                                          milliseconds: 300),
                                  style: kBody(
                                    size: 13,
                                    weight: FontWeight.w700,
                                    color: isDone
                                        ? KawaiiColors.muted
                                        : KawaiiColors.heading,
                                  ).copyWith(
                                    decoration: isDone
                                        ? TextDecoration
                                            .lineThrough
                                        : TextDecoration.none,
                                    decorationColor:
                                        KawaiiColors.muted,
                                    decorationThickness: 2,
                                  ),
                                  child: Text(task.title),
                                ),
                                const SizedBox(height: 5),
                                // Bottom row: category tag + time
                                Row(children: [
                                  KawaiiTag(
                                    task.category.label,
                                    color: catColor,
                                    interactive: false,
                                  ),
                                  const SizedBox(
                                      width: KawaiiSpacing.md),
                                  Text(
                                    timeAgo,
                                    style: kBody(
                                      size: 10,
                                      color:
                                          KawaiiColors.subtle,
                                    ),
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        ],
                      ),
            ),

            // Sparkle burst overlay on completion
            if (showSparkle)
              Positioned.fill(
                child: IgnorePointer(
                  child: _SparkleOverlay(color: catColor),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({
    required Alignment alignment,
    required Color color,
    required CustomPainter icon,
    required String label,
  }) {
    final isLeft = alignment == Alignment.centerLeft;
    return Container(
      alignment: alignment,
      padding: EdgeInsets.only(
        left: isLeft ? KawaiiSpacing.xxl : 0,
        right: isLeft ? 0 : KawaiiSpacing.xxl,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(KawaiiBorderRadius.lg),
        color: color.withValues(alpha: KawaiiOpacity.hint),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isLeft) ...[
            Text(label,
                style: kBody(
                    size: 12, weight: FontWeight.w700, color: color)),
            const SizedBox(width: KawaiiSpacing.md),
          ],
          kawaiiIcon(icon, size: 20),
          if (isLeft) ...[
            const SizedBox(width: KawaiiSpacing.md),
            Text(label,
                style: kBody(
                    size: 12, weight: FontWeight.w700, color: color)),
          ],
        ],
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  SPARKLE OVERLAY — celebratory burst animation on completion
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _SparkleOverlay extends StatefulWidget {
  final Color color;
  const _SparkleOverlay({required this.color});

  @override
  State<_SparkleOverlay> createState() => _SparkleOverlayState();
}

class _SparkleOverlayState extends State<_SparkleOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late List<_Sparkle> _sparkles;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    final rng = Random();
    _sparkles = List.generate(8, (_) {
      return _Sparkle(
        dx: (rng.nextDouble() - 0.5) * 2,
        dy: (rng.nextDouble() - 0.5) * 2,
        size: 6.0 + rng.nextDouble() * 8,
        delay: rng.nextDouble() * 0.3,
      );
    });
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
        return CustomPaint(
          painter: _SparkleBurstPainter(
            progress: _ctrl.value,
            sparkles: _sparkles,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class _Sparkle {
  final double dx, dy, size, delay;
  const _Sparkle(
      {required this.dx,
      required this.dy,
      required this.size,
      required this.delay});
}

class _SparkleBurstPainter extends CustomPainter {
  final double progress;
  final List<_Sparkle> sparkles;
  final Color color;

  _SparkleBurstPainter({
    required this.progress,
    required this.sparkles,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    for (final sparkle in sparkles) {
      final t =
          ((progress - sparkle.delay) / (1.0 - sparkle.delay)).clamp(0.0, 1.0);
      if (t <= 0) continue;

      final opacity = t < 0.5 ? t * 2 : (1.0 - t) * 2;
      final dist = t * 40;
      final x = cx + sparkle.dx * dist;
      final y = cy + sparkle.dy * dist;
      final s = sparkle.size * (1.0 - t * 0.5);

      // Draw a 4-pointed star shape
      final path = Path();
      path.moveTo(x, y - s / 2);
      path.cubicTo(x, y - s / 2, x + s * 0.15, y - s * 0.15, x + s / 2, y);
      path.cubicTo(x + s * 0.15, y + s * 0.15, x, y + s / 2, x, y + s / 2);
      path.cubicTo(x, y + s / 2, x - s * 0.15, y + s * 0.15, x - s / 2, y);
      path.cubicTo(x - s * 0.15, y - s * 0.15, x, y - s / 2, x, y - s / 2);
      path.close();

      canvas.drawPath(
        path,
        Paint()
          ..color = Color.lerp(KawaiiColors.starFill, color, 0.3)!
              .withValues(alpha: opacity.clamp(0.0, 1.0)),
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = KawaiiColors.starStroke
              .withValues(alpha: (opacity * 0.6).clamp(0.0, 1.0))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0,
      );
    }
  }

  @override
  bool shouldRepaint(_SparkleBurstPainter old) =>
      old.progress != progress;
}

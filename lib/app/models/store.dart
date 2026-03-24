import 'package:flutter/material.dart';
import 'models.dart';

class AppStore extends ChangeNotifier {
  // ━━━ XP & REWARDS ━━━
  int _xp = 120;
  int _streak = 3;
  final List<String> _achievements = ['First Task', 'Mood Logger'];

  int get xp => _xp;
  int get level => (_xp / 100).floor() + 1;
  double get levelProgress => (_xp % 100) / 100;
  int get streak => _streak;
  List<String> get achievements => List.unmodifiable(_achievements);

  // ━━━ MOOD STREAK (cached) ━━━
  int? _moodStreakCache;
  int get moodStreak => _moodStreakCache ??= _computeMoodStreak();

  int _computeMoodStreak() {
    if (_moods.isEmpty) return 0;
    int s = 0;
    var day = DateTime.now();
    for (int i = 0; i < 365; i++) {
      final hasEntry = _moods.any((m) =>
          m.createdAt.day == day.day &&
          m.createdAt.month == day.month &&
          m.createdAt.year == day.year);
      if (hasEntry) {
        s++;
        day = day.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return s;
  }

  void _invalidateMoodStreak() => _moodStreakCache = null;

  void _earnXP(int amount) {
    _xp += amount;
    // Check for level-up achievements
    if (level >= 5 && !_achievements.contains('Level 5')) {
      _achievements.add('Level 5');
    }
  }

  // ━━━ TASKS ━━━
  final List<TodoTask> _tasks = [
    TodoTask(id: '1', title: 'Plan weekend outfit', category: TaskCategory.personal, createdAt: DateTime.now()),
    TodoTask(id: '2', title: 'Finish portfolio design', category: TaskCategory.work, createdAt: DateTime.now()),
    TodoTask(id: '3', title: 'Morning yoga session', category: TaskCategory.health, done: true, createdAt: DateTime.now()),
    TodoTask(id: '4', title: 'Sketch character concepts', category: TaskCategory.creative, createdAt: DateTime.now()),
    TodoTask(id: '5', title: 'Reply to client emails', category: TaskCategory.work, done: true, createdAt: DateTime.now()),
    TodoTask(id: '6', title: 'Buy matcha powder', category: TaskCategory.personal, createdAt: DateTime.now()),
    TodoTask(id: '7', title: '30 min cardio', category: TaskCategory.health, createdAt: DateTime.now()),
  ];

  List<TodoTask> get tasks => List.unmodifiable(_tasks);
  List<TodoTask> tasksByCategory(TaskCategory? cat) =>
    cat == null ? tasks : _tasks.where((t) => t.category == cat).toList();
  int get tasksCompleted => _tasks.where((t) => t.done).length;
  int get tasksTotal => _tasks.length;

  void addTask(String title, TaskCategory category) {
    _tasks.insert(0, TodoTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title, category: category, createdAt: DateTime.now()));
    notifyListeners();
  }

  void toggleTask(String id) {
    final i = _tasks.indexWhere((t) => t.id == id);
    if (i >= 0) {
      final wasDone = _tasks[i].done;
      _tasks[i] = _tasks[i].copyWith(done: !wasDone);
      if (!wasDone) { _earnXP(10); _streak++; } // completing earns XP
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // ━━━ MOODS ━━━
  final List<MoodEntry> _moods = [
    MoodEntry(id: '1', mood: Mood.happy, feelings: [Feeling.grateful, Feeling.excited],
      intensity: 0.8, note: 'Great day! Got a lot done.', createdAt: DateTime.now().subtract(const Duration(days: 2))),
    MoodEntry(id: '2', mood: Mood.calm, feelings: [Feeling.peaceful],
      intensity: 0.6, note: 'Peaceful morning walk.', createdAt: DateTime.now().subtract(const Duration(days: 1))),
    MoodEntry(id: '3', mood: Mood.neutral, intensity: 0.5, createdAt: DateTime.now()),
  ];

  List<MoodEntry> get moods => List.unmodifiable(_moods);
  MoodEntry? get todaysMood {
    final now = DateTime.now();
    try {
      return _moods.firstWhere((m) =>
        m.createdAt.day == now.day && m.createdAt.month == now.month && m.createdAt.year == now.year);
    } catch (_) { return null; }
  }

  void addMood(Mood mood, List<Feeling> feelings, double intensity, String? note) {
    _moods.insert(0, MoodEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      mood: mood, feelings: feelings, intensity: intensity, note: note, createdAt: DateTime.now()));
    _earnXP(15); // mood logging earns XP
    _invalidateMoodStreak();
    if (_moods.length >= 7 && !_achievements.contains('Week Tracker')) {
      _achievements.add('Week Tracker');
    }
    notifyListeners();
  }

  // ━━━ GOALS ━━━
  final List<Goal> _goals = [
    Goal(id: '1', title: 'Read 12 books', target: 12, current: 7, color: const Color(0xFF7C4DFF), createdAt: DateTime.now()),
    Goal(id: '2', title: 'Run 50km', target: 50, current: 32, color: const Color(0xFF66BB6A), createdAt: DateTime.now()),
    Goal(id: '3', title: 'Save ¥100k', target: 100, current: 68, color: const Color(0xFFFFB74D), createdAt: DateTime.now()),
  ];

  List<Goal> get goals => List.unmodifiable(_goals);

  void addGoal(String title, int target, Color color) {
    _goals.insert(0, Goal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title, target: target, color: color, createdAt: DateTime.now()));
    notifyListeners();
  }

  void incrementGoal(String id, [int amount = 1]) {
    final i = _goals.indexWhere((g) => g.id == id);
    if (i >= 0) {
      final wasComplete = _goals[i].completed;
      _goals[i] = _goals[i].copyWith(current: (_goals[i].current + amount).clamp(0, _goals[i].target));
      _earnXP(5 * amount);
      if (!wasComplete && _goals[i].completed) {
        _earnXP(50); // bonus for completing a goal
        if (!_achievements.contains('Goal Crusher')) _achievements.add('Goal Crusher');
      }
      notifyListeners();
    }
  }

  void deleteGoal(String id) {
    _goals.removeWhere((g) => g.id == id);
    notifyListeners();
  }
}

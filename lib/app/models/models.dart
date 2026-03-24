import 'package:flutter/material.dart';

// ━━━ TASK ━━━
enum TaskCategory { personal, work, health, creative }

extension TaskCategoryX on TaskCategory {
  String get label => switch (this) {
    TaskCategory.personal => 'Personal',
    TaskCategory.work => 'Work',
    TaskCategory.health => 'Health',
    TaskCategory.creative => 'Creative',
  };
  Color get color => switch (this) {
    TaskCategory.personal => const Color(0xFFF06292),
    TaskCategory.work => const Color(0xFF7C4DFF),
    TaskCategory.health => const Color(0xFF66BB6A),
    TaskCategory.creative => const Color(0xFFFF8A65),
  };
  Color get accent => switch (this) {
    TaskCategory.personal => const Color(0xFFFFABC8),
    TaskCategory.work => const Color(0xFFB388FF),
    TaskCategory.health => const Color(0xFFA5D6A7),
    TaskCategory.creative => const Color(0xFFFFCCBC),
  };
}

class TodoTask {
  final String id;
  final String title;
  final TaskCategory category;
  final bool done;
  final DateTime createdAt;

  const TodoTask({
    required this.id, required this.title,
    this.category = TaskCategory.personal,
    this.done = false, required this.createdAt,
  });

  TodoTask copyWith({String? title, TaskCategory? category, bool? done}) =>
    TodoTask(id: id, title: title ?? this.title,
      category: category ?? this.category,
      done: done ?? this.done, createdAt: createdAt);
}

// ━━━ MOOD ━━━
enum Mood { happy, calm, neutral, anxious, sad }

extension MoodX on Mood {
  String get label => switch (this) {
    Mood.happy => 'Happy',
    Mood.calm => 'Calm',
    Mood.neutral => 'Neutral',
    Mood.anxious => 'Anxious',
    Mood.sad => 'Sad',
  };
  Color get color => switch (this) {
    Mood.happy => const Color(0xFFFF8A80),
    Mood.calm => const Color(0xFF42A5F5),
    Mood.neutral => const Color(0xFFAB47BC),
    Mood.anxious => const Color(0xFFF06292),
    Mood.sad => const Color(0xFF7C4DFF),
  };
  Color get accent => switch (this) {
    Mood.happy => const Color(0xFFFFCDD2),
    Mood.calm => const Color(0xFF90CAF9),
    Mood.neutral => const Color(0xFFCE93D8),
    Mood.anxious => const Color(0xFFF8BBD0),
    Mood.sad => const Color(0xFFB388FF),
  };
}

// ━━━ FEELING TAGS (secondary mood layer) ━━━
enum Feeling {
  grateful, excited, proud, hopeful, loved,
  tired, stressed, lonely, frustrated, bored,
  peaceful, motivated
}

extension FeelingX on Feeling {
  String get label => switch (this) {
    Feeling.grateful => 'Grateful',
    Feeling.excited => 'Excited',
    Feeling.proud => 'Proud',
    Feeling.hopeful => 'Hopeful',
    Feeling.loved => 'Loved',
    Feeling.tired => 'Tired',
    Feeling.stressed => 'Stressed',
    Feeling.lonely => 'Lonely',
    Feeling.frustrated => 'Frustrated',
    Feeling.bored => 'Bored',
    Feeling.peaceful => 'Peaceful',
    Feeling.motivated => 'Motivated',
  };
  Color get color => switch (this) {
    Feeling.grateful => const Color(0xFFFFB74D),
    Feeling.excited => const Color(0xFFFF8A65),
    Feeling.proud => const Color(0xFFD4940C),
    Feeling.hopeful => const Color(0xFF26A69A),
    Feeling.loved => const Color(0xFFF06292),
    Feeling.tired => const Color(0xFF9575CD),
    Feeling.stressed => const Color(0xFFE57373),
    Feeling.lonely => const Color(0xFF42A5F5),
    Feeling.frustrated => const Color(0xFFEF5350),
    Feeling.bored => const Color(0xFF8E99A4),
    Feeling.peaceful => const Color(0xFF66BB6A),
    Feeling.motivated => const Color(0xFF4CAF50),
  };

  /// Tags promoted for each primary mood (sorted first in picker)
  static List<Feeling> promotedFor(Mood mood) => switch (mood) {
    Mood.happy => [Feeling.grateful, Feeling.excited, Feeling.proud, Feeling.loved, Feeling.motivated],
    Mood.calm => [Feeling.peaceful, Feeling.grateful, Feeling.hopeful, Feeling.loved],
    Mood.neutral => [Feeling.tired, Feeling.bored, Feeling.peaceful, Feeling.hopeful],
    Mood.anxious => [Feeling.stressed, Feeling.frustrated, Feeling.tired, Feeling.lonely],
    Mood.sad => [Feeling.lonely, Feeling.tired, Feeling.frustrated, Feeling.bored, Feeling.hopeful],
  };
}

class MoodEntry {
  final String id;
  final Mood mood;
  final List<Feeling> feelings; // 0-3 secondary feeling tags
  final double intensity; // 0-1
  final String? note;
  final DateTime createdAt;

  const MoodEntry({
    required this.id, required this.mood,
    this.feelings = const [],
    this.intensity = 0.5, this.note, required this.createdAt,
  });

  String get summary {
    if (feelings.isEmpty) return mood.label;
    return '${mood.label} + ${feelings.map((f) => f.label).join(', ')}';
  }
}

// ━━━ GOAL ━━━
class Goal {
  final String id;
  final String title;
  final int target;
  final int current;
  final Color color;
  final DateTime createdAt;

  const Goal({
    required this.id, required this.title,
    required this.target, this.current = 0,
    this.color = const Color(0xFFF06292),
    required this.createdAt,
  });

  double get progress => target > 0 ? (current / target).clamp(0.0, 1.0) : 0;
  bool get completed => current >= target;

  Goal copyWith({String? title, int? target, int? current, Color? color}) =>
    Goal(id: id, title: title ?? this.title,
      target: target ?? this.target, current: current ?? this.current,
      color: color ?? this.color, createdAt: createdAt);
}

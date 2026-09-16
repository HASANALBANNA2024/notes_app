import 'package:equatable/equatable.dart';

enum ReminderOffsetType { exact, min30Before, hour1Before, day1Before, custom }

class NoteModel extends Equatable {
  final String id;
  final String title;
  final String content;
  final String date;
  final String badgeText;
  final String badgeType;
  final bool isPinned;
  final bool isLocked;
  final DateTime? targetDateTime;
  final DateTime? reminderDateTime;
  final ReminderOffsetType reminderOffsetType;

  const NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.badgeText,
    required this.badgeType,
    this.isPinned = false,
    this.isLocked = false,
    this.targetDateTime,
    this.reminderDateTime,
    this.reminderOffsetType = ReminderOffsetType.exact,
  });

  /// SQLite DB-converter for DB (bool -> 1/0)
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'content': content,
    'date': date,
    'badgeText': badgeText,
    'badgeType': badgeType,
    'isPinned': isPinned ? 1 : 0,
    'isLocked': isLocked ? 1 : 0,
    'targetDateTime': targetDateTime?.toIso8601String(),
    'reminderDateTime': reminderDateTime?.toIso8601String(),
    'reminderOffsetType': reminderOffsetType.name,
  };

  /// SQLite DB converter read data from db (1/0 -> bool)
  factory NoteModel.fromMap(Map<String, dynamic> map) => NoteModel(
    id: map['id'] as String,
    title: map['title'] as String? ?? '',
    content: map['content'] as String? ?? '',
    date: map['date'] as String? ?? '',
    badgeText: map['badgeText'] as String? ?? '',
    badgeType: map['badgeType'] as String? ?? '',
    isPinned: (map['isPinned'] as int? ?? 0) == 1,
    isLocked: (map['isLocked'] as int? ?? 0) == 1,
    targetDateTime: map['targetDateTime'] != null
        ? DateTime.parse(map['targetDateTime'] as String)
        : null,
    reminderDateTime: map['reminderDateTime'] != null
        ? DateTime.parse(map['reminderDateTime'] as String)
        : null,
    reminderOffsetType: ReminderOffsetType.values.firstWhere(
      (e) => e.name == map['reminderOffsetType'],
      orElse: () => ReminderOffsetType.exact,
    ),
  );

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    date,
    badgeText,
    badgeType,
    isPinned,
    isLocked, // <-- ৫. Equatable এ যুক্ত করা হলো
    targetDateTime,
    reminderDateTime,
    reminderOffsetType,
  ];
}

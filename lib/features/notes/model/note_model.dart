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

  /// ✅ FIX #5: Proper type conversion with null safety
  factory NoteModel.fromMap(Map<String, dynamic> map) => NoteModel(
    id: map['id'] as String? ?? '',
    title: map['title'] as String? ?? '',
    content: map['content'] as String? ?? '',
    date: map['date'] as String? ?? '',
    badgeText: map['badgeText'] as String? ?? '',
    badgeType: map['badgeType'] as String? ?? '',
    isPinned: (map['isPinned'] as int? ?? 0) == 1,
    isLocked: (map['isLocked'] as int? ?? 0) == 1,
    targetDateTime: map['targetDateTime'] != null
        ? DateTime.tryParse(map['targetDateTime'] as String)
        : null,
    reminderDateTime: map['reminderDateTime'] != null
        ? DateTime.tryParse(map['reminderDateTime'] as String)
        : null,
    // ✅ FIX #5: Handle null reminderOffsetType safely
    reminderOffsetType: _parseReminderOffsetType(
      map['reminderOffsetType'] as String?,
    ),
  );

  /// ✅ Helper function to safely parse reminderOffsetType
  static ReminderOffsetType _parseReminderOffsetType(String? value) {
    if (value == null || value.isEmpty) {
      return ReminderOffsetType.exact;
    }
    try {
      return ReminderOffsetType.values.firstWhere(
        (e) => e.name == value,
        orElse: () => ReminderOffsetType.exact,
      );
    } catch (e) {
      print('Error parsing reminderOffsetType: $e, defaulting to exact');
      return ReminderOffsetType.exact;
    }
  }

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    date,
    badgeText,
    badgeType,
    isPinned,
    isLocked,
    targetDateTime,
    reminderDateTime,
    reminderOffsetType,
  ];
}

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
  final DateTime? targetDateTime; //notes main time
  final DateTime? reminderDateTime; // note reminder time
  final ReminderOffsetType reminderOffsetType;

  const NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.badgeText,
    required this.badgeType,
    this.isPinned = false,
    this.targetDateTime,
    this.reminderDateTime,
    this.reminderOffsetType = ReminderOffsetType.exact,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'date': date,
    'badgeText': badgeText,
    'badgeType': badgeType,
    'isPinned': isPinned,
    'targetDateTime': targetDateTime?.toIso8601String(),
    'reminderDateTime': reminderDateTime?.toIso8601String(),
    'reminderOffsetType': reminderOffsetType.name,
  };

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
    id: json['id'] as String,
    title: json['title'] as String,
    content: json['content'] as String,
    date: json['date'] as String,
    badgeText: json['badgeText'] as String,
    badgeType: json['badgeType'] as String,
    isPinned: json['isPinned'] as bool? ?? false,
    targetDateTime: json['targetDateTime'] != null
        ? DateTime.parse(json['targetDateTime'] as String)
        : null,
    reminderDateTime: json['reminderDateTime'] != null
        ? DateTime.parse(json['reminderDateTime'] as String)
        : null,
    reminderOffsetType: ReminderOffsetType.values.firstWhere(
      (e) => e.name == json['reminderOffsetType'],
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
    targetDateTime,
    reminderDateTime,
    reminderOffsetType,
  ];
}

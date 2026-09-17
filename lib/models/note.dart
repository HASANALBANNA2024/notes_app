/// A single note. Everything here is stored locally in SQLite (see
/// [NoteRepository] / [DatabaseService]) — screens never touch the
/// database directly, only [NotesBloc].
class Note {
  final String id;

  /// Incrementing per-device number, used only to render an id badge like
  /// "NOTE-001" on cards — purely cosmetic, not a stable/global id.
  final int sequenceNumber;

  String title;
  String description;
  String? label;
  int? colorValue;
  bool isPinned;
  bool isLocked;
  DateTime? reminderAt;
  final DateTime createdAt;
  DateTime updatedAt;

  Note({
    required this.id,
    required this.sequenceNumber,
    required this.title,
    required this.description,
    this.label,
    this.colorValue,
    this.isPinned = false,
    this.isLocked = false,
    this.reminderAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// e.g. "NOTE-001"
  String get displayId => 'NOTE-${sequenceNumber.toString().padLeft(3, '0')}';

  Note copyWith({
    String? title,
    String? description,
    String? label,
    bool clearLabel = false,
    int? colorValue,
    bool clearColor = false,
    bool? isPinned,
    bool? isLocked,
    DateTime? reminderAt,
    bool clearReminder = false,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id,
      sequenceNumber: sequenceNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      label: clearLabel ? null : (label ?? this.label),
      colorValue: clearColor ? null : (colorValue ?? this.colorValue),
      isPinned: isPinned ?? this.isPinned,
      isLocked: isLocked ?? this.isLocked,
      reminderAt: clearReminder ? null : (reminderAt ?? this.reminderAt),
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Converts this note into a SQLite-compatible row map. SQLite (via
  /// sqflite) has no native boolean type, so isPinned/isLocked are stored
  /// as 0/1 integers.
  Map<String, Object?> toMap() => {
        'id': id,
        'sequenceNumber': sequenceNumber,
        'title': title,
        'description': description,
        'label': label,
        'colorValue': colorValue,
        'isPinned': isPinned ? 1 : 0,
        'isLocked': isLocked ? 1 : 0,
        'reminderAt': reminderAt?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  /// Builds a [Note] from a raw SQLite row map (as returned by
  /// `db.query(...)`).
  factory Note.fromMap(Map<String, Object?> map) {
    return Note(
      id: map['id'] as String,
      sequenceNumber: map['sequenceNumber'] as int? ?? 1,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      label: map['label'] as String?,
      colorValue: map['colorValue'] as int?,
      isPinned: (map['isPinned'] as int? ?? 0) == 1,
      isLocked: (map['isLocked'] as int? ?? 0) == 1,
      reminderAt: map['reminderAt'] == null
          ? null
          : DateTime.tryParse(map['reminderAt'] as String),
      createdAt:
          DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt:
          DateTime.tryParse(map['updatedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class NoteModel {
  final int? id;
  final String title;
  final String content;
  final String createdAt;
  final String label;

  /// Work, Personal, Shopping, etc.
  final bool isFavorite;

  NoteModel({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.label = 'Personal',
    this.isFavorite = false,
  });

  /// Map to Note Object (Database -> Flutter)
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      createdAt: map['createdAt'] as String,
      label: map['label'] as String? ?? 'Personal',
      isFavorite: (map['isFavorite'] as int? ?? 0) == 1,
    );
  }

  /// Note Object to Map (Flutter -> Database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt,
      'label': label,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  /// Formatting ID for UI display (e.g., NOTE-001)
  String get formattedId {
    if (id == null) return 'NOTE-000';
    return 'NOTE-${id.toString().padLeft(3, '0')}';
  }
}

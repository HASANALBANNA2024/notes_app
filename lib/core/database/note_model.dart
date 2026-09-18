class NoteModel {
  final int? id;
  final String title;
  final String content;
  final String createdAt;
  final bool isFavorite;
  final bool isPinned; // 📌 Pin state
  final bool isLocked; // 🔒 Lock state

  NoteModel({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.isFavorite = false,
    this.isPinned = false,
    this.isLocked = false,
  });

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      createdAt: map['createdAt'] as String,
      isFavorite: (map['isFavorite'] as int? ?? 0) == 1,
      isPinned: (map['isPinned'] as int? ?? 0) == 1,
      isLocked: (map['isLocked'] as int? ?? 0) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt,
      'isFavorite': isFavorite ? 1 : 0,
      'isPinned': isPinned ? 1 : 0,
      'isLocked': isLocked ? 1 : 0,
    };
  }
}

/// Preset background colors a note can be tagged with, picked in
/// NoteEditScreen and rendered on NoteCard. The first entry means
/// "no color" (falls back to the theme's default card color).
const int kNoNoteColor = 0xFFFFFFFF;

const List<int> kNoteColorSwatches = [
  kNoNoteColor,
  0xFFDFF5F3, // teal tint
  0xFFFCEFD9, // amber tint
  0xFFFBE1E5, // red tint
  0xFFE1F5E8, // green tint
  0xFFE1EAFB, // blue tint
];

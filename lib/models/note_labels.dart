/// A fixed, simple label taxonomy — good enough for a small local notes
/// app without needing a whole "manage categories" CRUD flow.
class LabelPreset {
  final String emoji;
  final String name;
  const LabelPreset(this.emoji, this.name);
}

const List<LabelPreset> kLabelPresets = [
  LabelPreset('📌', 'Work'),
  LabelPreset('🏠', 'Personal'),
  LabelPreset('🛒', 'Shopping'),
  LabelPreset('📚', 'Learning'),
  LabelPreset('⭐', 'Favorites'),
];

/// Looks up the preset (emoji + name) for a note's stored label name.
/// Returns null if the note has no label or the label isn't a known preset.
LabelPreset? findLabelPreset(String? name) {
  if (name == null) return null;
  for (final preset in kLabelPresets) {
    if (preset.name == name) return preset;
  }
  return null;
}

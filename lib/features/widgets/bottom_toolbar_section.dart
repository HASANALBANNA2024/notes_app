import 'package:flutter/material.dart';

import '../../controllers/note_form_controller.dart';
import 'note_bottom_toolbar.dart';

class BottomToolbarSection extends StatelessWidget {
  final NoteFormController formController;

  const BottomToolbarSection({
    super.key,
    required this.formController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        formController.isPinnedNotifier,
        formController.isFavoriteNotifier,
      ]),
      builder: (context, _) {
        debugPrint("BottomToolbar Only Rebuilt!");
        return NoteBottomToolbar(
          isPinned: formController.isPinnedNotifier.value,
          isFavorite: formController.isFavoriteNotifier.value,
          onPinTap: formController.togglePin,
          onFavoriteTap: formController.toggleFavorite,
        );
      },
    );
  }
}

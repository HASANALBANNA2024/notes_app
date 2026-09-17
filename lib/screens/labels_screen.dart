import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../bloc/notes_state.dart';
import '../models/note_labels.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/app_icon_button.dart';
import '../widgets/app_top_bar.dart';

class LabelsScreen extends StatelessWidget {
  final VoidCallback onLabelSelected;

  const LabelsScreen({super.key, required this.onLabelSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: 'Labels',
        actions: [
          AppIconButton(
            icon: Icons.add,
            tooltip: 'Labels are preset in this app',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Labels are preset for this app')),
            ),
          ),
        ],
      ),
      body: BlocBuilder<NotesBloc, NotesState>(
        buildWhen: (previous, current) => previous.allNotes != current.allNotes,
        builder: (context, state) {
          return ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: kLabelPresets.length,
            itemBuilder: (context, index) {
              final preset = kLabelPresets[index];
              final count = state.allNotes.where((n) => n.label == preset.name).length;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  onTap: () {
                    context.read<NotesBloc>().add(FilterByLabel(preset.name));
                    onLabelSelected();
                  },
                  child: Row(
                    children: [
                      Text('${preset.emoji} ${preset.name}',
                          style: AppText.sora(size: 13.5, weight: FontWeight.w600)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.chipBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('$count',
                            style: AppText.inter(size: 11, weight: FontWeight.w700, color: AppColors.accent)),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

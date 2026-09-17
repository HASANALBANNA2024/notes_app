import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../bloc/theme_cubit.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/app_top_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Settings'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, mode) {
                return _SettingsRow(
                  label: 'Dark mode',
                  trailing: Switch(
                    activeColor: AppColors.accent,
                    value: mode == ThemeMode.dark,
                    onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                  ),
                );
              },
            ),
            _SettingsRow(
              label: 'Clear all notes',
              labelColor: AppColors.red,
              trailing:
                  const Icon(Icons.chevron_right, color: AppColors.textMuted),
              onTap: () => _confirmClearAll(context),
            ),
            const _SettingsRow(
              label: 'Notes App',
              value: 'Local-only notes, built with Flutter + BLoC',
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmClearAll(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear all notes?'),
        content: const Text(
            'This will permanently delete every note. This cannot be undone.'),
        actions: [
          AppButton(
            label: 'Cancel',
            variant: AppButtonVariant.outlined,
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          AppButton(
            label: 'Clear all',
            variant: AppButtonVariant.danger,
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<NotesBloc>().add(const ClearAllNotes());
    }
  }
}

class _SettingsRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? trailing;
  final Color? labelColor;
  final bool isLast;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.label,
    this.value,
    this.trailing,
    this.labelColor,
    this.isLast = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: AppText.sora(
                  size: 13,
                  weight: FontWeight.w600,
                  color: labelColor ?? AppColors.text),
            ),
            const Spacer(),
            if (value != null)
              Flexible(
                child: Text(
                  value!,
                  textAlign: TextAlign.right,
                  style: AppText.inter(size: 12, color: AppColors.textMuted),
                ),
              ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

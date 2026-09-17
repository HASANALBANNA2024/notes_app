import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/notes_bloc.dart';
import 'bloc/notes_event.dart';
import 'bloc/theme_cubit.dart';
import 'services/note_repository.dart';

class AppBlocProvider extends StatelessWidget {
  final Widget child;

  const AppBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Theme (dark mode) state, loaded from persisted preference.
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit()..loadTheme(),
        ),
        // Notes state, backed by NoteRepository (SQLite via sqflite).
        BlocProvider<NotesBloc>(
          create: (_) =>
              NotesBloc(repository: NoteRepository())..add(const LoadNotes()),
        ),
      ],
      child: child,
    );
  }
}

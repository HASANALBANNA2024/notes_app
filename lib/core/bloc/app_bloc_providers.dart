import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/core/bloc/bottom_navigation_navber/nav_bloc.dart';
import 'package:notes_app/core/bloc/note/note_bloc.dart';
import 'package:notes_app/core/bloc/note/note_event.dart';

class AppBlocProviders {
  static get allBlocProviders => [
        BlocProvider<NavBloc>(create: (context) => NavBloc()),
        BlocProvider<NoteBloc>(
            create: (context) => NoteBloc()..add(LoadNotesEvent())),
      ];
}

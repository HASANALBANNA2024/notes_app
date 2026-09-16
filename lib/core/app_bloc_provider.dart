import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/core/bloc/add_bloc.dart';
import 'package:notes_app/core/bloc/notes_bloc.dart';

class AppBlocProvider extends StatelessWidget {
  final Widget child;
  const AppBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ///add bloc provider
        BlocProvider<AddBloc>(create: (context) => AddBloc()),
        BlocProvider<NotesBloc>(create: (context) => NotesBloc()),
      ],
      child: child,
    );
  }
}

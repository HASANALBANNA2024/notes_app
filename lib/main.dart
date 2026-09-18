import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/core/bloc/app_bloc_providers.dart';
import 'package:notes_app/dashboard.dart';

void main() {
  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBlocProviders.allBlocProviders,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        theme: ThemeData(
            useMaterial3: true, scaffoldBackgroundColor: Colors.white),
        home: const Dashboard(),
      ),
    );
  }
}

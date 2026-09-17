import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_bloc_provider.dart';
import 'bloc/theme_cubit.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const AppBlocProvider(
      child: NotesApp(),
    ),
  );
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        return MaterialApp(
          title: 'Notes App',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: AppTheme.buildTheme(brightness: Brightness.light),
          darkTheme: AppTheme.buildTheme(brightness: Brightness.dark),
          home: const SplashScreen(),
        );
      },
    );
  }
}

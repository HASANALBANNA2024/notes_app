import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/core/bloc/bottom_navigation_navber/nav_bloc.dart';

class AppBlocProviders {
  static get allBlocProviders => [
        BlocProvider<NavBloc>(create: (context) => NavBloc()),
      ];
}

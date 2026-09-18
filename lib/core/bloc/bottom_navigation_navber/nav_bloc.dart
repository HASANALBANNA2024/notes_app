import 'package:flutter_bloc/flutter_bloc.dart';

import 'nav_event.dart';
import 'nav_state.dart';

class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc() : super(NavState(0)) {
    on<TabChangedEvent>((event, emit) {
      emit(NavState(event.tabIndex));
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/core/widgets/note_sheet_helper.dart';
import 'package:notes_app/features/home_screen/home_screen.dart';

import 'core/bloc/bottom_navigation_navber/nav_bloc.dart';
import 'core/bloc/bottom_navigation_navber/nav_event.dart';
import 'core/bloc/bottom_navigation_navber/nav_state.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBloc, NavState>(
      builder: (context, state) {
        final currentTabIndex = state.selectedIndex;

        return Scaffold(
          body: _getSelectedScreenBody(currentTabIndex),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex:
                currentTabIndex >= 1 ? currentTabIndex + 1 : currentTabIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              if (index == 1) {
                ///  Add click: NewNoteScreen
                NoteSheetHelper.openNoteBottomSheet(context);
              } else {
                /// Tab Switch via NavBloc
                final targetIndex = index > 1 ? index - 1 : index;
                context.read<NavBloc>().add(TabChangedEvent(targetIndex));
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.notes_outlined),
                activeIcon: Icon(Icons.notes),
                label: 'Notes',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle, size: 38, color: Colors.blue),
                label: 'Add',
              ),
            ],
          ),
        );
      },
    );
  }

  /// Active Tab Body
  Widget _getSelectedScreenBody(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const Center(child: Text('Labels Screen Content'));
      case 2:
        return const Center(child: Text('Settings Screen Content'));
      default:
        return const Center(child: Text('Notes List Screen'));
    }
  }
}

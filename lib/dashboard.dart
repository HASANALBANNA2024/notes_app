import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/database/note_model.dart';
import 'core/bloc/bottom_navigation_navber/nav_bloc.dart';
import 'core/bloc/bottom_navigation_navber/nav_event.dart';
import 'core/bloc/bottom_navigation_navber/nav_state.dart';
import 'features/new_note/new_note_screen.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  /// 🚀 Full-Screen Bottom Sheet Launcher
  void _openNoteBottomSheet(BuildContext context, {NoteModel? note}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 📌 Full screen sheet enable kore
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(modalContext).padding.top + 10,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: NewNoteScreen(note: note), // 📌 New Note Screen call
          ),
        );
      },
    );
  }

  /// Active Tab Body
  Widget _getSelectedScreenBody(int index) {
    switch (index) {
      case 0:
        return const Center(child: Text('Notes List Screen'));
      case 1:
        return const Center(child: Text('Labels Screen Content'));
      case 2:
        return const Center(child: Text('Settings Screen Content'));
      default:
        return const Center(child: Text('Notes List Screen'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBloc, NavState>(
      builder: (context, state) {
        final currentTabIndex = state.selectedIndex;

        return Scaffold(
          body: _getSelectedScreenBody(currentTabIndex),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex:
                currentTabIndex >= 2 ? currentTabIndex + 1 : currentTabIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              if (index == 2) {
                ///  Add click: NewNoteScreen নিচ থেকে ভেসে উঠবে
                _openNoteBottomSheet(context);
              } else {
                /// Tab Switch via NavBloc
                final targetIndex = index > 2 ? index - 1 : index;
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
                icon: Icon(Icons.label_outline),
                activeIcon: Icon(Icons.label),
                label: 'Labels',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle,
                    size: 38, color: Colors.blue), // 📌 Main Add Button
                label: 'Add',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}

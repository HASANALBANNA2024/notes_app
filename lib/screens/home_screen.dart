import 'package:flutter/material.dart';

import '../widgets/app_bottom_nav.dart';
import 'labels_screen.dart';
import 'notes_tab.dart';
import 'reminders_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _goToNotesTab() => setState(() => _currentIndex = 0);

  static const _navItems = [
    AppBottomNavItem(Icons.edit_note_rounded, 'Notes'),
    AppBottomNavItem(Icons.folder_outlined, 'Labels'),
    AppBottomNavItem(Icons.alarm_outlined, 'Reminders'),
    AppBottomNavItem(Icons.settings_outlined, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const NotesTab(),
      LabelsScreen(onLabelSelected: _goToNotesTab),
      const RemindersScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: tabs),
      bottomNavigationBar: AppBottomNav(
        items: _navItems,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getSelectedScreenBody(),
    );
  }

  /// screen call
  Widget _getSelectedScreenBody() {
    switch (_currentTabIndex) {
      case 0:

        /// const NoteScreenBody();
        return const Center(child: Text('Note Screen Content'));
      case 1:
        return const Center(child: Text('Labels Screen Content'));
      case 2:
        return const Center(child: Text('Add New Note Content'));
      case 3:
        return const Center(child: Text('Settings Screen Content'));
      default:
        return const Center(child: Text('Note Screen Content'));
    }
  }
}

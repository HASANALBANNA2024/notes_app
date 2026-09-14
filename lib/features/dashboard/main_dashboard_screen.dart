import 'package:flutter/material.dart';
import 'package:notes_app/core/widgets/app_bottom_nav_bar.dart';

import '../screens/home_screen.dart';

class MainDashboardScreen extends StatefulWidget{
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}
class _MainDashboardScreenState extends State<MainDashboardScreen>{

  int _currentIndex = 0;
  final List<Widget> _screens = const [
    HomeScreen(),
    // LabelsScreen(),
    // RemindersScreen(),
    // SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: _currentIndex, onTap: (index){
        setState(() {
          _currentIndex = index;
        });
      }),
    );
  }
}
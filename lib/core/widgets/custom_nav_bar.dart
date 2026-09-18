import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/core/bloc/bottom_navigation_navber/nav_bloc.dart';
import 'package:notes_app/core/bloc/bottom_navigation_navber/nav_event.dart';
import 'package:notes_app/core/bloc/bottom_navigation_navber/nav_state.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBloc, NavState>(builder: (context, state) {
      return SafeArea(
        bottom: true,
        child: Container(
          height: 65,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Color(0xFFE3E6EC), width: 1),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: state.selectedIndex,
            onTap: (index) {
              context.read<NavBloc>().add(TabChangedEvent(index));
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF0EA5A0),
            unselectedItemColor: const Color(0xFF6B7280),
            selectedFontSize: 11,
            unselectedFontSize: 11,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.description_outlined),
                  activeIcon: Icon(Icons.description),
                  label: 'Notes'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.folder_open_rounded),
                  activeIcon: Icon(Icons.folder_rounded),
                  label: 'Labels'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline_rounded),
                  activeIcon: Icon(Icons.add_circle_rounded),
                  label: 'Add'),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ),
      );
    });
  }
}

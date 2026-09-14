import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget{
  final int currentIndex;
  final Function(int) onTap;
  const AppBottomNavBar({super.key, required this.currentIndex, required this.onTap});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: const BoxDecoration(
        color: Colors.white,
         border: Border(
           top: BorderSide(color: Color(0xFFE3E6EC), width: 1),
         )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(index: 0, icon: Icons.edit_note_rounded, label: "Notes"),
          _buildNavItem(index: 1, icon: Icons.folder_open_rounded, label: "Labels"),
          _buildNavItem(index: 2, icon: Icons.alarm_rounded, label: "Reminders"),
          _buildNavItem(index: 3, icon: Icons.settings_outlined, label: "Settings"),
        ],
      ),
    );
  }
  Widget _buildNavItem({required int index,required IconData icon, required String label}){
    final isSelected  = currentIndex ==index;
    final color = isSelected ? const Color(0xFF0EA5A0) : const Color(0xFF6B7280);
    return InkWell(
      onTap: ()=> onTap(index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24,),
          const SizedBox(height: 4,),
          Text(label, style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: color
          ),)
        ],
      ),
    );
  }
}
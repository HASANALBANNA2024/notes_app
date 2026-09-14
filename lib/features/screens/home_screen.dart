import 'package:flutter/material.dart';
import 'package:notes_app/core/widgets/app_icon_button.dart';
import 'package:notes_app/core/widgets/custom_app_bar.dart';
import '../../../core/widgets/screen_background.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,

        ///Custom AppBar 
        appBar: CustomAppBar(title: "Notes", 
        actions: [
          AppIconButton(icon: Icons.search_rounded,backgroundColor: Color(0xFFF3F4F7), iconColor: Color(0xFF161B26),iconSize: 16,onTap: (){}),
          AppIconButton(icon: Icons.more_vert, backgroundColor: Color(0xFFF3F4F7), iconColor: Colors.black45,iconSize: 16,onTap: (){})
        ],
        ),

        // Content
        body: const Center(
          child: Text(
            'Home Screen Content',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF161B26),
            ),
          ),
        ),

        /// Floating Action Button 
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF0EA5A0),
          elevation: 4,
          shape: const CircleBorder(),
          onPressed: () {
            ///New Work Or notes add
          },
          child: const Icon(
            Icons.edit_outlined,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}
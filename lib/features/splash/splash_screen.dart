import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notes_app/features/dashboard/main_dashboard_screen.dart';
import '../../../core/widgets/screen_background.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/app_icon.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainDashboardScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0EA5A0),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0EA5A0).withOpacity(0.4),
                        blurRadius: 25,
                        spreadRadius: 2,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: AppIcon(
                      icon: Icons.edit_note_rounded,
                      size: 58,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const AppText(
                 'Notes',
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              const AppText(
               'Keep Your Ideas Organized',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Color(0xFF94A3B8),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                      (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0EA5A0),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              const AppText(
                 'v1.0.0',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
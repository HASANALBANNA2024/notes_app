import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_app/core/service/database_helper.dart';
import 'package:notes_app/core/service/notification_service.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    /// ✅ FIX #7: sqflite DATABASE initialization with error handling
    await DatabaseHelper.instance.database;
    print('✅ Database initialized successfully');
  } catch (e) {
    print('❌ Database initialization error: $e');
    // Log error but continue - app can still run in limited capacity
  }

  try {
    /// ✅ FIX #7: Notification Service initialization with error handling
    await NotificationService().init();
    print('✅ Notification service initialized successfully');
  } catch (e) {
    print('❌ Notification service initialization error: $e');
    // Log error but continue - app can run without notifications
  }

  try {
    /// ✅ System UI styling
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  } catch (e) {
    print('⚠️ System UI styling error: $e');
    // Non-critical error, continue
  }

  runApp(const App());
}

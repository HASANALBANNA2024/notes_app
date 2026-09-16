import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_app/core/service/database_helper.dart';
import 'package:notes_app/core/service/notification_service.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// sqflite DATABASE initialization
  await DatabaseHelper.instance.database;
  await NotificationService().init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const App());
}

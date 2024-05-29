//import 'package:enhanced_school_attendance_system_fyp/view/login.dart';

import 'package:flutter/material.dart';
import 'package:school_attendance_system_fyp/view/startPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',

      home: startPage(),
    );
  }
}

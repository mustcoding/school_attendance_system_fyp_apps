//import 'package:enhanced_school_attendance_system_fyp/view/login.dart';

import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:school_attendance_system_fyp/view/startPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.Debug.setAlertLevel(OSLogLevel.none);
  OneSignal.initialize("78f2e497-f306-4a96-9f47-c0ae59591675");
  OneSignal.Notifications.requestPermission(true);
  OneSignal.Notifications.addPermissionObserver((state) {
    print("Has permission " + state.toString());
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
      home: startPage(),
    );
  }
}

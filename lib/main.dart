import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:video_recorder/screens/home_page.dart';
import 'package:video_recorder/screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:video_recorder/screens/otp_page.dart';
import 'package:video_recorder/screens/posted_successfully.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Test Assignment',
      home: LoginPage(),
    );
  }
}

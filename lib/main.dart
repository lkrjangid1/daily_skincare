import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:skincare/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skincare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff964F66)),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: const SplashScreen(),
    );
  }
}

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skincare/presentation/screens/auth/sign_in_page.dart';
import 'package:skincare/presentation/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    super.initState();
    changeScreen();
  }

  changeScreen() {
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return FirebaseAuth.instance.currentUser != null
                ? const HomeScreen()
                : const SignInPage();
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text(
        "Daily Skin Care",
        style: TextStyle(
          fontSize: 30,
        ),
      )),
    );
  }
}

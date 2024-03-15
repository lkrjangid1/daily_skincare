import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skincare/presentation/screens/routine_screen.dart';
import 'package:skincare/presentation/screens/streaks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  void onTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List<Widget> pages = [
    const RoutineScreen(),
    const StreaksScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: 'Routine',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.group),
            label: 'Streaks',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onTap,
      ),
      body: pages[selectedIndex],
    );
  }
}

import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _HomePageState();
}

class _HomePageState extends State<Dashboard> {
int _currentIndex = 0;
final List<Widget> _pages = [
  HomeScreen(),
  HomeScreen(),
  HomeScreen(),
  // ProfileScreen(),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_currentIndex],

      bottomNavigationBar: CrystalNavigationBar(
        currentIndex: _currentIndex,
        height: 10,
        // indicatorColor: Colors.blue,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.black.withOpacity(0.1),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          CrystalNavigationBarItem(
            icon: Icons.home,
            unselectedIcon: Icons.home,
            selectedColor: Colors.white,
          ),
          CrystalNavigationBarItem(
            icon: Icons.add,
            unselectedIcon: Icons.add,
            selectedColor: Colors.red,
          ),

          CrystalNavigationBarItem(
            icon: Icons.plumbing,
            unselectedIcon: Icons.plumbing,
            selectedColor: Colors.white,
          ),

        ],
      ),
    );
  }
}
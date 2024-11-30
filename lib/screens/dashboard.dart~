import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _HomePageState();
}

class _HomePageState extends State<Dashboard> {
  // var _SelectedTab { home, favorite, add, search, person }
  // var _selectedTab = _SelectedTab.home;
int _currentIndex = 0;
  // void _handleIndexChanged(int i) {
  //   setState(() {
  //     _selectedTab = _SelectedTab.values[i];
  //   });
  // }
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
      // SizedBox(
      //   height: MediaQuery.of(context).size.height,
      //   child: Image.network(
      //     "https://mrahkat.net/wp-content/uploads/2019/07/unnamed-file-416.jpg",
      //     fit: BoxFit.fitHeight,
      //   ),
      // ),

      bottomNavigationBar: CrystalNavigationBar(
        currentIndex: _currentIndex,
        height: 10,
        // indicatorColor: Colors.blue,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.black.withOpacity(0.1),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 4,
        //     spreadRadius: 4,
        //     offset: Offset(0, 10),
        //   ),
        // ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          /// Home
          CrystalNavigationBarItem(
            icon: Icons.home,
            unselectedIcon: Icons.home,
            selectedColor: Colors.white,
          ),

          /// Favourite
          CrystalNavigationBarItem(
            icon: Icons.add,
            unselectedIcon: Icons.add,
            selectedColor: Colors.red,
          ),

          /// Add
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
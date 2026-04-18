import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/activity_screen.dart';
import 'screens/weight_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const MyApp());
}
// the stateless widget here is the root widget of the application!!!
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override // this is the build method of the stateless widget
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness App',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF20D6C7),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F8FA),
          elevation: 0,
          centerTitle: false,
          foregroundColor: Colors.black,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF20D6C7),
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      home: const MainScreen(),
    );
  }
}
// the stateful widget here is the main screen of the application!!!
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override // this is the build method of the stateful widget
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0; // this index tells us which screen to display currently it is 0 so it will display the home screen

  final List<Widget> screens = const [
    HomeScreen(),
    ActivityScreen(),
    WeightScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];
// below is the bottom navigation bar of the application contains 5 tabs 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk_outlined),
            activeIcon: Icon(Icons.directions_walk),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_weight_outlined),
            activeIcon: Icon(Icons.monitor_weight),
            label: 'Weight',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
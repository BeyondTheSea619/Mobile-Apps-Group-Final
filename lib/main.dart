import "package:flutter/material.dart";

void main() {
  runApp(MyApp());
}

// Returns the MaterialApp
class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainScreen());
  }
}

// Returns the Scaffold
class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> _pages = [];
  // List<BottomNavigationBarItem> itemsList = [
  //   BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
  //   BottomNavigationBarItem(icon: Icon(Icons.directions_walk), label: "Steps"),
  //   BottomNavigationBarItem(
  //     icon: Icon(Icons.sports_gymnastics_sharp),
  //     label: "Exercise",
  //   ),

  //   BottomNavigationBarItem(icon: Icon(Icons.settings), label: "settings"),
  //   BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
  // ];
  int index = 0;
  // List<Widget> _pages = [HomePage(), StepsPage(),ExercisePage(),SettingsPage(),ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar title is updated to "Login Screen"
      appBar: AppBar(title: Text("Title goes here")),
      body: _pages[index],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        fixedColor: Colors.black87,
        useLegacyColorScheme: false,
        unselectedLabelStyle: TextStyle(color: Colors.black87),
        // backgroundColor: Colors.amber,
        onTap: (value) => setState(() {
          index = value;
        }),
        currentIndex: index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk),
            label: "Health",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_gymnastics_sharp),
            label: "Exercise",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "settings",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

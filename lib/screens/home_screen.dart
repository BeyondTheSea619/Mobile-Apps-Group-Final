import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/database_services.dart';
import '../models/activity.dart';
import '../models/user.dart';
import '../models/weight.dart';
import 'add_activity_screen.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;

  User? currentUser;
  Weight? latestWeight;

  int todaySteps = 0;
  double todayCalories = 0;
  double todayDistance = 0;

  int dailyGoal = 10000;
  double waterGoal = 2.0;
  String preferredActivity = 'Walking';

  @override
  void initState() {
    super.initState();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    setState(() {
      isLoading = true;
    });

    final userData = await DatabaseServices.getFirstUser();
    final weightData = await DatabaseServices.getAllWeights();
    final activityData = await DatabaseServices.getAllActivities();
    final prefs = await SharedPreferences.getInstance();

    User? loadedUser;
    Weight? loadedWeight;

    int steps = 0;
    double calories = 0;
    double distance = 0;

    if (userData != null) {
      loadedUser = User.fromMap(userData);
    }

    if (weightData.isNotEmpty) {
      loadedWeight = Weight.fromMap(weightData.first);
    }

    DateTime now = DateTime.now();

    for (int i = 0; i < activityData.length; i++) {
      Activity activity = Activity.fromMap(activityData[i]);
      DateTime activityDate = DateTime.parse(activity.activityDate);

      if (activityDate.year == now.year &&
          activityDate.month == now.month &&
          activityDate.day == now.day) {
        steps = steps + activity.steps;
        calories = calories + activity.calories;
        distance = distance + activity.distance;
      }
    }

    setState(() {
      currentUser = loadedUser;
      latestWeight = loadedWeight;

      todaySteps = steps;
      todayCalories = calories;
      todayDistance = distance;

      dailyGoal = prefs.getInt('step_goal') ?? loadedUser?.targetSteps ?? 10000;
      waterGoal = prefs.getDouble('water_goal') ?? 2.0;
      preferredActivity = prefs.getString('preferred_activity') ?? 'Walking';

      isLoading = false;
    });
  }

  Future<void> openAddActivityScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddActivityScreen(),
      ),
    );

    if (result == true) {
      loadHomeData();
    }
  }

  Future<void> openMapScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapScreen(),
      ),
    );

    loadHomeData();
  }

  String getWeekDay(int day) {
    if (day == 1) {
      return 'Mon';
    } else if (day == 2) {
      return 'Tue';
    } else if (day == 3) {
      return 'Wed';
    } else if (day == 4) {
      return 'Thu';
    } else if (day == 5) {
      return 'Fri';
    } else if (day == 6) {
      return 'Sat';
    } else {
      return 'Sun';
    }
  }

  String getMonth(int month) {
    if (month == 1) {
      return 'Jan';
    } else if (month == 2) {
      return 'Feb';
    } else if (month == 3) {
      return 'Mar';
    } else if (month == 4) {
      return 'Apr';
    } else if (month == 5) {
      return 'May';
    } else if (month == 6) {
      return 'Jun';
    } else if (month == 7) {
      return 'Jul';
    } else if (month == 8) {
      return 'Aug';
    } else if (month == 9) {
      return 'Sep';
    } else if (month == 10) {
      return 'Oct';
    } else if (month == 11) {
      return 'Nov';
    } else {
      return 'Dec';
    }
  }

  @override
  Widget build(BuildContext context) {
    String titleText = 'Fitness Dashboard';
    String weightText = '--';

    DateTime now = DateTime.now();
    String todayDate =
        '${getWeekDay(now.weekday)}, ${now.day} ${getMonth(now.month)}';

    if (currentUser != null && currentUser!.name.trim().isNotEmpty) {
      titleText = 'Hi, ${currentUser!.name}';
    }

    if (latestWeight != null) {
      weightText = '${latestWeight!.weight} kg';
    } else if (currentUser != null) {
      weightText = '${currentUser!.weight} kg';
    }

    double progressValue = 0;
    if (dailyGoal > 0) {
      progressValue = todaySteps / dailyGoal;
      if (progressValue > 1) {
        progressValue = 1;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF20D6C7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.white,
                              backgroundImage: currentUser != null &&
                                      currentUser!.profileImagePath.isNotEmpty
                                  ? FileImage(
                                      File(currentUser!.profileImagePath),
                                    )
                                  : null,
                              child: currentUser == null ||
                                      currentUser!.profileImagePath.isEmpty
                                  ? const Icon(
                                      Icons.person,
                                      color: Color(0xFF20D6C7),
                                      size: 28,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    titleText,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    todayDate,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Daily Goal Progress',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: progressValue,
                          minHeight: 10,
                          backgroundColor: Colors.white30,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$todaySteps / $dailyGoal steps',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Today Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.directions_walk,
                                  color: Colors.teal,
                                  size: 28,
                                ),
                                const SizedBox(height: 8),
                                const Text('Steps'),
                                const SizedBox(height: 6),
                                Text(
                                  todaySteps.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text('Today'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.local_fire_department,
                                  color: Colors.red,
                                  size: 28,
                                ),
                                const SizedBox(height: 8),
                                const Text('Calories'),
                                const SizedBox(height: 6),
                                Text(
                                  todayCalories.toStringAsFixed(0),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text('Burned'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.map,
                                  color: Colors.indigo,
                                  size: 28,
                                ),
                                const SizedBox(height: 8),
                                const Text('Distance'),
                                const SizedBox(height: 6),
                                Text(
                                  '${todayDistance.toStringAsFixed(1)} km',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text('Today'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.monitor_weight,
                                  color: Colors.blue,
                                  size: 28,
                                ),
                                const SizedBox(height: 8),
                                const Text('Weight'),
                                const SizedBox(height: 6),
                                Text(
                                  weightText,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text('Latest'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: openAddActivityScreen,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Activity'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF20D6C7),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: openMapScreen,
                          icon: const Icon(Icons.location_on),
                          label: const Text('Open Map'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF20D6C7),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Fitness Details',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.flag),
                            title: const Text('Step Goal'),
                            subtitle: Text('$dailyGoal steps'),
                          ),
                          ListTile(
                            leading: const Icon(Icons.water_drop),
                            title: const Text('Water Goal'),
                            subtitle: Text('${waterGoal.toStringAsFixed(1)} L'),
                          ),
                          ListTile(
                            leading: const Icon(Icons.fitness_center),
                            title: const Text('Preferred Activity'),
                            subtitle: Text(preferredActivity),
                          ),
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: const Text('Profile Name'),
                            subtitle: Text(
                              currentUser?.name ?? 'No profile saved',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
    );
  }
}
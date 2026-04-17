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
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      final userMap = await DatabaseServices.getFirstUser();
      if (userMap != null) {
        currentUser = User.fromMap(userMap);
      }

      final weightData = await DatabaseServices.getAllWeights();
      if (weightData.isNotEmpty) {
        latestWeight = Weight.fromMap(weightData.first);
      }

      final activityData = await DatabaseServices.getAllActivities();
      final now = DateTime.now();

      int tempSteps = 0;
      double tempCalories = 0;
      double tempDistance = 0;

      for (var item in activityData) {
        try {
          final activity = Activity.fromMap(item);
          final activityDate = DateTime.parse(activity.activityDate);

          if (activityDate.year == now.year &&
              activityDate.month == now.month &&
              activityDate.day == now.day) {
            tempSteps += activity.steps;
            tempCalories += activity.calories;
            tempDistance += activity.distance;
          }
        } catch (e) {
          // ignore bad data
        }
      }

      final prefs = await SharedPreferences.getInstance();

      dailyGoal = prefs.getInt('step_goal') ?? currentUser?.targetSteps ?? 10000;
      waterGoal = prefs.getDouble('water_goal') ?? 2.0;
      preferredActivity = prefs.getString('preferred_activity') ?? 'Walking';

      if (mounted) {
        setState(() {
          todaySteps = tempSteps;
          todayCalories = tempCalories;
          todayDistance = tempDistance;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Dashboard load error: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  double get progressValue {
    if (dailyGoal == 0) return 0;
    double progress = todaySteps / dailyGoal;
    if (progress > 1) return 1;
    return progress;
  }

  String get welcomeName {
    if (currentUser == null || currentUser!.name.trim().isEmpty) {
      return 'Fitness Dashboard';
    }
    return 'Hi, ${currentUser!.name}';
  }

  String get latestWeightText {
    if (latestWeight != null) {
      return '${latestWeight!.weight} kg';
    }

    if (currentUser != null) {
      return '${currentUser!.weight} kg';
    }

    return '--';
  }

  String get todayDateText {
    final now = DateTime.now();
    return '${getWeekDay(now.weekday)}, ${now.day} ${getMonth(now.month)}';
  }

  String getWeekDay(int day) {
    if (day == 1) return 'Mon';
    if (day == 2) return 'Tue';
    if (day == 3) return 'Wed';
    if (day == 4) return 'Thu';
    if (day == 5) return 'Fri';
    if (day == 6) return 'Sat';
    return 'Sun';
  }

  String getMonth(int month) {
    if (month == 1) return 'Jan';
    if (month == 2) return 'Feb';
    if (month == 3) return 'Mar';
    if (month == 4) return 'Apr';
    if (month == 5) return 'May';
    if (month == 6) return 'Jun';
    if (month == 7) return 'Jul';
    if (month == 8) return 'Aug';
    if (month == 9) return 'Sep';
    if (month == 10) return 'Oct';
    if (month == 11) return 'Nov';
    return 'Dec';
  }

  Future<void> openAddActivityScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddActivityScreen(),
      ),
    );

    if (result == true) {
      loadDashboardData();
    }
  }

  Future<void> openMapScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapScreen(),
      ),
    );

    loadDashboardData();
  }

  Widget buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: color.withOpacity(0.12),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFE8FBF8),
                child: Icon(
                  icon,
                  color: const Color(0xFF20D6C7),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFE8FBF8),
        child: Icon(
          icon,
          color: const Color(0xFF20D6C7),
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Today'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadDashboardData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF20D6C7),
                            Color(0xFF3CD3C5),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF20D6C7).withOpacity(0.25),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      welcomeName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      todayDateText,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Daily Goal Progress',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${(progressValue * 100).toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              value: progressValue,
                              minHeight: 10,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation(
                                Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '$todaySteps / $dailyGoal steps',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

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
                        buildStatCard(
                          title: 'Steps',
                          value: todaySteps.toString(),
                          subtitle: 'Today',
                          icon: Icons.directions_walk,
                          color: Colors.teal,
                        ),
                        buildStatCard(
                          title: 'Calories',
                          value: todayCalories.toStringAsFixed(0),
                          subtitle: 'Burned',
                          icon: Icons.local_fire_department,
                          color: Colors.redAccent,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        buildStatCard(
                          title: 'Distance',
                          value: '${todayDistance.toStringAsFixed(1)} km',
                          subtitle: 'Today',
                          icon: Icons.map,
                          color: Colors.indigo,
                        ),
                        buildStatCard(
                          title: 'Weight',
                          value: latestWeightText,
                          subtitle: 'Latest',
                          icon: Icons.monitor_weight_outlined,
                          color: Colors.blue,
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

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
                        buildActionButton(
                          icon: Icons.add_circle_outline,
                          label: 'Add Activity',
                          onTap: openAddActivityScreen,
                        ),
                        const SizedBox(width: 12),
                        buildActionButton(
                          icon: Icons.location_on_outlined,
                          label: 'Open Map',
                          onTap: openMapScreen,
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Fitness Insights',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 14),
                          buildInfoTile(
                            icon: Icons.flag_outlined,
                            title: 'Step Goal',
                            subtitle: '$dailyGoal steps',
                          ),
                          buildInfoTile(
                            icon: Icons.water_drop_outlined,
                            title: 'Water Goal',
                            subtitle: '${waterGoal.toStringAsFixed(1)} L',
                          ),
                          buildInfoTile(
                            icon: Icons.fitness_center,
                            title: 'Preferred Activity',
                            subtitle: preferredActivity,
                          ),
                          buildInfoTile(
                            icon: Icons.person_outline,
                            title: 'Profile Name',
                            subtitle:
                                currentUser?.name ?? 'No profile saved',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
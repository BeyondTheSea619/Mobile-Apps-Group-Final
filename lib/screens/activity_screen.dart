import 'package:flutter/material.dart';

import '../database/database_services.dart';
import '../models/activity.dart';
import '../widgets/activity_card.dart';
import 'add_activity_screen.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<Activity> activityList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadActivities();
  }

  Future<void> loadActivities() async {
    setState(() {
      isLoading = true;
    });

    final data = await DatabaseServices.getAllActivities();
    activityList = data.map((item) => Activity.fromMap(item)).toList();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteActivity(int id) async {
    await DatabaseServices.deleteActivity(id);
    await loadActivities();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Activity deleted')),
    );
  }

  void openAddActivityScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddActivityScreen(),
      ),
    );

    if (result == true) {
      loadActivities();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Activities'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF20D6C7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.fitness_center,
                    size: 35,
                    color: Color(0xFF20D6C7),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'My Activities',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Track and manage your daily workouts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : activityList.isEmpty
                    ? const Center(
                        child: Text(
                          'No activities added yet',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: loadActivities,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: activityList.length,
                          itemBuilder: (context, index) {
                            final activity = activityList[index];
                            return ActivityCard(
                              activity: activity,
                              onDelete: () {
                                if (activity.id != null) {
                                  deleteActivity(activity.id!);
                                }
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddActivityScreen,
        backgroundColor: const Color(0xFF20D6C7),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
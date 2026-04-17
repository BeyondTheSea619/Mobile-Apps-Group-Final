import 'package:flutter/material.dart';
import '../models/activity.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final VoidCallback onDelete;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.onDelete,
  });

  IconData getActivityIcon(String type) {
    if (type == 'Walking') {
      return Icons.directions_walk;
    } else if (type == 'Running') {
      return Icons.directions_run;
    } else if (type == 'Cycling') {
      return Icons.pedal_bike;
    } else {
      return Icons.fitness_center;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xFFE8FBF8),
          child: Icon(
            getActivityIcon(activity.type),
            color: const Color(0xFF20D6C7),
          ),
        ),
        title: Text(
          activity.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Type: ${activity.type}'),
              Text('Duration: ${activity.duration} min'),
              Text('Calories: ${activity.calories}'),
              Text('Steps: ${activity.steps}'),
              Text('Distance: ${activity.distance} km'),
              Text('Location: ${activity.location}'),
              if (activity.notes.isNotEmpty) Text('Notes: ${activity.notes}'),
            ],
          ),
        ),
        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
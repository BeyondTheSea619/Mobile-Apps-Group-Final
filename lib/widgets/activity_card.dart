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

  IconData getActivityIcon() {
    if (activity.type == 'Walking') {
      return Icons.directions_walk;
    } else if (activity.type == 'Running') {
      return Icons.directions_run;
    } else if (activity.type == 'Cycling') {
      return Icons.pedal_bike;
    } else {
      return Icons.fitness_center;
    }
  }
// this is a reusable widget that can be used to display any data on the dashboard
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE8FBF8),
          child: Icon(
            getActivityIcon(),
            color: const Color(0xFF20D6C7),
          ),
        ),
        title: Text(
          activity.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text('Type: ${activity.type}'),
            Text('Duration: ${activity.duration} min'),
            Text('Calories: ${activity.calories}'),
            Text('Steps: ${activity.steps}'),
            Text('Distance: ${activity.distance} km'),
            Text('Location: ${activity.location}'),
            // show notes only if user entered something
            if (activity.notes.isNotEmpty) Text('Notes: ${activity.notes}'),
          ],
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
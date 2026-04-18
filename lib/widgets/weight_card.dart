import 'package:flutter/material.dart';
import '../models/weight.dart';

class WeightCard extends StatelessWidget {
  final Weight weightItem;
  final VoidCallback onDelete;

  const WeightCard({
    super.key,
    required this.weightItem,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE8FBF8),
          child: Icon(
            Icons.monitor_weight,
            color: Color(0xFF20D6C7),
          ),
        ),
        title: Text(
          '${weightItem.weight} kg',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text('BMI: ${weightItem.bmi}'),
            Text('Date: ${weightItem.weightDate.split(' ').first}'),
            // show note only when user enters it
            if (weightItem.note.isNotEmpty) Text('Note: ${weightItem.note}'),
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
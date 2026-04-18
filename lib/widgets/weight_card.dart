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
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFFE8FBF8),
            child: Icon(
              Icons.monitor_weight,
              color: Color(0xFF20D6C7),
            ),
          ),
           SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${weightItem.weight} kg',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text('BMI: ${weightItem.bmi}'),
                Text('Date: ${weightItem.weightDate.split(" ").first}'),
                if (weightItem.note.isNotEmpty)
                  Text('Note: ${weightItem.note}'),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
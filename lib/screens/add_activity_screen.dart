import 'package:flutter/material.dart';

import '../database/database_services.dart';
import '../models/activity.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController stepsController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String selectedType = 'Walking';

  Future<void> saveActivity() async {
    if (formKey.currentState!.validate()) {
      Activity activity = Activity(
        title: titleController.text.trim(),
        type: selectedType,
        duration: int.parse(durationController.text.trim()),
        calories: double.parse(caloriesController.text.trim()),
        steps: int.parse(stepsController.text.trim()),
        distance: double.parse(distanceController.text.trim()),
        activityDate: DateTime.now().toString(),
        location: locationController.text.trim(),
        notes: notesController.text.trim(),
      );

      int result = await DatabaseServices.insertActivity(activity.toMap());

      if (!mounted) return;

      if (result > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Activity added successfully'),
          ),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not save activity'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    durationController.dispose();
    caloriesController.dispose();
    stepsController.dispose();
    distanceController.dispose();
    locationController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Add Activity'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 20),
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
                    'Track New Activity',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Save your workout details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Activity Title',
                      prefixIcon: const Icon(Icons.title),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Activity title is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Activity Type',
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Walking',
                          child: Text('Walking'),
                        ),
                        DropdownMenuItem(
                          value: 'Running',
                          child: Text('Running'),
                        ),
                        DropdownMenuItem(
                          value: 'Cycling',
                          child: Text('Cycling'),
                        ),
                        DropdownMenuItem(
                          value: 'Workout',
                          child: Text('Workout'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedType = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: durationController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Duration (minutes)',
                      prefixIcon: const Icon(Icons.timer),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Duration is required';
                      }
                      if (int.tryParse(value.trim()) == null) {
                        return 'Enter valid duration';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: caloriesController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Calories Burned',
                      prefixIcon: const Icon(Icons.local_fire_department),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Calories is required';
                      }
                      if (double.tryParse(value.trim()) == null) {
                        return 'Enter valid calories';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: stepsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Steps',
                      prefixIcon: const Icon(Icons.directions_walk),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Steps is required';
                      }
                      if (int.tryParse(value.trim()) == null) {
                        return 'Enter valid steps';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: distanceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Distance (km)',
                      prefixIcon: const Icon(Icons.map),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Distance is required';
                      }
                      if (double.tryParse(value.trim()) == null) {
                        return 'Enter valid distance';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      prefixIcon: const Icon(Icons.location_on),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Location is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  // notes can be optional
                  TextFormField(
                    controller: notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Notes',
                      prefixIcon: const Icon(Icons.note),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: saveActivity,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF20D6C7),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'Save Activity',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
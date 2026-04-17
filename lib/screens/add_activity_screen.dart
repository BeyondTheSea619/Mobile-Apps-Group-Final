import 'package:flutter/material.dart';

import '../database/database_services.dart';
import '../models/activity.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController stepsController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String selectedType = 'Walking';
  bool isSaving = false;

  Future<void> saveActivity() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    Activity newActivity = Activity(
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

    int result = await DatabaseServices.insertActivity(newActivity.toMap());

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

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

  String? emptyValidation(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? intValidation(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    if (int.tryParse(value.trim()) == null) {
      return 'Enter valid $fieldName';
    }

    return null;
  }

  String? doubleValidation(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    if (double.tryParse(value.trim()) == null) {
      return 'Enter valid $fieldName';
    }

    return null;
  }

  Widget buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
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
              key: _formKey,
              child: Column(
                children: [
                  buildTextField(
                    titleController,
                    'Activity Title',
                    Icons.title,
                    validator: (value) =>
                        emptyValidation(value, 'Activity title'),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    margin: const EdgeInsets.only(bottom: 15),
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
                  buildTextField(
                    durationController,
                    'Duration (minutes)',
                    Icons.timer,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        intValidation(value, 'duration'),
                  ),
                  buildTextField(
                    caloriesController,
                    'Calories Burned',
                    Icons.local_fire_department,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) =>
                        doubleValidation(value, 'calories'),
                  ),
                  buildTextField(
                    stepsController,
                    'Steps',
                    Icons.directions_walk,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        intValidation(value, 'steps'),
                  ),
                  buildTextField(
                    distanceController,
                    'Distance (km)',
                    Icons.map,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) =>
                        doubleValidation(value, 'distance'),
                  ),
                  buildTextField(
                    locationController,
                    'Location',
                    Icons.location_on,
                    validator: (value) =>
                        emptyValidation(value, 'location'),
                  ),
                  buildTextField(
                    notesController,
                    'Notes',
                    Icons.note,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSaving ? null : saveActivity,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF20D6C7),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        isSaving ? 'Saving...' : 'Save Activity',
                        style: const TextStyle(fontSize: 16),
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
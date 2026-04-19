import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../database/database_services.dart';
import '../models/activity.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  late FormGroup form;

  @override
  void initState() {
    super.initState();
    form = fb.group({
      'title': FormControl<String>(validators: [Validators.required]),
      'type': FormControl<String>(value: 'Walking', validators: [Validators.required]),
      'duration': FormControl<String>(validators: [Validators.required, Validators.number]),
      'calories': FormControl<String>(validators: [Validators.required, Validators.number]),
      'steps': FormControl<String>(validators: [Validators.required, Validators.number]),
      'distance': FormControl<String>(validators: [Validators.required, Validators.number]),
      'location': FormControl<String>(validators: [Validators.required]),
      'notes': FormControl<String>(),
    });
  }

  Future<void> saveActivity() async {
    if (form.valid) {
      Activity activity = Activity(
        title: form.control('title').value.toString().trim(),
        type: form.control('type').value.toString(),
        duration: int.parse(form.control('duration').value.toString().trim()),
        calories: double.parse(form.control('calories').value.toString().trim()),
        steps: int.parse(form.control('steps').value.toString().trim()),
        distance: double.parse(form.control('distance').value.toString().trim()),
        activityDate: DateTime.now().toString(),
        location: form.control('location').value.toString().trim(),
        notes: (form.control('notes').value ?? '').toString().trim(),
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
    } else {
      form.markAllAsTouched();
    }
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
            ReactiveForm(
              formGroup: form,
              child: Column(
                children: [
                  ReactiveTextField<String>(
                    formControlName: 'title',
                    decoration: InputDecoration(
                      labelText: 'Activity Title',
                      prefixIcon: const Icon(Icons.title),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validationMessages: {
                      ValidationMessage.required: (error) => 'Activity title is required',
                    },
                  ),
                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ReactiveDropdownField<String>(
                      formControlName: 'type',
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
                    ),
                  ),
                  const SizedBox(height: 15),

                  ReactiveTextField<String>(
                    formControlName: 'duration',
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
                    validationMessages: {
                      ValidationMessage.required: (error) => 'Duration is required',
                      ValidationMessage.number: (error) => 'Enter valid duration',
                    },
                  ),
                  const SizedBox(height: 15),

                  ReactiveTextField<String>(
                    formControlName: 'calories',
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
                    validationMessages: {
                      ValidationMessage.required: (error) => 'Calories is required',
                      ValidationMessage.number: (error) => 'Enter valid calories',
                    },
                  ),
                  const SizedBox(height: 15),

                  ReactiveTextField<String>(
                    formControlName: 'steps',
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
                    validationMessages: {
                      ValidationMessage.required: (error) => 'Steps is required',
                      ValidationMessage.number: (error) => 'Enter valid steps',
                    },
                  ),
                  const SizedBox(height: 15),

                  ReactiveTextField<String>(
                    formControlName: 'distance',
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
                    validationMessages: {
                      ValidationMessage.required: (error) => 'Distance is required',
                      ValidationMessage.number: (error) => 'Enter valid distance',
                    },
                  ),
                  const SizedBox(height: 15),

                  ReactiveTextField<String>(
                    formControlName: 'location',
                    decoration: InputDecoration(
                      labelText: 'Location',
                      prefixIcon: const Icon(Icons.location_on),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validationMessages: {
                      ValidationMessage.required: (error) => 'Location is required',
                    },
                  ),
                  const SizedBox(height: 15),

                  ReactiveTextField<String>(
                    formControlName: 'notes',
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
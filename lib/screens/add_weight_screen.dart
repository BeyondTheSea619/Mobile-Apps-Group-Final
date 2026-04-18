import 'package:flutter/material.dart';

import '../database/database_services.dart';
import '../models/weight.dart';

class AddWeightScreen extends StatefulWidget {
  const AddWeightScreen({super.key});

  @override
  State<AddWeightScreen> createState() => _AddWeightScreenState();
}

class _AddWeightScreenState extends State<AddWeightScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController weightController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  Future<void> saveWeight() async {
    if (formKey.currentState!.validate()) {
      Weight weight = Weight(
        weight: double.parse(weightController.text.trim()),
        bmi: double.parse(bmiController.text.trim()),
        note: noteController.text.trim(),
        weightDate: DateTime.now().toString(),
        photoPath: '',
      );

      int result = await DatabaseServices.insertWeight(weight.toMap());

      if (!mounted) return;

      if (result > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Weight saved successfully'),
          ),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not save weight'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    weightController.dispose();
    bmiController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Add Weight'),
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
                      Icons.monitor_weight,
                      size: 35,
                      color: Color(0xFF20D6C7),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Add Weight Record',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Save your latest weight details',
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
                    controller: weightController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Weight (kg)',
                      prefixIcon: const Icon(Icons.monitor_weight_outlined),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Weight is required';
                      }
                      if (double.tryParse(value.trim()) == null) {
                        return 'Enter valid weight';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: bmiController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'BMI',
                      prefixIcon: const Icon(Icons.favorite_outline),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'BMI is required';
                      }
                      if (double.tryParse(value.trim()) == null) {
                        return 'Enter valid BMI';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  // note can be left empty
                  TextFormField(
                    controller: noteController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Note',
                      prefixIcon: const Icon(Icons.note_alt_outlined),
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
                      onPressed: saveWeight,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF20D6C7),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'Save Weight',
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
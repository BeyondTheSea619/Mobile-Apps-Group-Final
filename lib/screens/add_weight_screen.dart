import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../database/database_services.dart';
import '../models/weight.dart';

class AddWeightScreen extends StatefulWidget {
  const AddWeightScreen({super.key});

  @override
  State<AddWeightScreen> createState() => _AddWeightScreenState();
}

class _AddWeightScreenState extends State<AddWeightScreen> {
  late FormGroup form; // reactive form group to manage weight input fields

  @override
  void initState() {
    super.initState();
    // creating form with weight and bmi as required number fields
    // note is optional so no validators on it
    form = fb.group({
      'weight': FormControl<String>(
        validators: [Validators.required, Validators.number()],
      ),
      'bmi': FormControl<String>(
        validators: [Validators.required, Validators.number()],
      ),
      'note': FormControl<String>(),
    });
  }

  // saves weight record to the database if everything is filled properly
  Future<void> saveWeight() async {
    if (form.valid) {
      Weight weight = Weight(
        weight: double.parse(form.control('weight').value.toString().trim()),
        bmi: double.parse(form.control('bmi').value.toString().trim()),
        note: (form.control('note').value ?? '').toString().trim(),
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
    } else {
      // showing validation errors if user missed something
      form.markAllAsTouched();
    }
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
            ReactiveForm(
              formGroup: form,
              child: Column(
                children: [
                  ReactiveTextField<String>(
                    formControlName: 'weight',
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
                    validationMessages: {
                      ValidationMessage.required: (error) => 'Weight is required',
                      ValidationMessage.number: (error) => 'Enter valid weight',
                    },
                  ),
                  const SizedBox(height: 15),

                  ReactiveTextField<String>(
                    formControlName: 'bmi',
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
                    validationMessages: {
                      ValidationMessage.required: (error) => 'BMI is required',
                      ValidationMessage.number: (error) => 'Enter valid BMI',
                    },
                  ),
                  const SizedBox(height: 15),

                  ReactiveTextField<String>(
                    formControlName: 'note',
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
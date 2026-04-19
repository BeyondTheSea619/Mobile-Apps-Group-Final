import 'dart:io';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../database/database_services.dart';
import '../models/user.dart';
import 'camera_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late FormGroup form;

  String profileImagePath = '';
  int? userId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    form = fb.group({
      'name': FormControl<String>(validators: [Validators.required]),
      'age': FormControl<String>(validators: [Validators.required, Validators.number]),
      'gender': FormControl<String>(value: 'Male', validators: [Validators.required]),
      'height': FormControl<String>(validators: [Validators.required, Validators.number]),
      'weight': FormControl<String>(validators: [Validators.required, Validators.number]),
      'goalWeight': FormControl<String>(validators: [Validators.required, Validators.number]),
      'targetSteps': FormControl<String>(validators: [Validators.required, Validators.number]),
      'email': FormControl<String>(validators: [Validators.required, Validators.email]),
    });
    loadProfile();
  }

  Future<void> loadProfile() async {
    final data = await DatabaseServices.getFirstUser();

    if (data != null) {
      User user = User.fromMap(data);

      userId = user.id;
      
      form.patchValue({
        'name': user.name,
        'age': user.age.toString(),
        'gender': user.gender,
        'height': user.height.toString(),
        'weight': user.weight.toString(),
        'goalWeight': user.goalWeight.toString(),
        'targetSteps': user.targetSteps.toString(),
        'email': user.email,
      });
      
      profileImagePath = user.profileImagePath;
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> openCameraScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CameraScreen(),
      ),
    );

    if (result != null && result is String) {
      setState(() {
        profileImagePath = result;
      });
    }
  }

  Future<void> saveProfile() async {
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }

    User user = User(
      id: userId,
      name: form.control('name').value.toString().trim(),
      age: int.parse(form.control('age').value.toString().trim()),
      gender: form.control('gender').value.toString(),
      height: double.parse(form.control('height').value.toString().trim()),
      weight: double.parse(form.control('weight').value.toString().trim()),
      goalWeight: double.parse(form.control('goalWeight').value.toString().trim()),
      targetSteps: int.parse(form.control('targetSteps').value.toString().trim()),
      email: form.control('email').value.toString().trim(),
      profileImagePath: profileImagePath,
    );

    int result = 0;

    if (userId == null) {
      result = await DatabaseServices.insertUser(user.toMap());
      if (result > 0) {
        userId = result;
      }
    } else {
      result = await DatabaseServices.updateUser(user.toMap());
    }

    if (!mounted) return;

    if (result > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully')),
      );
      await loadProfile();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save profile')),
      );
    }
  }

  void clearForm() {
    form.reset(value: {
      'gender': 'Male',
    });
    profileImagePath = '';
    userId = null;
    setState(() {});
  }

  Widget buildField({
    required String formControlName,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    Map<String, String Function(Object)>? validationMessages,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ReactiveTextField<String>(
        formControlName: formControlName,
        keyboardType: keyboardType,
        validationMessages: validationMessages,
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
  Widget build(BuildContext context) {
    String currentName = form.control('name').value?.toString() ?? '';
    String profileTitle = currentName.isEmpty
        ? 'My Profile'
        : currentName;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          backgroundImage: profileImagePath.isNotEmpty
                              ? FileImage(File(profileImagePath))
                              : null,
                          child: profileImagePath.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: 35,
                                  color: Color(0xFF20D6C7),
                                )
                              : null,
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: openCameraScreen,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Add Photo'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          profileTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ReactiveForm(
                    formGroup: form,
                    child: Column(
                      children: [
                        buildField(
                          formControlName: 'name',
                          label: 'Full Name',
                          icon: Icons.person,
                          validationMessages: {
                            ValidationMessage.required: (error) => 'Name is required',
                          },
                        ),
                        buildField(
                          formControlName: 'age',
                          label: 'Age',
                          icon: Icons.cake,
                          keyboardType: TextInputType.number,
                          validationMessages: {
                            ValidationMessage.required: (error) => 'Age is required',
                            ValidationMessage.number: (error) => 'Enter valid age',
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ReactiveDropdownField<String>(
                            formControlName: 'gender',
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Gender',
                              prefixIcon: Icon(Icons.people),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Male',
                                child: Text('Male'),
                              ),
                              DropdownMenuItem(
                                value: 'Female',
                                child: Text('Female'),
                              ),
                              DropdownMenuItem(
                                value: 'Other',
                                child: Text('Other'),
                              ),
                            ],
                          ),
                        ),
                        buildField(
                          formControlName: 'height',
                          label: 'Height (cm)',
                          icon: Icons.height,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validationMessages: {
                            ValidationMessage.required: (error) => 'Height is required',
                            ValidationMessage.number: (error) => 'Enter valid height',
                          },
                        ),
                        buildField(
                          formControlName: 'weight',
                          label: 'Current Weight (kg)',
                          icon: Icons.monitor_weight,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validationMessages: {
                            ValidationMessage.required: (error) => 'Weight is required',
                            ValidationMessage.number: (error) => 'Enter valid weight',
                          },
                        ),
                        buildField(
                          formControlName: 'goalWeight',
                          label: 'Goal Weight (kg)',
                          icon: Icons.flag,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validationMessages: {
                            ValidationMessage.required: (error) => 'Goal weight is required',
                            ValidationMessage.number: (error) => 'Enter valid goal weight',
                          },
                        ),
                        buildField(
                          formControlName: 'targetSteps',
                          label: 'Target Steps',
                          icon: Icons.directions_walk,
                          keyboardType: TextInputType.number,
                          validationMessages: {
                            ValidationMessage.required: (error) => 'Target steps is required',
                            ValidationMessage.number: (error) => 'Enter valid target steps',
                          },
                        ),
                        buildField(
                          formControlName: 'email',
                          label: 'Email',
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validationMessages: {
                            ValidationMessage.required: (error) => 'Email is required',
                            ValidationMessage.email: (error) => 'Enter valid email',
                          },
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF20D6C7),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text('Save Profile'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: clearForm,
                            child: const Text('Clear Form'),
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
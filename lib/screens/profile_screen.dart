import 'dart:io';
import 'package:flutter/material.dart';

import '../database/database_services.dart';
import '../models/user.dart';
import 'camera_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final goalWeightController = TextEditingController();
  final targetStepsController = TextEditingController();
  final emailController = TextEditingController();

  String selectedGender = 'Male';
  String profileImagePath = '';
  int? userId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final data = await DatabaseServices.getFirstUser();

    if (data != null) {
      User user = User.fromMap(data);

      userId = user.id;
      nameController.text = user.name;
      ageController.text = user.age.toString();
      heightController.text = user.height.toString();
      weightController.text = user.weight.toString();
      goalWeightController.text = user.goalWeight.toString();
      targetStepsController.text = user.targetSteps.toString();
      emailController.text = user.email;
      selectedGender = user.gender;
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
    if (!formKey.currentState!.validate()) {
      return;
    }

    User user = User(
      id: userId,
      name: nameController.text.trim(),
      age: int.parse(ageController.text.trim()),
      gender: selectedGender,
      height: double.parse(heightController.text.trim()),
      weight: double.parse(weightController.text.trim()),
      goalWeight: double.parse(goalWeightController.text.trim()),
      targetSteps: int.parse(targetStepsController.text.trim()),
      email: emailController.text.trim(),
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
    nameController.clear();
    ageController.clear();
    heightController.clear();
    weightController.clear();
    goalWeightController.clear();
    targetStepsController.clear();
    emailController.clear();

    selectedGender = 'Male';
    profileImagePath = '';
    userId = null;

    setState(() {});
  }

  Widget buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
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
    nameController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    goalWeightController.dispose();
    targetStepsController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String profileTitle = nameController.text.isEmpty
        ? 'My Profile'
        : nameController.text;

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
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        buildField(
                          controller: nameController,
                          label: 'Full Name',
                          icon: Icons.person,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                        ),
                        buildField(
                          controller: ageController,
                          label: 'Age',
                          icon: Icons.cake,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Age is required';
                            }
                            if (int.tryParse(value.trim()) == null) {
                              return 'Enter valid age';
                            }
                            return null;
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: selectedGender,
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
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value!;
                              });
                            },
                          ),
                        ),
                        buildField(
                          controller: heightController,
                          label: 'Height (cm)',
                          icon: Icons.height,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Height is required';
                            }
                            if (double.tryParse(value.trim()) == null) {
                              return 'Enter valid height';
                            }
                            return null;
                          },
                        ),
                        buildField(
                          controller: weightController,
                          label: 'Current Weight (kg)',
                          icon: Icons.monitor_weight,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                        buildField(
                          controller: goalWeightController,
                          label: 'Goal Weight (kg)',
                          icon: Icons.flag,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Goal weight is required';
                            }
                            if (double.tryParse(value.trim()) == null) {
                              return 'Enter valid goal weight';
                            }
                            return null;
                          },
                        ),
                        buildField(
                          controller: targetStepsController,
                          label: 'Target Steps',
                          icon: Icons.directions_walk,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Target steps is required';
                            }
                            if (int.tryParse(value.trim()) == null) {
                              return 'Enter valid target steps';
                            }
                            return null;
                          },
                        ),
                        buildField(
                          controller: emailController,
                          label: 'Email',
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email is required';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Enter valid email';
                            }
                            return null;
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
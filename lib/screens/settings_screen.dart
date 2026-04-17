import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController stepGoalController = TextEditingController();
  final TextEditingController waterGoalController = TextEditingController();

  bool reminderOn = false;
  bool soundOn = true;

  String selectedActivity = 'Walking';

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    stepGoalController.text =
        (prefs.getInt('step_goal') ?? 10000).toString();

    waterGoalController.text =
        (prefs.getDouble('water_goal') ?? 2.0).toString();

    reminderOn = prefs.getBool('reminder') ?? false;
    soundOn = prefs.getBool('sound_on') ?? true;
    selectedActivity = prefs.getString('preferred_activity') ?? 'Walking';

    setState(() {});
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(
      'step_goal',
      int.tryParse(stepGoalController.text.trim()) ?? 10000,
    );

    await prefs.setDouble(
      'water_goal',
      double.tryParse(waterGoalController.text.trim()) ?? 2.0,
    );

    await prefs.setBool('reminder', reminderOn);
    await prefs.setBool('sound_on', soundOn);
    await prefs.setString('preferred_activity', selectedActivity);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully')),
    );
  }

  Future<void> resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    stepGoalController.text = '10000';
    waterGoalController.text = '2.0';
    reminderOn = false;
    soundOn = true;
    selectedActivity = 'Walking';

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings reset successfully')),
    );
  }

  Widget buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  void dispose() {
    stepGoalController.dispose();
    waterGoalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF20D6C7);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Settings'),
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
                color: primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.settings,
                      size: 35,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'App Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Manage your fitness app preferences',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Goals',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  buildTextField(
                    controller: stepGoalController,
                    label: 'Daily Step Goal',
                    icon: Icons.directions_walk,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 14),
                  buildTextField(
                    controller: waterGoalController,
                    label: 'Daily Water Goal (L)',
                    icon: Icons.water_drop,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ],
              ),
            ),

            buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Preferences',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Enable Reminder'),
                    subtitle: const Text('Get notified for your daily goals'),
                    value: reminderOn,
                    onChanged: (value) {
                      setState(() {
                        reminderOn = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Notification Sound'),
                    subtitle: const Text('Play sound for reminder notifications'),
                    value: soundOn,
                    onChanged: (value) {
                      setState(() {
                        soundOn = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedActivity,
                    decoration: InputDecoration(
                      labelText: 'Preferred Activity',
                      prefixIcon: const Icon(Icons.fitness_center),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                        selectedActivity = value!;
                      });
                    },
                  ),
                ],
              ),
            ),

            buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Saved Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFE8FBF8),
                      child: Icon(
                        Icons.flag_outlined,
                        color: primaryColor,
                      ),
                    ),
                    title: const Text('Step Goal'),
                    subtitle: Text('${stepGoalController.text} steps'),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFE8FBF8),
                      child: Icon(
                        Icons.water_drop,
                        color: primaryColor,
                      ),
                    ),
                    title: const Text('Water Goal'),
                    subtitle: Text('${waterGoalController.text} L'),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFE8FBF8),
                      child: Icon(
                        Icons.favorite_border,
                        color: primaryColor,
                      ),
                    ),
                    title: const Text('Preferred Activity'),
                    subtitle: Text(selectedActivity),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Save Settings',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: resetSettings,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Reset Settings',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
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

    stepGoalController.text = (prefs.getInt('step_goal') ?? 10000).toString();
    waterGoalController.text = (prefs.getDouble('water_goal') ?? 2.0).toString();
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
      const SnackBar(
        content: Text('Settings saved'),
      ),
    );
  }

  Future<void> clearSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    stepGoalController.text = '10000';
    waterGoalController.text = '2.0';
    reminderOn = false;
    soundOn = true;
    selectedActivity = 'Walking';

    setState(() {});

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings cleared'),
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
    const Color primaryColor = Color(0xFF20D6C7);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: stepGoalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Daily Step Goal',
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: waterGoalController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Daily Water Goal',
              ),
            ),
            const SizedBox(height: 15),
            SwitchListTile(
              title: const Text('Enable Reminder'),
              value: reminderOn,
              onChanged: (value) {
                setState(() {
                  reminderOn = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Notification Sound'),
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
              decoration: const InputDecoration(
                labelText: 'Preferred Activity',
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
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: clearSettings,
                child: const Text('Clear'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
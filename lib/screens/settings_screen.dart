import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late FormGroup form; // reactive form for managing all setting fields
  bool isLoading = true; // to show loading while we fetch saved settings

  @override
  void initState() {
    super.initState();
    // setting up form with default values for step goal and water goal
    // also adding boolean controls for the toggle switches
    form = fb.group({
      'stepGoal': FormControl<String>(value: '10000', validators: [Validators.required, Validators.number()]),
      'waterGoal': FormControl<String>(value: '2.0', validators: [Validators.required, Validators.number()]),
      'reminder': FormControl<bool>(value: false),
      'soundOn': FormControl<bool>(value: true),
      'preferredActivity': FormControl<String>(value: 'Walking', validators: [Validators.required]),
    });
    loadSettings();
  }

  // loading previously saved settings from shared preferences
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    form.patchValue({
      'stepGoal': (prefs.getInt('step_goal') ?? 10000).toString(),
      'waterGoal': (prefs.getDouble('water_goal') ?? 2.0).toString(),
      'reminder': prefs.getBool('reminder') ?? false,
      'soundOn': prefs.getBool('sound_on') ?? true,
      'preferredActivity': prefs.getString('preferred_activity') ?? 'Walking',
    });

    setState(() {
      isLoading = false;
    });
  }

  // saving all the settings to shared preferences so they persist
  Future<void> saveSettings() async {
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(
      'step_goal',
      int.parse(form.control('stepGoal').value.toString()),
    );

    await prefs.setDouble(
      'water_goal',
      double.parse(form.control('waterGoal').value.toString()),
    );

    await prefs.setBool('reminder', form.control('reminder').value as bool);
    await prefs.setBool('sound_on', form.control('soundOn').value as bool);
    await prefs.setString('preferred_activity', form.control('preferredActivity').value.toString());

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved'),
      ),
    );
  }

  // this resets everything back to the defaults and clears stored preferences
  Future<void> clearSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    form.reset(value: {
      'stepGoal': '10000',
      'waterGoal': '2.0',
      'reminder': false,
      'soundOn': true,
      'preferredActivity': 'Walking',
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings cleared'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF20D6C7);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ReactiveForm(
                formGroup: form,
                child: Column(
                  children: [
                    ReactiveTextField<String>(
                      formControlName: 'stepGoal',
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Daily Step Goal',
                      ),
                      validationMessages: {
                        ValidationMessage.required: (error) => 'Step goal is required',
                        ValidationMessage.number: (error) => 'Enter valid number',
                      },
                    ),
                    const SizedBox(height: 15),
                    ReactiveTextField<String>(
                      formControlName: 'waterGoal',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Daily Water Goal',
                      ),
                      validationMessages: {
                        ValidationMessage.required: (error) => 'Water goal is required',
                        ValidationMessage.number: (error) => 'Enter valid number',
                      },
                    ),
                    const SizedBox(height: 15),
                    ReactiveSwitchListTile(
                      formControlName: 'reminder',
                      title: const Text('Enable Reminder'),
                    ),
                    ReactiveSwitchListTile(
                      formControlName: 'soundOn',
                      title: const Text('Notification Sound'),
                    ),
                    const SizedBox(height: 10),
                    ReactiveDropdownField<String>(
                      formControlName: 'preferredActivity',
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
            ),
    );
  }
}
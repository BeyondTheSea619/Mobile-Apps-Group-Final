import 'package:flutter/material.dart';

import '../database/database_services.dart';
import '../models/weight.dart';
import '../widgets/weight_card.dart';
import 'add_weight_screen.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  List<Weight> weights = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getWeights();
  }

  Future<void> getWeights() async {
    setState(() {
      isLoading = true;
    });

    final data = await DatabaseServices.getAllWeights();

    weights = data.map((item) {
      return Weight.fromMap(item);
    }).toList();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> removeWeight(int id) async {
    await DatabaseServices.deleteWeight(id);
    await getWeights();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Weight record deleted'),
      ),
    );
  }

  Future<void> goToAddWeightScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddWeightScreen(),
      ),
    );

    if (result == true) {
      getWeights();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Weight'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
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
                  'Weight Tracker',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Track your weight records',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : weights.isEmpty
                    ? const Center(
                        child: Text(
                          'No weight records found',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: weights.length,
                        itemBuilder: (context, index) {
                          final weightItem = weights[index];

                          return WeightCard(
                            weightItem: weightItem,
                            onDelete: () {
                              if (weightItem.id != null) {
                                removeWeight(weightItem.id!);
                              }
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToAddWeightScreen,
        backgroundColor: const Color(0xFF20D6C7),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
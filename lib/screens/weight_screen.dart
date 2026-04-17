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
  List<Weight> weightList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadWeights();
  }

  Future<void> loadWeights() async {
    setState(() {
      isLoading = true;
    });

    final data = await DatabaseServices.getAllWeights();
    weightList = data.map((item) => Weight.fromMap(item)).toList();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteWeight(int id) async {
    await DatabaseServices.deleteWeight(id);
    await loadWeights();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Weight record deleted')),
    );
  }

  void openAddWeightScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddWeightScreen(),
      ),
    );

    if (result == true) {
      loadWeights();
    }
  }

  Widget buildSummaryCard() {
    if (weightList.isEmpty) {
      return Container(
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
              'No weight records added yet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    final latestWeight = weightList.first;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF20D6C7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.monitor_weight,
              size: 35,
              color: Color(0xFF20D6C7),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Latest Weight',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${latestWeight.weight} kg',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          Text(
            'BMI: ${latestWeight.bmi}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
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
          buildSummaryCard(),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : weightList.isEmpty
                    ? const Center(
                        child: Text(
                          'No weight records found',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: loadWeights,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: weightList.length,
                          itemBuilder: (context, index) {
                            final weightItem = weightList[index];
                            return WeightCard(
                              weightItem: weightItem,
                              onDelete: () {
                                if (weightItem.id != null) {
                                  deleteWeight(weightItem.id!);
                                }
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddWeightScreen,
        backgroundColor: const Color(0xFF20D6C7),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
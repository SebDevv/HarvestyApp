import 'package:flutter/material.dart';
import 'package:Harvesty/Database/plant_database.dart';
import 'package:Harvesty/Widgets/plant_card.dart';

class Plantspage extends StatefulWidget {
  const Plantspage({super.key});

  @override
  State<Plantspage> createState() => PlantspageState();
}

class PlantspageState extends State<Plantspage> {
  List<Map<String, dynamic>> plants = [];

  Future<void> loadPlants() async {
    final data = await DatabaseHelper.instance.getPlants();
    if (!mounted) return;

    setState(() {
      plants = data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadPlants();
  }

  Widget buildPlantList(List<Map<String, dynamic>> plantList) {
    return ListView.builder(
      itemCount: plantList.length,
      itemBuilder: (context, index) {
        final plant = plantList[index];

        final sowMonths = (plant['sowOutdoors']?.toString() ?? '')
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

        final harvestMonths = (plant['harvest']?.toString() ?? '')
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

        return PlantCard(
          name: plant['name']?.toString() ?? '',
          category: plant['category']?.toString() ?? '',
          difficulty: plant['difficulty'] as int? ?? 1,
          sowMonths: sowMonths,
          harvestMonths: harvestMonths,
          notes: plant['notes']?.toString() ?? '',
          plantid: plant['id'] as int? ?? 1,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vegetables = plants
        .where((plant) => plant['category'] == 'Vegetable')
        .toList();

    final fruit = plants
        .where((plant) => plant['category'] == 'Fruit')
        .toList();

    final herbs = plants.where((plant) => plant['category'] == 'Herb').toList();

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Vegetables'),
              Tab(text: 'Fruit'),
              Tab(text: 'Herbs'),
            ],
          ),

          Expanded(
            child: TabBarView(
              children: [
                buildPlantList(vegetables),
                buildPlantList(fruit),
                buildPlantList(herbs),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

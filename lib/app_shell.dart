import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:Harvesty/Pages/PlantsPage.dart';
import 'package:Harvesty/Pages/HomePage.dart';
import 'package:Harvesty/Pages/ProfilePage.dart';
import 'package:Harvesty/Pages/MyCropPage.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:Harvesty/Services/SettingsPage.dart';
import 'package:Harvesty/providers/theme_provider.dart';

import 'Database/plant_database.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selectedIndex = 0;
  final GlobalKey<PlantspageState> historyKey = GlobalKey<PlantspageState>();
  late final List<Widget> pages = [
    const Homepage(),
    const MyCropPage(),
    Plantspage(key: historyKey),
    const Profilepage(),
  ];
  List<Map<String, dynamic>> plants = [];

  Future<void> loadPlants() async {
    final data = await DatabaseHelper.instance.getPlants();

    setState(() {
      plants = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: false,
        title: Row(
          children: [
            Icon(MaterialCommunityIcons.sprout),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Harvesty"),
            ),
          ],
        ),
        actions: _actionsForIndex(context, selectedIndex),
      ),
      body: pages[selectedIndex],

      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.transparent,
        shadowColor: Colors.amber,
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Symbols.home, fill: 1, color: Colors.grey),
            selectedIcon: Icon(
              Symbols.home,
              fill: 1,
              color: themeProvider.themeMode == ThemeMode.dark
                  ? Colors.blue
                  : Colors.black,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(MaterialCommunityIcons.sprout, color: Colors.grey),
            selectedIcon: Icon(
              MaterialCommunityIcons.sprout,

              color: themeProvider.themeMode == ThemeMode.dark
                  ? Colors.blue
                  : Colors.black,
            ),
            label: 'My Crop',
          ),
          NavigationDestination(
            icon: Icon(Ionicons.ios_leaf, color: Colors.grey),
            selectedIcon: Icon(
              Ionicons.ios_leaf,
              color: themeProvider.themeMode == ThemeMode.dark
                  ? Colors.blue
                  : Colors.black,
            ),
            label: 'Plants',
          ),
          NavigationDestination(
            icon: Icon(Foundation.torso, color: Colors.grey),
            selectedIcon: Icon(
              Foundation.torso,
              color: themeProvider.themeMode == ThemeMode.dark
                  ? Colors.blue
                  : Colors.black,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  List<Widget> _actionsForIndex(BuildContext context, int index) {
    switch (index) {
      case 0: // Home Page
        return [];
      case 1: // Workout Page
        return [];
      case 2: // Progress Page
        return [
          IconButton(
            tooltip: "Delete",
            icon: const Icon(Symbols.delete),
            onPressed: () async {
              await DatabaseHelper.instance.clearPlants();
              await historyKey.currentState?.loadPlants();
              setState(() {});
            },
          ),
          IconButton(
            onPressed: () async {
              await DatabaseHelper.instance.importPlantsFromJson();
              await historyKey.currentState?.loadPlants();
              setState(() {});
            },
            icon: Icon(Symbols.add),
          ),
        ];
      case 3: // Profile Page
        return [
          IconButton(
            tooltip: "Settings",
            icon: const Icon(Symbols.settings),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                useSafeArea: true,
                isScrollControlled: true,
                builder: ((context) {
                  return Settingspage();
                }),
              );
            },
          ),
        ];
      default:
        return const [];
    }
  }
}

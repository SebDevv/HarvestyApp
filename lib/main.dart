import 'package:flutter/material.dart';
import 'package:harvesty/Pages/Home.dart';
import 'package:harvesty/Pages/MyPlants.dart';
import 'package:harvesty/Pages/PlantLibrary.dart';
import 'package:harvesty/Pages/Profile.dart';
import 'package:harvesty/Pages/Tasks.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Harvesty - Plant, Water & Harvest',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyMainPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key, required this.title});
  final String title;
  @override
  State<MyMainPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyMainPage> {
  int currentPageIndex = 0;
  final pages = const [
    MyHomePage(),
    MyplantsPage(),
    MyPlantLibraryPage(),
    MyTasksPage(),
    MyProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Harvesty - Plant, Water & Harvest")),

      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.transparent,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Symbols.home_and_garden_rounded, fill: 0),
            selectedIcon: Icon(Symbols.home_and_garden_rounded, fill: 1),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Symbols.eco, fill: 0),
            selectedIcon: Icon(Symbols.eco, fill: 1),
            label: 'My Plants',
          ),
          NavigationDestination(
            icon: Icon(Symbols.menu_book, fill: 0),
            selectedIcon: Icon(Symbols.menu_book, fill: 1),
            label: 'Plant Library',
          ),
          NavigationDestination(
            icon: Icon(Symbols.check_box, fill: 0),
            selectedIcon: Icon(Symbols.check_box, fill: 1),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Symbols.person, fill: 0),
            selectedIcon: Icon(Symbols.person, fill: 1),
            label: 'Profile',
          ),
        ],
      ),

      body: pages[currentPageIndex],
    );
  }
}

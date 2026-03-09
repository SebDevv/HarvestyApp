import 'package:flutter/material.dart';
import 'package:Harvesty/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter/cupertino.dart';

class Settingspage extends StatefulWidget {
  const Settingspage({super.key});

  @override
  State<Settingspage> createState() => _SettingspageState();
}

class _SettingspageState extends State<Settingspage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          _buildSectionTile("App Preferences"),
          ListTile(
            title: const Text("Theme"),
            subtitle: Text(
              themeProvider.themeMode == ThemeMode.dark
                  ? "Dark Theme"
                  : "Light Theme",
            ),
            trailing: CupertinoSlidingSegmentedControl<int>(
              groupValue: themeProvider.themeMode == ThemeMode.dark ? 0 : 1,
              children: const {
                0: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(Symbols.dark_mode_rounded),
                ),
                1: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(Symbols.light_mode_rounded),
                ),
              },
              onValueChanged: (int? value) {
                if (value == null) return;
                themeProvider.toggleTheme(value == 0); // 0 = dark, 1 = light
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTile(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }
}

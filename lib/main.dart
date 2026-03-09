import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Harvesty/app_shell.dart';
import 'package:Harvesty/providers/theme_provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => ThemeProvider())],
      child: HarvestyApp(),
    ),
  );
}

class HarvestyApp extends StatefulWidget {
  const HarvestyApp({super.key});

  @override
  State<HarvestyApp> createState() => _PRXAppState();
}

class _PRXAppState extends State<HarvestyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Harvesty',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      themeAnimationDuration: const Duration(milliseconds: 120),
      home: AppShell(),
    );
  }
}

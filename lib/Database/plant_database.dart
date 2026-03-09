import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, 'plant.db');

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE plants(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT,
  category TEXT,
  difficulty INTEGER,
  sowIndoors TEXT,
  sowOutdoors TEXT,
  harvest TEXT,
  spacing_cm INTEGER,
  sun TEXT,
  soil TEXT,
  notes TEXT
)''');
  }

  Future<int> insertPlant(Map<String, dynamic> plant) async {
    final db = await database;
    return await db.insert('plants', plant);
  }

  Future<List<Map<String, dynamic>>> getPlants() async {
    final db = await database;
    final result = await db.query('plants', orderBy: 'name ASC');
    return result;
  }

  Future<void> clearPlants() async {
    final db = await database;
    await db.delete('plants');
  }

  Future<List<dynamic>> loadPlantsJson() async {
    final jsonString = await rootBundle.loadString('assets/data/plants.json');
    final data = jsonDecode(jsonString);

    return data as List<dynamic>;
  }

  Future<void> importPlantsFromJson() async {
    final db = await database;

    final result = await db.rawQuery('SELECT COUNT(*) as count FROM plants');
    final count = Sqflite.firstIntValue(result) ?? 0;

    if (count > 0) return;

    final plantsJson = await loadPlantsJson();

    for (final item in plantsJson) {
      final plant = item as Map<String, dynamic>;

      await db.insert('plants', {
        'name': plant['name']?.toString() ?? '',
        'category': plant['category']?.toString() ?? '',
        'difficulty': plant['difficulty'] ?? 1,
        'sowIndoors': (plant['sowIndoors'] as List?)?.join(',') ?? '',
        'sowOutdoors': (plant['sowOutdoors'] as List?)?.join(',') ?? '',
        'harvest': (plant['harvest'] as List?)?.join(',') ?? '',
        'spacing_cm': plant['spacing_cm'] ?? 0,
        'sun': plant['sun']?.toString() ?? '',
        'soil': plant['soil']?.toString() ?? '',
        'notes': plant['notes']?.toString() ?? '',
      });
    }
  }

  Future<bool> isPlantsTableEmpty() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM plants');
    final count = result.first['count'] as int;
    return count == 0;
  }

  Future<Map<String, dynamic>?> getPlantById(int id) async {
    final db = await database;

    final result = await db.query(
      'plants',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return result.first;
  }
}

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/variety.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'potato_varieties.db');

    final dbFile = File(path);
    
    // Если файл существует — проверяем, есть ли в нём таблица varieties
    if (await dbFile.exists()) {
      try {
        final testDb = await openDatabase(path, version: 1);
        final result = await testDb.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='varieties'"
        );
        await testDb.close();
        
        if (result.isEmpty) {
          // Таблицы нет — удаляем старую БД
          debugPrint('⚠️ Старая БД без таблицы varieties. Удаляем...');
          await dbFile.delete();
        } else {
          debugPrint('✅ БД уже существует на устройстве');
          return await openDatabase(path, version: 1);
        }
      } catch (e) {
        debugPrint('⚠️ Ошибка проверки БД: $e. Удаляем файл...');
        await dbFile.delete();
      }
    }
    
    // Копируем новую БД из assets
    debugPrint('📦 Копируем БД из assets...');
    final assetData = await rootBundle.load('assets/potato_varieties.db');
    final buffer = assetData.buffer.asUint8List();
    await dbFile.writeAsBytes(buffer);
    debugPrint('✅ БД успешно скопирована!');

    return await openDatabase(path, version: 1);
  }

  Future<List<PotatoVariety>> getAllVarieties() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'varieties',
      orderBy: 'name ASC',
    );
    return maps.map((map) => PotatoVariety.fromMap(map)).toList();
  }
}
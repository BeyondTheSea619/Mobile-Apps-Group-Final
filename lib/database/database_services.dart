import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseServices {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) {
      return _database!;
    }

    Directory appDirectory = await getApplicationDocumentsDirectory();
    String path = join(appDirectory.path, 'fit_app.db');

    try {
      _database = await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onOpen: (db) {
          print('Database opened');
        },
      );
    } catch (e) {
      print('Database error: $e');
      rethrow;
    }

    return _database!;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER NOT NULL,
        gender TEXT NOT NULL,
        height REAL NOT NULL,
        weight REAL NOT NULL,
        goalWeight REAL NOT NULL,
        targetSteps INTEGER NOT NULL,
        email TEXT NOT NULL,
        profileImagePath TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE activities(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        type TEXT NOT NULL,
        duration INTEGER NOT NULL,
        calories REAL NOT NULL,
        steps INTEGER NOT NULL,
        distance REAL NOT NULL,
        activityDate TEXT NOT NULL,
        location TEXT,
        notes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE weights(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        weight REAL NOT NULL,
        bmi REAL NOT NULL,
        note TEXT,
        weightDate TEXT NOT NULL,
        photoPath TEXT
      )
    ''');

    print('Database and tables created');
  }

  // ---------------- USER METHODS ----------------

  static Future<int> insertUser(Map<String, dynamic> userData) async {
    try {
      final db = await getDatabase();
      return await db.insert('users', userData);
    } catch (e) {
      print('insertUser error: $e');
      return -1;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final db = await getDatabase();
      return await db.query('users');
    } catch (e) {
      print('getAllUsers error: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getUserById(int id) async {
    try {
      final db = await getDatabase();
      final result = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isNotEmpty) {
        return result.first;
      }

      return null;
    } catch (e) {
      print('getUserById error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getFirstUser() async {
    try {
      final db = await getDatabase();
      final result = await db.query('users', limit: 1);

      if (result.isNotEmpty) {
        return result.first;
      }

      return null;
    } catch (e) {
      print('getFirstUser error: $e');
      return null;
    }
  }

  static Future<int> updateUser(Map<String, dynamic> userData) async {
    try {
      final db = await getDatabase();
      return await db.update(
        'users',
        userData,
        where: 'id = ?',
        whereArgs: [userData['id']],
      );
    } catch (e) {
      print('updateUser error: $e');
      return 0;
    }
  }

  static Future<int> deleteUser(int id) async {
    try {
      final db = await getDatabase();
      return await db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('deleteUser error: $e');
      return 0;
    }
  }

  // ---------------- ACTIVITY METHODS ----------------

  static Future<int> insertActivity(Map<String, dynamic> activityData) async {
    try {
      final db = await getDatabase();

      return await db.transaction((tx) async {
        return await tx.insert('activities', activityData);
      });
    } catch (e) {
      print('insertActivity error: $e');
      return -1;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllActivities() async {
    try {
      final db = await getDatabase();
      return await db.query(
        'activities',
        orderBy: 'activityDate DESC',
      );
    } catch (e) {
      print('getAllActivities error: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getActivityById(int id) async {
    try {
      final db = await getDatabase();
      final result = await db.query(
        'activities',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isNotEmpty) {
        return result.first;
      }

      return null;
    } catch (e) {
      print('getActivityById error: $e');
      return null;
    }
  }

  static Future<int> updateActivity(Map<String, dynamic> activityData) async {
    try {
      final db = await getDatabase();
      return await db.update(
        'activities',
        activityData,
        where: 'id = ?',
        whereArgs: [activityData['id']],
      );
    } catch (e) {
      print('updateActivity error: $e');
      return 0;
    }
  }

  static Future<int> deleteActivity(int id) async {
    try {
      final db = await getDatabase();
      return await db.delete(
        'activities',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('deleteActivity error: $e');
      return 0;
    }
  }

  // ---------------- WEIGHT METHODS ----------------

  static Future<int> insertWeight(Map<String, dynamic> weightData) async {
    try {
      final db = await getDatabase();

      return await db.transaction((tx) async {
        return await tx.insert('weights', weightData);
      });
    } catch (e) {
      print('insertWeight error: $e');
      return -1;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllWeights() async {
    try {
      final db = await getDatabase();
      return await db.query(
        'weights',
        orderBy: 'weightDate DESC',
      );
    } catch (e) {
      print('getAllWeights error: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getWeightById(int id) async {
    try {
      final db = await getDatabase();
      final result = await db.query(
        'weights',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isNotEmpty) {
        return result.first;
      }

      return null;
    } catch (e) {
      print('getWeightById error: $e');
      return null;
    }
  }

  static Future<int> updateWeight(Map<String, dynamic> weightData) async {
    try {
      final db = await getDatabase();
      return await db.update(
        'weights',
        weightData,
        where: 'id = ?',
        whereArgs: [weightData['id']],
      );
    } catch (e) {
      print('updateWeight error: $e');
      return 0;
    }
  }

  static Future<int> deleteWeight(int id) async {
    try {
      final db = await getDatabase();
      return await db.delete(
        'weights',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('deleteWeight error: $e');
      return 0;
    }
  }

  // ---------------- EXTRA HELPERS ----------------

  static Future<void> clearTable(String tableName) async {
    try {
      final db = await getDatabase();
      await db.delete(tableName);
      print('$tableName cleared');
    } catch (e) {
      print('clearTable error: $e');
    }
  }

  static Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      print('Database closed');
    }
  }
}
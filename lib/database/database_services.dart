import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseServices {
  static Database? _database;

  static Future<Database> getDatabase() async {
    Directory dbDirectory = await getApplicationDocumentsDirectory();
    String path = join(dbDirectory.path, 'fit_app.db');

    if (_database == null) {
      try {
        _database = await openDatabase(
          path,
          version: 1,
          onCreate: (db, version) async {
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

            print('Database created');
          },
          onOpen: (db) {
            print('Database opened');
          },
        );
      } catch (e) {
        print("Database error: $e");
        exit(0);
      }
    }

    return _database!;
  }

  // user table

  static Future<int> insertUser(Map<String, dynamic> user) async {
    try {
      Database db = await getDatabase();
      return await db.insert('users', user);
    } catch (e) {
      print('Error inserting user: $e');
      return -1;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      Database db = await getDatabase();
      return await db.query('users');
    } catch (e) {
      print('Error getting users: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getFirstUser() async {
    try {
      Database db = await getDatabase();
      var result = await db.query('users', limit: 1);

      if (result.isNotEmpty) {
        return result.first;
      }

      return null;
    } catch (e) {
      print('Error getting first user: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getUserById(int id) async {
    try {
      Database db = await getDatabase();
      var result = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isNotEmpty) {
        return result.first;
      }

      return null;
    } catch (e) {
      print('Error getting user by id: $e');
      return null;
    }
  }

  static Future<int> updateUser(Map<String, dynamic> user) async {
    try {
      Database db = await getDatabase();
      return await db.update(
        'users',
        user,
        where: 'id = ?',
        whereArgs: [user['id']],
      );
    } catch (e) {
      print('Error updating user: $e');
      return 0;
    }
  }

  static Future<int> deleteUser(int id) async {
    try {
      Database db = await getDatabase();
      return await db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error deleting user: $e');
      return 0;
    }
  }

  // activity table

  static Future<int> insertActivity(Map<String, dynamic> activity) async {
    try {
      Database db = await getDatabase();
      return await db.insert('activities', activity);
    } catch (e) {
      print('Error inserting activity: $e');
      return -1;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllActivities() async {
    try {
      Database db = await getDatabase();
      return await db.query(
        'activities',
        orderBy: 'activityDate DESC',
      );
    } catch (e) {
      print('Error getting activities: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getActivityById(int id) async {
    try {
      Database db = await getDatabase();
      var result = await db.query(
        'activities',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isNotEmpty) {
        return result.first;
      }

      return null;
    } catch (e) {
      print('Error getting activity by id: $e');
      return null;
    }
  }

  static Future<int> updateActivity(Map<String, dynamic> activity) async {
    try {
      Database db = await getDatabase();
      return await db.update(
        'activities',
        activity,
        where: 'id = ?',
        whereArgs: [activity['id']],
      );
    } catch (e) {
      print('Error updating activity: $e');
      return 0;
    }
  }

  static Future<int> deleteActivity(int id) async {
    try {
      Database db = await getDatabase();
      return await db.delete(
        'activities',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error deleting activity: $e');
      return 0;
    }
  }

  // weight table

  static Future<int> insertWeight(Map<String, dynamic> weight) async {
    try {
      Database db = await getDatabase();
      return await db.insert('weights', weight);
    } catch (e) {
      print('Error inserting weight: $e');
      return -1;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllWeights() async {
    try {
      Database db = await getDatabase();
      return await db.query(
        'weights',
        orderBy: 'weightDate DESC',
      );
    } catch (e) {
      print('Error getting weights: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getWeightById(int id) async {
    try {
      Database db = await getDatabase();
      var result = await db.query(
        'weights',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isNotEmpty) {
        return result.first;
      }

      return null;
    } catch (e) {
      print('Error getting weight by id: $e');
      return null;
    }
  }

  static Future<int> updateWeight(Map<String, dynamic> weight) async {
    try {
      Database db = await getDatabase();
      return await db.update(
        'weights',
        weight,
        where: 'id = ?',
        whereArgs: [weight['id']],
      );
    } catch (e) {
      print('Error updating weight: $e');
      return 0;
    }
  }

  static Future<int> deleteWeight(int id) async {
    try {
      Database db = await getDatabase();
      return await db.delete(
        'weights',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error deleting weight: $e');
      return 0;
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
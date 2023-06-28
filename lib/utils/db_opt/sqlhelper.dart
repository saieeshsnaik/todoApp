import "package:sqflite/sqflite.dart" as sql;
import 'package:flutter/foundation.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute(
        """CREATE TABLE TODOLIST(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title TEXT,
    description TEXT,
    date TEXT,
    time TEXT)""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'TODOAPP.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createItem(
      String title, String? description, String? date, String? time) async {
    final db = await SQLHelper.db();
    final data = {
      'title': title,
      'description': description,
      'date': date,
      'time': time
    };
    //data is in map format
    final id = await db.insert('TODOLIST', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('TODOLIST', orderBy: "date");
  }

  static Future<int> updateItem(int id, String title, String? description,
      String? date, String? time) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': description,
      'date': date,
      'time': time,
    };

    final result =
        db.update('TODOLIST', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("TODOLIST", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item:$err");
    }
  }
}

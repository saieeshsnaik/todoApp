import "package:sqflite/sqflite.dart" as sql;
import 'package:flutter/foundation.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute(
        """CREATE TABLE TODOLIST(ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    TASKNAME TEXT,
    DESCRIPTION TEXT,
    DATE TEXT,
    TIME TEXT)""");
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
      'TASKNAME': title,
      'DESCRIPTION': description,
      'DATE': date,
      'TIME': time
    };
    //data is in map format
    final id = await db.insert('TODOLIST', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('TODOLIST', orderBy: "DATE");
  }

  static Future<int> updateItem(int id, String title, String? description,
      String? date, String? time) async {
    final db = await SQLHelper.db();

    final data = {
      'TASKNAME': title,
      'DESCRIPTION': description,
      'DATE': date,
      'TIME': time,
    };

    final result =
        db.update('TODOLIST', data, where: "ID = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("TODOLIST", where: "ID = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item:$err");
    }
  }
}

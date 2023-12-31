import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final int _newVersion = 2;
  static final String _tableName = 'tasks';

  static Future<void> initDB() async {
    if (_db != null) {
      return;
    }
    try {
      // ignore: no_leading_underscores_for_local_identifiers
      String _path = await getDatabasesPath() + 'tasks.db';
      print("Updating DB");
      _db = await openDatabase(_path, version: _version,
          onCreate: ((db, version) {
        debugPrint("Create DB");
        return db.execute(
          "CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, note TEXT, date STRING, startTime STRING, endTime STRING, remind INTEGER, repeat STRING, color INTEGER, isCompleted INTEGER)",
        );
      }));
    } catch (ex) {
      print(ex);
    }
  }

  static Future<int> insert(Task? task) async {
    try {
      return await _db?.insert(_tableName, task!.toJson()) ?? 1;
    } catch (ex) {
      print(ex);
      return -1;
    }
  }

  static Future<List<Map<String, dynamic>>> query() async {
    try {
      return await _db!.query(_tableName);
    } catch (ex) {
      print(ex);
      return [];
    }
  }

  static delete(Task task) async {
    await _db!.delete(_tableName, where: 'id = ?', whereArgs: [task.id]);
  }

  static update(int id) async {
    return await _db!.rawUpdate(
        '''UPDATE tasks SET isCompleted = ? WHERE id = ?''', [1, id]);
  }

  static updateTask(Task task) async {
    return await _db!.rawUpdate(
        '''UPDATE tasks SET title = ?, note = ?, date = ?, startTime = ?, endTime = ?, remind = ?, repeat = ?, color = ? WHERE id = ?''',
        [
          task.title,
          task.note,
          task.date,
          task.startTime,
          task.endTime,
          task.remind,
          task.repeat,
          task.color,
          task.id
        ]);
  }

  static Future<dynamic> alterTable() async {
    print("Altering table Start");
    var dbClient = await _db;
    var count = await dbClient?.execute("ALTER TABLE tasks ADD "
        "COLUMN price DOUBLE;");
    print("Altering table Done");
    return count;
  }
}

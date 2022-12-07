import 'dart:io';

import 'package:demo_todos_flutter/utils/noop_db_helper.dart';
import 'package:demo_todos_flutter/utils/sqlite_db_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../models/todo.dart';

abstract class DbHelper {

  static DbHelper? _instance;

  static Future<DbHelper> instance() async {
    return _instance ??= await _init();
  }

  static Future<DbHelper> _init() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final path = await getDatabasesPath();
      final db = await openDatabase("$path/todos.db", version: 1, onCreate: SqliteDbHelper.onCreate);
      return SqliteDbHelper(db);
    } else {
      return NoopDbHelper();
    }
  }

  Future<void> save(Todo todo);

  Future<void> saveAll(List<Todo> todos);

  Future<void> delete(int id);

  Future<List<Todo>> loadAll();
}
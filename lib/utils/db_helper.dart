import 'dart:io';

import 'package:demo_todos_flutter/utils/noop_db_helper.dart';
import 'package:demo_todos_flutter/utils/sqlite_db_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/todo.dart';

abstract class DbHelper {

  static DbHelper? _instance;

  static Future<DbHelper> instance() async {
    return _instance ??= await _init();
  }

  static Future<DbHelper> _init() async {
    if (!kIsWeb) {
      final supportDir = await getApplicationSupportDirectory();
      debugPrint("db path: ${supportDir.path}");
      final db = await openDatabase("${supportDir.path}/todos.db", version: 1, onCreate: SqliteDbHelper.onCreate);
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
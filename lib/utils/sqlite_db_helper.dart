import 'package:demo_todos_flutter/models/todo.dart';
import 'package:sqflite/sqflite.dart';

import 'db_helper.dart';

class SqliteDbHelper extends DbHelper {

  static onCreate(Database db, int version) async {
    db.execute("""
    CREATE TABLE todo (
      _id INTEGER,
      title TEXT,
      text TEXT,
      updatedAt INTEGER,
      PRIMARY KEY (_id)
    );
    """);
    db.execute("CREATE INDEX todo_updatedAt ON todo(updatedAt)");
  }

  final Database _db;

  SqliteDbHelper(this._db);

  Future<void> save(Todo todo) async {
    await _db.insert("todo", {
      "_id": todo.id,
      "title": todo.title,
      "text": todo.text,
      "updatedAt": todo.updatedAt.millisecondsSinceEpoch
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> saveAll(List<Todo> todos) async {
    await _db.transaction((txn) async {
      final ids = [];
      for (var todo in todos) {
        ids.add(todo.id);
        txn.insert("todo", {
          "_id": todo.id,
          "title": todo.title,
          "text": todo.text,
          "updatedAt": todo.updatedAt.millisecondsSinceEpoch
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      txn.execute("DELETE FROM todo WHERE _id NOT IN (${ids.join(",")})");
    });
  }

  @override
  Future<void> delete(int id) async {
    await _db.execute("DELETE FROM todo WHERE _id = $id");
  }

  @override
  Future<List<Todo>> loadAll() async {
    return _db.rawQuery("SELECT _id,title,text,updatedAt FROM todo ORDER BY updatedAt DESC")
      .then((value) {
        return value.map((e) => Todo(
            id: e["_id"] as int,
            title: e["title"] as String,
            text: e["text"] as String,
            updatedAt: DateTime.fromMillisecondsSinceEpoch(e["updatedAt"] as int)
        )).toList();
      });
  }

  Future<Todo> loadById(int id) async {
    return _db.rawQuery("SELECT _id,title,text,updatedAt FROM todo WHERE _id = $id")
        .then((value) {
          return value.map((e) => Todo(
              id: e["_id"] as int,
              title: e["title"] as String,
              text: e["text"] as String,
              updatedAt: DateTime.fromMillisecondsSinceEpoch(e["updatedAt"] as int)
          )).first;
        });
  }
}
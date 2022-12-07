import 'package:demo_todos_flutter/models/todo.dart';
import 'package:demo_todos_flutter/utils/db_helper.dart';

class NoopDbHelper extends DbHelper {

  @override
  Future<void> delete(int id) async {

  }

  @override
  Future<List<Todo>> loadAll() async {
    return [];
  }


  @override
  Future<void> saveAll(List<Todo> todos) async {

  }

  @override
  Future<void> save(Todo todo) async {

  }

}
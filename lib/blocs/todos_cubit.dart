import 'package:bloc/bloc.dart';
import 'package:demo_todos_flutter/utils/db_helper.dart';
import 'package:demo_todos_flutter/utils/rest.dart';
import 'package:demo_todos_flutter/models/todo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'todos_state.dart';

class TodosCubit extends Cubit<TodosState> {
  TodosCubit() : super(const TodosInitial()) {
    load();
  }

  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  loadFromDb() async {
    debugPrint("loadFromDb");
    final db = await DbHelper.instance();
    _todos = await db.loadAll();
    emit(TodosLoaded(_todos));
  }

  loadFromServer() async {
    debugPrint("loadFromServer");
    try {
      _todos = await Rest.instance.all();
      final db = await DbHelper.instance();
      db.saveAll(_todos);
      emit(TodosLoaded(_todos));
    } on DioError catch (e) {
      debugPrint("loadFromServer failed $e");
      emit(TodosLoadFailed(e.message));
    }
  }

  load() async {
    loadFromDb();
    loadFromServer();
  }
}

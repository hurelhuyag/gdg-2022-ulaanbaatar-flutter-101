import 'package:bloc/bloc.dart';
import 'package:demo_todos_flutter/blocs/todos_cubit.dart';
import 'package:demo_todos_flutter/models/update_todo.dart';
import 'package:demo_todos_flutter/utils/rest.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../models/todo.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {

  Todo _todo;
  final TodosCubit _todosCubit;

  Todo get todo => _todo;

  TodoCubit(this._todo, this._todosCubit) : super(TodoInitial(_todo));

  update(String title, String text) async {
    try {
      await Rest.instance.update(_todo.id, UpdateTodo(title: title, text: text));
      _todo = await Rest.instance.byId(_todo.id);
      emit(TodoUpdated(_todo));
      _todosCubit.load();
    } on DioError catch (e) {
      debugPrint("update failed. $e");
      emit(TodoUpdateFailed(e.message));
    }
  }

  delete() async {
    try {
      await Rest.instance.delete(_todo.id);
      emit(TodoDeleted(_todo));
      _todosCubit.load();
    } on DioError catch (e) {
      debugPrint("delete failed. $e");
      emit(TodoDeleteFailed(e.message));
    }
  }
}

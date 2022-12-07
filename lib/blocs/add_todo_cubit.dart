import 'package:bloc/bloc.dart';
import 'package:demo_todos_flutter/blocs/todos_cubit.dart';
import 'package:demo_todos_flutter/models/add_todo.dart';
import 'package:demo_todos_flutter/utils/rest.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'add_todo_state.dart';

class AddTodoCubit extends Cubit<AddTodoState> {

  final TodosCubit _todosCubit;

  AddTodoCubit(this._todosCubit) : super(const AddTodoInitial());

  add(String title, String text) async {
    try {
      await Rest.instance.create(AddTodo(title: title, text: text));
      emit(const AddTodoSubmitSuccess());
      _todosCubit.load();
    } on DioError catch (e) {
      debugPrint("add todo failed $e");
      emit(AddTodoSubmitFailed(e.message));
    }
  }
}

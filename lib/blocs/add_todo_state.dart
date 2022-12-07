part of 'add_todo_cubit.dart';

@immutable
abstract class AddTodoState {
  const AddTodoState();
}

class AddTodoInitial extends AddTodoState {
  const AddTodoInitial();
}

class AddTodoSubmitSuccess extends AddTodoState {
  const AddTodoSubmitSuccess();
}

class AddTodoSubmitFailed extends AddTodoState {
  final String message;
  const AddTodoSubmitFailed(this.message);
}

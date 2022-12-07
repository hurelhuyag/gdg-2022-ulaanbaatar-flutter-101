part of 'todo_cubit.dart';

@immutable
abstract class TodoState {
  const TodoState();
}

class TodoInitial extends TodoState {
  final Todo todo;
  const TodoInitial(this.todo);
}

class TodoUpdated extends TodoState {
  final Todo todo;
  const TodoUpdated(this.todo);
}

class TodoUpdateFailed extends TodoState {
  final String message;
  const TodoUpdateFailed(this.message);
}

class TodoDeleted extends TodoState {
  final Todo todo;
  const TodoDeleted(this.todo);
}

class TodoDeleteFailed extends TodoState {
  final String message;
  const TodoDeleteFailed(this.message);
}


part of 'todos_cubit.dart';

@immutable
abstract class TodosState {
  const TodosState();
}

class TodosInitial extends TodosState {
  const TodosInitial();
}

class TodosLoaded extends TodosState {
  final List<Todo> todos;
  const TodosLoaded(this.todos);
}

class TodosLoadFailed extends TodosState {
  final String message;
  const TodosLoadFailed(this.message);
}
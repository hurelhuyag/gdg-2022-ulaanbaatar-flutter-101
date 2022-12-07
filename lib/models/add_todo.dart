import 'package:json_annotation/json_annotation.dart';

part 'add_todo.g.dart';

@JsonSerializable()
class AddTodo {
  final String title;
  final String text;

  const AddTodo({
    required this.title,
    required this.text,
  });

  factory AddTodo.fromJson(Map<String, dynamic> json) => _$AddTodoFromJson(json);

  Map<String, dynamic> toJson() => _$AddTodoToJson(this);
}
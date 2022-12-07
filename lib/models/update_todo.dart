import 'package:json_annotation/json_annotation.dart';

part 'update_todo.g.dart';

@JsonSerializable()
class UpdateTodo {
  final String title;
  final String text;

  const UpdateTodo({
    required this.title,
    required this.text,
  });

  factory UpdateTodo.fromJson(Map<String, dynamic> json) => _$UpdateTodoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateTodoToJson(this);
}
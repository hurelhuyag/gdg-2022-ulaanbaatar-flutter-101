import 'package:demo_todos_flutter/blocs/todo_cubit.dart';
import 'package:demo_todos_flutter/blocs/todos_cubit.dart';
import 'package:demo_todos_flutter/models/todo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key, required this.todo});

  final Todo todo;

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {

  late final TextEditingController _titleController = TextEditingController(
      text: widget.todo.title);
  late final TextEditingController _textController = TextEditingController(
      text: widget.todo.text);

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit(widget.todo, context.read<TodosCubit>()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Edit Todo"),
              actions: [
                IconButton(
                    onPressed: () async {
                      await context.read<TodoCubit>().delete();
                      if (mounted) {
                        if (context.read<TodoCubit>().state is TodoDeleted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Deleted Successfully"))
                          );
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Delete Failed"))
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.delete)
                ),
                IconButton(
                  onPressed: () async {
                    final title = _titleController.value.text;
                    final text = _textController.value.text;
                    try {
                      await context.read<TodoCubit>().update(title, text);
                      if (mounted) {
                        if (context.read<TodoCubit>().state is TodoUpdated) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Updated Successfully"))
                          );
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Update Failed"))
                          );
                        }
                      }
                    } on DioError catch (e) {
                      debugPrint("update failed ${e.response?.data}");
                    }
                  },
                  icon: const Icon(Icons.save)
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: "Title",
                      border: InputBorder.none,
                    ),
                  ),
                  Expanded(child: TextField(
                    controller: _textController,
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: "Body",
                      border: InputBorder.none,
                    ),
                  )),
                  Text("Last Updated: ${dateFormat.format(widget.todo.updatedAt)}"),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
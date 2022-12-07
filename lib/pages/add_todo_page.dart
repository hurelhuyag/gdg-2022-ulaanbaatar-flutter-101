import 'package:demo_todos_flutter/blocs/add_todo_cubit.dart';
import 'package:demo_todos_flutter/blocs/todo_cubit.dart';
import 'package:demo_todos_flutter/blocs/todos_cubit.dart';
import 'package:demo_todos_flutter/models/todo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {

  late final TextEditingController _titleController = TextEditingController(text: "");
  late final TextEditingController _textController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTodoCubit(context.read<TodosCubit>()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Add Todo"),
              actions: [
                IconButton(
                  onPressed: () async {
                    final title = _titleController.value.text;
                    final text = _textController.value.text;
                    if (title.isEmpty || text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Add Your Todo"))
                      );
                      return;
                    }
                    await context.read<AddTodoCubit>().add(title, text);
                    if (mounted) {
                      if (context.read<AddTodoCubit>().state is AddTodoSubmitSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Added Successfully"))
                        );
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Add Failed"))
                        );
                      }
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
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
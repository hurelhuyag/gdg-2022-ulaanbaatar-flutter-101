import 'package:demo_todos_flutter/blocs/todos_cubit.dart';
import 'package:demo_todos_flutter/pages/todo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'add_todo_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Our Todos"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<TodosCubit>().load();
            },
            icon: const Icon(Icons.refresh)
          ),
        ],
      ),
      //body: buildGridView(context),
      body: buildStaggeredGridView(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddTodoPage()
            )
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildGridView(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int columnCount = constraints.maxWidth ~/ 200;
        final todosCubit = context.watch<TodosCubit>();
        if (todosCubit.state is TodosInitial) {
          return const Center(
            child: Text("Loading..."),
          );
        }
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnCount,
          ),
          itemBuilder: (context, index) {
            final todo = todosCubit.todos[index];
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => TodoPage(
                  todo: todo,
                ),));
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(todo.title, style: Theme.of(context).textTheme.titleSmall,),
                      Expanded(
                          child: Text(
                            todo.text,
                            maxLines: 14,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: todosCubit.todos.length,
        );
      }
    );
  }

  Widget buildStaggeredGridView(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final int columnCount = constraints.maxWidth ~/ 200;
      final todosCubit = context.watch<TodosCubit>();
      final state = todosCubit.state;
      if (state is TodosInitial) {
        return const Center(
          child: Text("Loading..."),
        );
      }
      if (state is TodosLoadFailed) {
        return Center(
          child: Text("Error: ${state.message}"),
        );
      }

      return MasonryGridView.builder(
        gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount,
        ),
        itemCount: todosCubit.todos.length,
        itemBuilder: (BuildContext context, int index) {
          final todo = todosCubit.todos[index];
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TodoPage(
                todo: todo,
              ),));
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(todo.title, style: Theme.of(context).textTheme.titleSmall,),
                    Text(todo.text),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
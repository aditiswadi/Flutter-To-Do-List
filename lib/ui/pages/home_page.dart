import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/blocs/todos/todos_bloc.dart';
import 'package:to_do_list/blocs/todos_filter/todos_filter_bloc.dart';
import 'package:to_do_list/models/todos_filter_model.dart';
import 'package:to_do_list/models/todos_model.dart';
import 'package:to_do_list/ui/pages/add_todo_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('To Dos'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddTodoPage(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
            ),
          ],
          bottom: TabBar(
            onTap: (tabIndex) {
              switch (tabIndex) {
                case 0:
                  BlocProvider.of<TodosFilterBloc>(context).add(
                    const UpdateTodos(todosFilter: TodosFilter.pending),
                  );
                  break;
                case 1:
                  BlocProvider.of<TodosFilterBloc>(context).add(
                    const UpdateTodos(todosFilter: TodosFilter.completed),
                  );
                  break;
              }
            },
            tabs: const [
              Tab(
                icon: Icon(Icons.pending),
              ),
              Tab(
                icon: Icon(Icons.add_task),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _todos('Pending To Dos'),
            _todos('Completed To Dos'),
          ],
        ),
      ),
    );
  }

  BlocConsumer<TodosFilterBloc, TodosFilterState> _todos(String title) {
    return BlocConsumer<TodosFilterBloc, TodosFilterState>(
        listener: (context, state) {
      if (state is TodosFilterLoaded) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${state.filteredTodos.length}'),
          ),
        );
      }
    }, builder: (context, state) {
      if (state is TodosFilterLoading) {
        return const CircularProgressIndicator();
      }
      if (state is TodosFilterLoaded) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: state.filteredTodos.length,
                itemBuilder: (BuildContext context, int index) {
                  return _todoCard(context, state.filteredTodos[index]);
                },
              ),
            ],
          ),
        );
      } else {
        return const Text('Something went wrong!');
      }
    });
  }

  Card _todoCard(BuildContext context, Todo todo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '#${todo.id}: ${todo.task}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    context.read<TodosBloc>().add(
                          UpdateTodo(
                            todo: todo.copyWith(isCompleted: true),
                          ),
                        );
                  },
                  icon: const Icon(Icons.add_task),
                ),
                IconButton(
                  onPressed: () {
                    context.read<TodosBloc>().add(
                          DeleteTodo(todo: todo),
                        );
                  },
                  icon: const Icon(Icons.cancel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

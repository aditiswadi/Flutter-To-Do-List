import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/blocs/todos/todos_bloc.dart';
import 'package:to_do_list/blocs/todos_filter/todos_filter_bloc.dart';
import 'package:to_do_list/models/todos_model.dart';
import 'package:to_do_list/ui/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TodosBloc()
            ..add(
              LoadTodos(
                todos: [
                  Todo(
                    id: '1',
                    task: 'Sample 1',
                    description: 'Test To Do',
                  ),
                  Todo(
                    id: '2',
                    task: 'Sample 2',
                    description: 'Test To Do',
                  ),
                ],
              ),
            ),
        ),
        BlocProvider(
          create: (context) => TodosFilterBloc(
            todosBloc: BlocProvider.of<TodosBloc>(context),
          ),
        )
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}

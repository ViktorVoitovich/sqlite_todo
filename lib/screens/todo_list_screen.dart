import 'package:flutter/material.dart';
import 'package:sqlite_todo/models/todo_model.dart';
import 'package:sqlite_todo/services/database_service.dart';
import 'package:sqlite_todo/widgets/todo_tile.dart';
import 'package:sqlite_todo/widgets/todos_overview.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _getTodos();
  }

  Future<void> _getTodos() async {
    final todos = await DatabaseService.instance.getAllTodos();
    if (mounted) {
      setState(() => _todos = todos);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          itemBuilder: (BuildContext ctx, int index) {
            if (index == 0) {
              return TodosOverview(todos: _todos);
            }
            return TodoTile(todo: _todos[index - 1]);
          },
          separatorBuilder: (_, __) => const Divider(),
          itemCount: 3, // _todos.length + 1,
        ),
      ),
    );
  }
}

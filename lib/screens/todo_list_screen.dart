import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import 'add_todo_screen.dart';
import '../services/database_service.dart';
import '../widgets/todo_tile.dart';
import '../widgets/todos_overview.dart';

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
            final todo = Todo(
              id: 0,
              name: 'Eat food',
              date: DateTime.now(),
              priorityLevel: PriorityLevel.low,
              completed: false,
            );
            return TodoTile(todo: todo);
          },
          separatorBuilder: (_, __) => const Divider(),
          itemCount: 3, // _todos.length + 1,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => AddtodoScreen(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

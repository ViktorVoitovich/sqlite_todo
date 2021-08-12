import 'package:flutter/material.dart';
import 'package:sqlite_todo/screens/todo_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SQFlite TODOs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      home: TodoListScreen(),
    );
  }
}

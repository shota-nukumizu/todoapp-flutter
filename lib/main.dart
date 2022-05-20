import 'package:flutter/material.dart';
import 'todo_list_page.dart';

void main() {
  runApp(const TodoListApp());
}

class TodoListApp extends StatelessWidget {
  const TodoListApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todoリスト',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const TodoListPage(),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/todo_model.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Add Task")),
      body: Center(
          child: Column(
        children: [
          FractionallySizedBox(
              widthFactor: 0.75,
              child: TextField(
                controller: myController,
              )),
          ElevatedButton(
              onPressed: () async {
                final task = Todo(task: myController.text, isCompleted: false);
                Navigator.pop(context, task);
              },
              child: const Text("Add Task"))
        ],
      )),
    );
  }
}

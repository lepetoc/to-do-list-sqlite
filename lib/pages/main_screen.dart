import 'package:flutter/material.dart';
import 'package:todo_app_sqlite_freezed/listview.dart';
import '../database_helper.dart';
import '../models/todo_model.dart';
import 'add_task_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<Todo>>(
          future: DatabaseHelper.instance.getAllTodos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Erreur : ${snapshot.error}');
            }
            final todos = snapshot.data!;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return Dismissible(
                    background: Container(
                      color: Colors.red,
                    ),
                    key: Key(todo.id.toString()),
                    onDismissed: (direction) {
                      setState(() {
                        DatabaseHelper.instance.delete(todo.id!);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('La tache ${todo.task} a été supprimée')));
                    },
                    child: CheckboxListTile(
                      title: Text(todo.task),
                      value: todo.isCompleted,
                      onChanged: (bool? newValue) {
                        setState(() {
                          final newTodo = todo.copyWith(isCompleted: newValue!);
                          DatabaseHelper.instance.update(newTodo);
                        });
                      },
                    ));
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          dynamic toAdd = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddTask(),
              ));
          if (toAdd != null && toAdd.task!.isNotEmpty) {
            setState(() {
              DatabaseHelper.instance.insert(toAdd);
            });
          }
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}

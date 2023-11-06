import 'package:flutter/material.dart';
import 'database_helper.dart';

class ListViewWidget extends StatefulWidget {
  final todo;

  const ListViewWidget({Key? key, required this.todo}) : super(key: key);
  @override
  _ListViewWidgetState createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
                    background: Container(
                      color: Colors.red,
                    ),
                    key: Key(widget.todo.id.toString()),
                    onDismissed: (direction) {
                      setState(() {
                        DatabaseHelper.instance.delete(widget.todo.id!);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('La tache ${widget.todo.task} a été supprimée')));
                    },
                    child: CheckboxListTile(
                      title: Text(widget.todo.task),
                      value: widget.todo.isCompleted,
                      onChanged: (bool? newValue) {
                        setState(() {
                          final newTodo = widget.todo.copyWith(isCompleted: newValue!);
                          DatabaseHelper.instance.update(newTodo);
                        });
                      },
                    ));
  }
}

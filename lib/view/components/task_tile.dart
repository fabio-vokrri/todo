import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/provider/tasks_provider.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TasksProvider>(context);
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(task.id),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          provider.remove(task);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${task.title} removed"),
              action: SnackBarAction(
                label: "Undo",
                onPressed: () => provider.add(task),
              ),
            ),
          );
        }
      },
      direction: DismissDirection.endToStart,
      background: Container(
        color: theme.colorScheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(16),
        child: const Icon(Icons.delete),
      ),
      child: CheckboxListTile(
        value: task.isDone,
        onChanged: (value) => provider.toggleDone(task),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          "Due to ${DateFormat.Hm().format(task.dueTo)}",
        ),
      ),
    );
  }
}

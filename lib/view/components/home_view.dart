import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/extensions/string.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/provider/tasks_provider.dart';
import 'package:todo_app/view/components/task_tile.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.prefix});

  final String? prefix;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Priority? _selectedPriority;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TasksProvider>(context);

    if (provider.isEmpty) {
      return const Center(
        child: Text("Nothing planned"),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: provider.where((element) {
                if (_selectedPriority == null) return true;
                return element.priority == _selectedPriority;
              }).length +
              1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...Priority.values.map((priority) {
                    return InputChip(
                      label: Text(priority.name.capitalized),
                      onPressed: () {
                        _selectedPriority == priority
                            ? _selectedPriority = null
                            : _selectedPriority = priority;

                        setState(() {});
                      },
                      selected: _selectedPriority == priority,
                    );
                  }),
                ],
              );
            }

            final task = provider.where((Task task) {
              if (_selectedPriority == null) return true;
              return _selectedPriority == task.priority;
            })[index - 1];

            return TaskTile(task: task);
          },
        ),
      );
    }
  }
}

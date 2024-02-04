import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/tasks_provider.dart';
import 'package:todo_app/view/components/task_tile.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key, required this.prefix});

  final String prefix;

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  var selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TasksProvider>(context);
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox.square(
          child: CalendarDatePicker(
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            onDateChanged: (value) {
              setState(() => selectedDate = value);
            },
          ),
        ),
        const Divider(height: 0),
        Expanded(
          child: provider.getByDate(DateTime.now()).isEmpty
              ? const Center(
                  child: Text("Nothing planned for today"),
                )
              : ListView.builder(
                  itemCount: provider.getByDate(selectedDate).length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "${DateFormat.yMMMMd().format(selectedDate)} tasks",
                          style: theme.textTheme.bodyLarge,
                        ),
                      );
                    }

                    final task = provider.getByDate(selectedDate)[index - 1];
                    return TaskTile(task: task);
                  },
                ),
        ),
      ],
    );
  }
}

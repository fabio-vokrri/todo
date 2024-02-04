import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:todo_app/model/task.dart';

class TasksProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  void add(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void remove(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void toggleDone(Task task) {
    task.toggleDone();
    notifyListeners();
  }

  List<Task> where(bool Function(Task task) test) {
    return _tasks.where(test).toList();
  }

  List<Task> getByDate(DateTime dateTime) {
    return _tasks.where((Task task) {
      return task.dueTo.year == dateTime.year &&
          task.dueTo.month == dateTime.month &&
          task.dueTo.day == dateTime.day;
    }).toList();
  }

  List<Task> get getAlltasks => UnmodifiableListView(_tasks);

  int get length => _tasks.length;
  bool get isEmpty => _tasks.isEmpty;
  bool get isNotEmpty => _tasks.isNotEmpty;
}

import 'package:todo_app/model/category.dart';
import 'package:uuid/uuid.dart';

enum Priority {
  high,
  medium,
  low;
}

class Task {
  final String _id;
  final String _title;
  final DateTime _dueTo;
  final Priority _priority;
  List<Category> _categories;
  bool _isDone;

  Task({
    String? id,
    required String title,
    required DateTime dueTo,
    required Priority priority,
    bool isDone = false,
    List<Category> categories = const [],
  })  : _id = id ?? const Uuid().v8(),
        _title = title,
        _dueTo = dueTo,
        _isDone = isDone,
        _priority = priority,
        _categories = categories;

  String get id => _id;
  String get title => _title;
  DateTime get dueTo => _dueTo;
  bool get isDone => _isDone;
  Priority get priority => _priority;
  List<Category> get categories => _categories;

  void toggleDone() {
    _isDone = !_isDone;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map["id"] as String,
      title: map["title"] as String,
      dueTo: DateTime.fromMillisecondsSinceEpoch(map["dueTo"] as int),
      isDone: map["isDone"] == 1,
      priority: Priority.values.byName(map["priority"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": _id,
      "title": _title,
      "dueTo": _dueTo.millisecondsSinceEpoch,
      "isDone": _isDone ? 1 : 0,
      "priority": _priority.name,
    };
  }
}

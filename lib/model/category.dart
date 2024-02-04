import 'package:uuid/uuid.dart';

class Category {
  final String _id;
  final String _name;

  Category({required String name, String? id})
      : _id = id ?? const Uuid().v8(),
        _name = name;

  String get name => _name;
  String get id => _id;

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map["id"] as String,
      name: map["name"] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": _id,
      "name": _name,
    };
  }
}

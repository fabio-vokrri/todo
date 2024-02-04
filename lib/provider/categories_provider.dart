import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:todo_app/model/category.dart';

class CategoriesProvider extends ChangeNotifier {
  final List<Category> _categories = [];

  void add(Category category) {
    _categories.add(category);
    notifyListeners();
  }

  void remove(Category category) {
    _categories.remove(category);
    notifyListeners();
  }

  List<Category> get getAllCategories => UnmodifiableListView(_categories);
}

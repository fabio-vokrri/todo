import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/extensions/date_time.dart';
import 'package:todo_app/extensions/string.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/provider/categories_provider.dart';
import 'package:todo_app/provider/tasks_provider.dart';
import 'package:todo_app/view/components/discard_changes_dialog.dart';
import 'package:todo_app/view/pages/home.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();
  final List<Category> _selectedCategories = [];

  final _categoryController = TextEditingController();
  final _titleController = TextEditingController();
  final _dateController = TextEditingController(
    text: DateFormat.yMMMd().format(DateTime.now()),
  );
  final _timeController = TextEditingController(
    text: DateFormat.Hm().format(DateTime.now()),
  );

  var _selectedDate = DateTime.now();
  var _selectedPriority = Priority.medium;

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _categoryController.dispose();

    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
        _dateController.text = DateFormat.yMMMd().format(_selectedDate);
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        _selectedDate = _selectedDate.apply(time);
        _timeController.text = DateFormat.Hm().format(_selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasksProvider = Provider.of<TasksProvider>(context);
    final categoriesProvider = Provider.of<CategoriesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const DiscardChangesDialog(),
            );
          },
          icon: const Icon(Icons.clear),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) return;

              final task = Task(
                title: _titleController.text,
                dueTo: _selectedDate,
                isDone: false,
                priority: _selectedPriority,
                categories: _selectedCategories,
              );

              tasksProvider.add(task);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            child: const Text("Save"),
          ),
          const SizedBox(width: 16),
        ],
        title: const Text("Add new task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  focusNode: _focusNode,
                  decoration: const InputDecoration(
                    label: Text("Task name"),
                    border: OutlineInputBorder(),
                  ),
                  onTapOutside: (event) {
                    _focusNode.unfocus();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the name of the task";
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 32),
                const Text("Due to "),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        onTap: _selectDate,
                        controller: _dateController,
                        decoration: const InputDecoration(
                          label: Text("Date"),
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_month),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: _timeController,
                        onTap: _selectTime,
                        decoration: const InputDecoration(
                          label: Text("Time"),
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.schedule),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text("Priority "),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton(
                    showSelectedIcon: false,
                    segments: Priority.values.map((Priority priority) {
                      return ButtonSegment(
                        value: priority,
                        label: Text(priority.name.capitalized),
                      );
                    }).toList(),
                    selected: <Priority>{_selectedPriority},
                    onSelectionChanged: (Set<Priority> selection) {
                      setState(() => _selectedPriority = selection.first);
                    },
                  ),
                ),
                const SizedBox(height: 32),
                const Text("Category"),
                const SizedBox(height: 16),
                Wrap(
                  children: [
                    InputChip(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const AddCategoryDialog(),
                        );
                      },
                      avatar: const Icon(Icons.add),
                      label: const Text("Add new category"),
                    ),
                    ...categoriesProvider.getAllCategories.map(
                      (Category category) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: InputChip(
                            label: Text(category.name),
                            deleteIcon: const Icon(Icons.clear, size: 16),
                            selected: _selectedCategories.contains(category),
                            onPressed: () {
                              _selectedCategories.contains(category)
                                  ? _selectedCategories.remove(category)
                                  : _selectedCategories.add(category);
                              setState(() {});
                            },
                            onDeleted: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return DeleteCategoryDialog(
                                    category: category,
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeleteCategoryDialog extends StatelessWidget {
  const DeleteCategoryDialog({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoriesProvider>(context);
    return AlertDialog(
      icon: const Icon(Icons.delete),
      title: const Text("Delete Category?"),
      content: const Text(
        "Once deleted, the category cannot be recovered. "
        "Are you sure you want to proceed?",
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            categoriesProvider.remove(category);
            Navigator.pop(context);
          },
          child: const Text("Delete"),
        ),
      ],
    );
  }
}

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoriesProvider>(context);

    return AlertDialog(
      icon: const Icon(Icons.add),
      title: const Text("Add new Category"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _categoryController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text("Category name"),
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return "Add the category name";
            }

            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;

            categoriesProvider.add(
              Category(name: _categoryController.text),
            );
            Navigator.pop(context);
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}

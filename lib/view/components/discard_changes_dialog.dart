import 'package:flutter/material.dart';
import 'package:todo_app/view/pages/home.dart';

class DiscardChangesDialog extends StatelessWidget {
  const DiscardChangesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.warning),
      title: const Text("Discard changes?"),
      content: const Text(
        "Once you leave, all the filled information will be removed."
        " Are you sure you want to proceed?",
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
            Navigator.pop(context);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
          child: const Text("Leave"),
        ),
      ],
    );
  }
}

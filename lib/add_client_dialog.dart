// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class AddClientDialog extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onAdd;

  const AddClientDialog({
    super.key,
    required this.controller,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Client'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: 'Enter client name'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final newClient = controller.text;
            onAdd(newClient);
            controller.clear();
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

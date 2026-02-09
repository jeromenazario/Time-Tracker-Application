import 'package:flutter/material.dart';

Future<String?> showAddTaskDialog(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  String name = '';

  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Add Task'),
      content: Form(
        key: formKey,
        child: TextFormField(
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Task name',
            hintText: 'Enter task name',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a task name';
            }
            return null;
          },
          onChanged: (v) => name = v,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              Navigator.of(context).pop(name.trim());
            }
          },
          child: Text('Add'),
        ),
      ],
    ),
  );
}

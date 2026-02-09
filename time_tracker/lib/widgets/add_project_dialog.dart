import 'package:flutter/material.dart';

Future<String?> showAddProjectDialog(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  String name = '';

  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Add Project'),
      content: Form(
        key: formKey,
        child: TextFormField(
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Project name',
            hintText: 'Enter project name',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a project name';
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

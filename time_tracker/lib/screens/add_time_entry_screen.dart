import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';
import '../providers/project_task_provider.dart';
import '../widgets/add_project_dialog.dart';
import '../widgets/add_task_dialog.dart';

class AddTimeEntryScreen extends StatefulWidget {
  final String? initialProject;

  const AddTimeEntryScreen({Key? key, this.initialProject}) : super(key: key);

  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? projectId;
  String? taskId;
  double totalTime = 0.0;
  DateTime date = DateTime.now();
  String notes = '';

  static const String _addProjectValue = '__ADD_PROJECT__';
  static const String _addTaskValue = '__ADD_TASK__';

  @override
  void initState() {
    super.initState();
    if (widget.initialProject != null && widget.initialProject!.isNotEmpty) {
      projectId = widget.initialProject;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Time Entry')),
      body: Consumer<ProjectTaskProvider>(
        builder: (context, projectTaskProvider, _) {
          final projects = projectTaskProvider.projects;
          final tasks = projectTaskProvider.tasks;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Time Entry Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F1F3D),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Project',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F1F3D),
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: projectId,
                      onChanged: (String? newValue) async {
                        if (newValue == _addProjectValue) {
                          final name = await showAddProjectDialog(context);
                          if (name != null && name.isNotEmpty) {
                            projectTaskProvider.addProject(name);
                            setState(() {
                              projectId = name;
                            });
                          }
                          return;
                        }
                        setState(() {
                          projectId = newValue;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Select project',
                        prefixIcon: Icon(
                          Icons.folder,
                          color: Color(0xFF5B5BFF),
                        ),
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        ...projects.map<DropdownMenuItem<String>>((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        DropdownMenuItem<String>(
                          value: _addProjectValue,
                          child: Text('Add project...'),
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a project';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Task',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F1F3D),
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: taskId,
                      onChanged: (String? newValue) async {
                        if (newValue == _addTaskValue) {
                          final name = await showAddTaskDialog(context);
                          if (name != null && name.isNotEmpty) {
                            projectTaskProvider.addTask(name);
                            setState(() {
                              taskId = name;
                            });
                          }
                          return;
                        }
                        setState(() {
                          taskId = newValue;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Select task',
                        prefixIcon: Icon(Icons.task, color: Color(0xFF5B5BFF)),
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        ...tasks.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        DropdownMenuItem<String>(
                          value: _addTaskValue,
                          child: Text('Add task...'),
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a task';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Duration',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F1F3D),
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Total Time (hours)',
                        prefixIcon: Icon(
                          Icons.schedule,
                          color: Color(0xFF5B5BFF),
                        ),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter total time';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      onSaved: (value) => totalTime = double.parse(value!),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Date',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F1F3D),
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Select date',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: Color(0xFF5B5BFF),
                        ),
                      ),
                      controller: TextEditingController(
                        text:
                            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
                      ),
                      onTap: () => _selectDate(context),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Notes',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F1F3D),
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Add notes...',
                        border: OutlineInputBorder(),
                        hintText: 'Enter any notes about this time entry',
                      ),
                      maxLines: 4,
                      onSaved: (value) => notes = value ?? '',
                    ),
                    SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            if (projectId != null && taskId != null) {
                              context.read<TimeEntryProvider>().addTimeEntry(
                                TimeEntry(
                                  id: DateTime.now().millisecondsSinceEpoch
                                      .toString(),
                                  projectId: projectId!,
                                  taskId: taskId!,
                                  totalTime: totalTime,
                                  date: date,
                                  notes: notes,
                                ),
                              );
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text('Save Time Entry'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

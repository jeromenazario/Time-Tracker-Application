import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_task_provider.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/app_drawer.dart';

class TaskManagementScreen extends StatelessWidget {
  const TaskManagementScreen({super.key});

  Future<void> _addTask(BuildContext context) async {
    final name = await showAddTaskDialog(context);
    if (name != null && name.isNotEmpty) {
      context.read<ProjectTaskProvider>().addTask(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Tasks')),
      drawer: const AppDrawer(),
      body: Consumer<ProjectTaskProvider>(
        builder: (context, provider, child) {
          return provider.tasks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.task, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('No tasks yet. Tap + to add one.'),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: provider.tasks.length,
                  padding: EdgeInsets.all(12),
                  itemBuilder: (context, index) {
                    final item = provider.tasks[index];
                    return Dismissible(
                      key: ValueKey(item + index.toString()),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => provider.removeTask(index),
                      background: Container(
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      child: Card(
                        margin: EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.task,
                            color: Color(0xFF5B5BFF),
                            size: 28,
                          ),
                          title: Text(
                            item,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xFF1F1F3D),
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTask(context),
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }
}

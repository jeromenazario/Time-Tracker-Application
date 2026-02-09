import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/add_project_dialog.dart';
import '../widgets/app_drawer.dart';
import '../providers/project_task_provider.dart';

class ProjectManagementScreen extends StatelessWidget {
  const ProjectManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Projects')),
      drawer: const AppDrawer(),
      body: Consumer<ProjectTaskProvider>(
        builder: (context, provider, child) {
          return provider.projects.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.folder_open, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('No projects yet. Tap + to add one.'),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: provider.projects.length,
                  itemBuilder: (context, index) {
                    final item = provider.projects[index];
                    return Dismissible(
                      key: ValueKey(item + index.toString()),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => provider.removeProject(index),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(title: Text(item)),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final name = await showAddProjectDialog(context);
          if (name != null && name.isNotEmpty) {
            context.read<ProjectTaskProvider>().addProject(name);
          }
        },
        tooltip: 'Add Project',
        child: Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/time_entry_provider.dart';
import 'add_time_entry_screen.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Time Entries')),
      drawer: const AppDrawer(),
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          // Group entries by projectId (project name used as id)
          final Map<String, List> grouped = {};
          for (final e in provider.entries) {
            final key = e.projectId;
            grouped.putIfAbsent(key, () => []).add(e);
          }

          if (grouped.isEmpty) {
            return Center(child: Text('No time entries yet'));
          }

          final projectKeys = grouped.keys.toList();

          return ListView.builder(
            itemCount: projectKeys.length,
            padding: EdgeInsets.all(12),
            itemBuilder: (context, idx) {
              final project = projectKeys[idx];
              final entries = grouped[project] as List;
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  leading: Icon(
                    Icons.folder,
                    color: Color(0xFF5B5BFF),
                    size: 28,
                  ),
                  tilePadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  title: Text(
                    project,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F1F3D),
                    ),
                  ),
                  subtitle: Text(
                    '${entries.length} entries',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Color(0xFF5B5BFF),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddTimeEntryScreen(initialProject: project),
                        ),
                      );
                    },
                  ),
                  children: entries.map<Widget>((entry) {
                    return Dismissible(
                      key: ValueKey(entry.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.delete_outline, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        Provider.of<TimeEntryProvider>(
                          context,
                          listen: false,
                        ).deleteTimeEntry(entry.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Deleted time entry')),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.schedule,
                            color: Color(0xFF5B5BFF),
                            size: 24,
                          ),
                          title: Text(
                            '${entry.totalTime} hours - ${entry.taskId}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F1F3D),
                            ),
                          ),
                          subtitle: Text(
                            '${entry.date.toString().split(' ')[0]}' +
                                (entry.notes.isNotEmpty
                                    ? ' • ${entry.notes}'
                                    : ''),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the screen to add a new time entry
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTimeEntryScreen()),
          );
        },
        tooltip: 'Add Time Entry',
        child: Icon(Icons.add),
      ),
    );
  }
}

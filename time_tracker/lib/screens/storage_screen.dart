import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../widgets/app_drawer.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  Map<String, int> _stats = {'projects': 0, 'tasks': 0, 'timeEntries': 0};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await StorageService.getStorageStats();
    setState(() {
      _stats = stats;
      _isLoading = false;
    });
  }

  Future<void> _clearAllData() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear All Data?'),
        content: Text(
          'This will permanently delete all projects, tasks, and time entries. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await StorageService.clearAllData();
      await _loadStats();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('All data cleared')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Storage & Data'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadStats,
            tooltip: 'Refresh',
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Storage Statistics',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F1F3D),
                      ),
                    ),
                    SizedBox(height: 24),
                    // Projects Card
                    _buildStatCard(
                      title: 'Projects',
                      count: _stats['projects'] ?? 0,
                      icon: Icons.folder,
                      color: Color(0xFF5B5BFF),
                    ),
                    SizedBox(height: 12),
                    // Tasks Card
                    _buildStatCard(
                      title: 'Tasks',
                      count: _stats['tasks'] ?? 0,
                      icon: Icons.task,
                      color: Color(0xFF00B8A9),
                    ),
                    SizedBox(height: 12),
                    // Time Entries Card
                    _buildStatCard(
                      title: 'Time Entries',
                      count: _stats['timeEntries'] ?? 0,
                      icon: Icons.schedule,
                      color: Color(0xFFFFA502),
                    ),
                    SizedBox(height: 32),
                    Text(
                      'Data Management',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F1F3D),
                      ),
                    ),
                    SizedBox(height: 16),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.storage,
                              color: Color(0xFF5B5BFF),
                            ),
                            title: Text(
                              'Storage Location',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F1F3D),
                              ),
                            ),
                            subtitle: Text(
                              'Local device storage (Hive)',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                            trailing: Icon(
                              Icons.info_outline,
                              color: Colors.grey,
                            ),
                          ),
                          Divider(height: 0),
                          ListTile(
                            leading: Icon(
                              Icons.cloud_off,
                              color: Color(0xFF5B5BFF),
                            ),
                            title: Text(
                              'Sync Status',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F1F3D),
                              ),
                            ),
                            subtitle: Text(
                              'Data is stored locally only',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                            trailing: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Danger Zone',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F1F3D),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _clearAllData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade400,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_forever, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Clear All Data',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFACD),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.shade300,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info,
                                color: Colors.orange.shade700,
                                size: 24,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'About Storage',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange.shade900,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Your data is stored securely on your device using Hive, a fast and efficient local storage solution. All data persists between app sessions.',
                            style: TextStyle(
                              color: Colors.orange.shade800,
                              height: 1.5,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withAlpha(10), color.withAlpha(5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F1F3D),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

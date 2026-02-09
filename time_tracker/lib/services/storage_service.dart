import 'package:hive/hive.dart';
import '../models/time_entry.dart';

class StorageService {
  static const String projectsBox = 'projects';
  static const String tasksBox = 'tasks';
  static const String timeEntriesBox = 'timeEntries';

  // Initialize Hive
  static Future<void> init() async {
    try {
      // Open/create boxes
      await Hive.openBox<String>(projectsBox);
      await Hive.openBox<String>(tasksBox);
      await Hive.openBox<String>(timeEntriesBox);
    } catch (e) {
      print('Error initializing Hive: $e');
    }
  }

  // Projects
  static Future<List<String>> getProjects() async {
    try {
      final box = Hive.box<String>(projectsBox);
      return box.values.toList();
    } catch (e) {
      print('Error getting projects: $e');
      return [];
    }
  }

  static Future<void> saveProjects(List<String> projects) async {
    try {
      final box = Hive.box<String>(projectsBox);
      await box.clear();
      for (int i = 0; i < projects.length; i++) {
        await box.put(i.toString(), projects[i]);
      }
    } catch (e) {
      print('Error saving projects: $e');
    }
  }

  // Tasks
  static Future<List<String>> getTasks() async {
    try {
      final box = Hive.box<String>(tasksBox);
      return box.values.toList();
    } catch (e) {
      print('Error getting tasks: $e');
      return [];
    }
  }

  static Future<void> saveTasks(List<String> tasks) async {
    try {
      final box = Hive.box<String>(tasksBox);
      await box.clear();
      for (int i = 0; i < tasks.length; i++) {
        await box.put(i.toString(), tasks[i]);
      }
    } catch (e) {
      print('Error saving tasks: $e');
    }
  }

  // Time Entries
  static Future<List<Map<String, dynamic>>> getTimeEntries() async {
    try {
      final box = Hive.box<String>(timeEntriesBox);
      print(
        '📖 Reading time entries from storage... Found ${box.length} entries',
      );

      List<Map<String, dynamic>> entries = [];
      for (var value in box.values) {
        try {
          entries.add(_parseTimeEntry(value));
        } catch (e) {
          print('⚠️ Failed to parse entry: $e, raw data: $value');
        }
      }

      print('✅ Successfully loaded ${entries.length} time entries');
      return entries;
    } catch (e) {
      print('❌ Error getting time entries: $e');
      return [];
    }
  }

  static Future<void> saveTimeEntries(List<TimeEntry> entries) async {
    try {
      final box = Hive.box<String>(timeEntriesBox);
      await box.clear();
      print('Saving ${entries.length} time entries to storage...');

      for (int i = 0; i < entries.length; i++) {
        final json = _timeEntryToJson(entries[i]);
        await box.put(i.toString(), json);
        print(
          'Saved entry ${i + 1}: ${entries[i].id} - ${entries[i].projectId} (${entries[i].totalTime}h)',
        );
      }

      print('✅ All ${entries.length} entries saved successfully');
    } catch (e) {
      print('❌ Error saving time entries: $e');
    }
  }

  // Helper methods for serialization using :: delimiter
  static String _timeEntryToJson(TimeEntry entry) {
    return '${entry.id}::${entry.projectId}::${entry.taskId}::${entry.totalTime}::${entry.date.toIso8601String()}::${entry.notes}';
  }

  static Map<String, dynamic> _parseTimeEntry(String data) {
    final parts = data.split('::');
    if (parts.length < 5) {
      throw Exception('Invalid time entry format');
    }
    return {
      'id': parts[0],
      'projectId': parts[1],
      'taskId': parts[2],
      'totalTime': double.tryParse(parts[3]) ?? 0.0,
      'date': DateTime.tryParse(parts[4]) ?? DateTime.now(),
      'notes': parts.length > 5 ? parts.sublist(5).join('::') : '',
    };
  }

  // Get storage stats
  static Future<Map<String, int>> getStorageStats() async {
    try {
      final projectsBox = Hive.box<String>(StorageService.projectsBox);
      final tasksBox = Hive.box<String>(StorageService.tasksBox);
      final timeEntriesBox = Hive.box<String>(StorageService.timeEntriesBox);

      return {
        'projects': projectsBox.length,
        'tasks': tasksBox.length,
        'timeEntries': timeEntriesBox.length,
      };
    } catch (e) {
      print('Error getting storage stats: $e');
      return {'projects': 0, 'tasks': 0, 'timeEntries': 0};
    }
  }

  // Clear all data
  static Future<void> clearAllData() async {
    try {
      final projectsBox = Hive.box<String>(StorageService.projectsBox);
      final tasksBox = Hive.box<String>(StorageService.tasksBox);
      final timeEntriesBox = Hive.box<String>(StorageService.timeEntriesBox);

      await projectsBox.clear();
      await tasksBox.clear();
      await timeEntriesBox.clear();
    } catch (e) {
      print('Error clearing data: $e');
    }
  }
}

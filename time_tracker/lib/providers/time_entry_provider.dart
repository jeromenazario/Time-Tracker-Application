import 'package:flutter/foundation.dart';
import '../models/time_entry.dart';
import '../services/storage_service.dart';

class TimeEntryProvider with ChangeNotifier {
  final List<TimeEntry> _entries = [];
  bool _isLoaded = false;

  List<TimeEntry> get entries => _entries;
  bool get isLoaded => _isLoaded;

  // Load data from storage on initialization
  Future<void> loadFromStorage() async {
    if (_isLoaded) return;

    try {
      final savedData = await StorageService.getTimeEntries();
      _entries.clear();

      for (var data in savedData) {
        _entries.add(
          TimeEntry(
            id: data['id'] as String,
            projectId: data['projectId'] as String,
            taskId: data['taskId'] as String,
            totalTime: data['totalTime'] as double,
            date: data['date'] as DateTime,
            notes: data['notes'] as String,
          ),
        );
      }

      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      print('Error loading time entries from storage: $e');
    }
  }

  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    notifyListeners();
    _saveTimeEntries();
  }

  void deleteTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    notifyListeners();
    _saveTimeEntries();
  }

  void _saveTimeEntries() {
    StorageService.saveTimeEntries(_entries)
        .then((_) {
          print('Time entries saved: ${_entries.length} entries');
        })
        .catchError((e) {
          print('Error saving time entries: $e');
        });
  }
}

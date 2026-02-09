import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

class ProjectTaskProvider with ChangeNotifier {
  final List<String> _projects = ['Project 1', 'Project 2', 'Project 3'];
  final List<String> _tasks = ['Task 1', 'Task 2', 'Task 3'];
  bool _isLoaded = false;

  List<String> get projects => _projects;
  List<String> get tasks => _tasks;
  bool get isLoaded => _isLoaded;

  // Load data from storage on initialization
  Future<void> loadFromStorage() async {
    if (_isLoaded) return;

    try {
      final savedProjects = await StorageService.getProjects();
      final savedTasks = await StorageService.getTasks();

      if (savedProjects.isNotEmpty) {
        _projects.clear();
        _projects.addAll(savedProjects);
      }

      if (savedTasks.isNotEmpty) {
        _tasks.clear();
        _tasks.addAll(savedTasks);
      }

      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      print('Error loading from storage: $e');
    }
  }

  void addProject(String name) {
    if (name.isNotEmpty && !_projects.contains(name)) {
      _projects.add(name);
      _saveProjects();
      notifyListeners();
    }
  }

  void removeProject(int index) {
    if (index >= 0 && index < _projects.length) {
      _projects.removeAt(index);
      _saveProjects();
      notifyListeners();
    }
  }

  void addTask(String name) {
    if (name.isNotEmpty && !_tasks.contains(name)) {
      _tasks.add(name);
      _saveTasks();
      notifyListeners();
    }
  }

  void removeTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      _tasks.removeAt(index);
      _saveTasks();
      notifyListeners();
    }
  }

  Future<void> _saveProjects() async {
    await StorageService.saveProjects(_projects);
  }

  Future<void> _saveTasks() async {
    await StorageService.saveTasks(_tasks);
  }
}

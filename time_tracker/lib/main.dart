import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'providers/time_entry_provider.dart';
import 'providers/project_task_provider.dart';
import 'services/storage_service.dart';
import 'screens/home_screen.dart';
import 'screens/add_time_entry_screen.dart';
import 'screens/project_management_screen.dart';
import 'screens/task_management_screen.dart';
import 'screens/storage_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  await StorageService.init();

  runApp(const TimeTrackerApp());
}

class TimeTrackerApp extends StatelessWidget {
  const TimeTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final provider = TimeEntryProvider();
            provider.loadFromStorage();
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final provider = ProjectTaskProvider();
            provider.loadFromStorage();
            return provider;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Time Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF5B5BFF)),
          useMaterial3: true,
          scaffoldBackgroundColor: Color(0xFFFAFAFC),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF1F1F3D),
            elevation: 2,
            shadowColor: Colors.black.withAlpha(10),
            iconTheme: IconThemeData(color: Color(0xFF5B5BFF), size: 24),
            titleTextStyle: TextStyle(
              color: Color(0xFF1F1F3D),
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shadowColor: Colors.black.withAlpha(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Color(0xFFF5F5F7),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF5B5BFF), width: 2),
            ),
            labelStyle: TextStyle(
              color: Color(0xFF1F1F3D),
              fontWeight: FontWeight.w500,
            ),
            hintStyle: TextStyle(color: Colors.grey.shade400),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF5B5BFF),
              foregroundColor: Colors.white,
              elevation: 2,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF5B5BFF),
            foregroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          listTileTheme: ListTileThemeData(
            titleTextStyle: TextStyle(
              color: Color(0xFF1F1F3D),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            subtitleTextStyle: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/add': (context) => AddTimeEntryScreen(),
          '/projects': (context) => ProjectManagementScreen(),
          '/tasks': (context) => TaskManagementScreen(),
          '/storage': (context) => StorageScreen(),
        },
      ),
    );
  }
}

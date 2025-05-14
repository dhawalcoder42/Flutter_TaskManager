import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/config/routes.dart';
import 'package:task_manager_app/config/theme.dart';
import 'package:task_manager_app/data/datasources/local/task_db.dart';
import 'package:task_manager_app/data/datasources/remote/task_api.dart';
import 'package:task_manager_app/data/repositories/task_repository.dart';
import 'package:task_manager_app/domain/repositories/i_task_repository.dart';
import 'package:task_manager_app/presentation/bloc/task/task_bloc.dart';
import 'package:task_manager_app/presentation/bloc/task/task_event.dart';
import 'package:task_manager_app/presentation/screens/home_screen.dart';
import 'package:task_manager_app/presentation/screens/task_list_screen.dart';
import 'package:task_manager_app/presentation/screens/task_form_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Initialize the local database
  final taskDb = TaskDatabase.instance;

  // Use the mock factory for development and testing
  final apiService = TaskApiService.mock();

  // Initialize connectivity
  final connectivity = Connectivity();

  // Create repository with required parameters
  final ITaskRepository taskRepository = TaskRepository(
    localDb: taskDb,
    apiService: apiService,
    connectivity: connectivity,
  );

  runApp(MyApp(taskRepository: taskRepository));
}

class MyApp extends StatelessWidget {
  final ITaskRepository taskRepository;

  const MyApp({super.key, required this.taskRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(
          create: (context) =>
              TaskBloc(taskRepository: taskRepository)..add(const LoadTasksEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Task Manager',
        theme: AppTheme.lightTheme,
        darkTheme: ThemeData.dark().copyWith(
          primaryColor: Colors.green[700],
          colorScheme: ColorScheme.dark(
            primary: Colors.green[700]!,
            secondary: Colors.green[500]!,
          ),
        ),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.home,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: const HomeScreen(),
        routes: {
          '/tasks': (context) => const TaskListScreen(),
          '/task/new': (context) => const TaskFormScreen(),
        },
      ),
    );
  }
}

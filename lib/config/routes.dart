import 'package:flutter/material.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/task_detail_screen.dart' as detail;
import '../presentation/screens/task_form_screen.dart';
import '../presentation/screens/task_list_screen.dart' as list;

class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String taskList = '/tasks';
  static const String taskDetail = '/task-detail';
  static const String taskForm = '/task-form';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case taskList:
        return MaterialPageRoute(builder: (_) => const list.TaskListScreen());
      case taskDetail:
        final args = settings.arguments as Map<String, dynamic>;
        final taskId = args['taskId'] as int;
        return MaterialPageRoute(
          builder: (_) => detail.TaskDetailScreen(taskId: taskId),
        );
      case taskForm:
        final args = settings.arguments as Map<String, dynamic>?;
        final taskId = args?['taskId'] as int?;
        return MaterialPageRoute(
          builder: (_) => TaskFormScreen(taskId: taskId),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

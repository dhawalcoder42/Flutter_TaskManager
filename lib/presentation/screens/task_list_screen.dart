import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/task.dart';
import '../../../presentation/bloc/task/task_bloc.dart';
import '../../../presentation/bloc/task/task_event.dart';
import '../../../presentation/bloc/task/task_state.dart';
import '../../../presentation/widgets/loading_indicator.dart';
import '../../../core/util/date_formatter.dart';
import '../../../config/routes.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.taskForm);
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state.status == TaskStateStatus.loading) {
            return const LoadingIndicator(message: 'Loading tasks...');
          } else if (state.status == TaskStateStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.errorMessage}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TaskBloc>().add(const LoadTasksEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state.tasks.isEmpty) {
            return const Center(child: Text('No tasks available.'));
          }

          return ListView.builder(
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              final task = state.tasks[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(task.title),
                  subtitle: Text(DateFormatter.formatDate(task.createdDate)),
                  trailing: _buildStatusIcon(task.status),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.taskDetail, // ✅ Corrected
                      arguments: {'taskId': task.id}, // ✅ Corrected
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return const Icon(Icons.radio_button_unchecked, color: Colors.grey);
      case TaskStatus.inProgress:
        return const Icon(Icons.timelapse, color: Colors.orange);
      case TaskStatus.done:
        return const Icon(Icons.check_circle, color: Colors.green);
    }
  }
}

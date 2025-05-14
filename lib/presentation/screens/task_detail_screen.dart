import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/task.dart';
import '../../../presentation/bloc/task/task_bloc.dart';
import '../../../presentation/bloc/task/task_event.dart';  // Updated import
import '../../../presentation/bloc/task/task_state.dart';
import '../../../presentation/widgets/loading_indicator.dart';
import '../../../core/util/date_formatter.dart';
import '../../../config/routes.dart';

class TaskDetailScreen extends StatelessWidget {
  final int taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    // Fetch the specific task
    context.read<TaskBloc>().add(LoadTaskEvent(taskId));  // ✅ Corrected

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.taskForm,
                arguments: taskId,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state.status == TaskStateStatus.loading) {
            return const LoadingIndicator(message: 'Loading task details...');
          } else if (state.status == TaskStateStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.errorMessage}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TaskBloc>().add(LoadTaskEvent(taskId)); // ✅ Corrected
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            final task = state.selectedTask;

            if (task == null) {
              return const Center(
                child: Text('Task not found'),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  task.title,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              _buildPriorityChip(task.priority),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Created on: ${DateFormatter.formatDate(task.createdDate)}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Description:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            task.description,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Status:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildStatusChip(task.status),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildPriorityChip(TaskPriority priority) {
    Color chipColor;
    String label = priority.toString().split('.').last;

    switch (priority) {
      case TaskPriority.high:
        chipColor = Colors.red;
        break;
      case TaskPriority.medium:
        chipColor = Colors.orange;
        break;
      case TaskPriority.low:
        chipColor = Colors.green;
        break;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: chipColor,
    );
  }

  Widget _buildStatusChip(TaskStatus status) {
    Color chipColor;
    String label = status.toString().split('.').last;

    switch (status) {
      case TaskStatus.todo:
        chipColor = Colors.blue;
        break;
      case TaskStatus.inProgress:
        chipColor = Colors.orange;
        break;
      case TaskStatus.done:
        chipColor = Colors.green;
        break;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: chipColor,
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TaskBloc>().add(DeleteTaskEvent(taskId)); // ✅ Corrected
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to previous screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

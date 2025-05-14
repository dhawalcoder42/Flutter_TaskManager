import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/routes.dart';
import '../../../presentation/bloc/task/task_bloc.dart';
import '../../../presentation/bloc/task/task_event.dart';
import '../../../presentation/bloc/task/task_state.dart';
import '../../../presentation/widgets/loading_indicator.dart';
import '../../../presentation/widgets/task_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(const LoadTasksEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'), // 'const' added here
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh), // 'const' added here
            onPressed: () {
              context.read<TaskBloc>().add(const LoadTasksEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state.status == TaskStateStatus.initial || 
              state.status == TaskStateStatus.loading) {
            return const LoadingIndicator(message: 'Loading tasks...'); // 'const' added here
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
                  const ElevatedButton( // 'const' added here
                    onPressed: null, // Update the onPressed logic as needed
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            if (state.tasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text( // 'const' added here
                      'No tasks found',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.taskForm,
                        );
                      },
                      child: const Text('Add Task'),
                    ),
                  ],
                ),
              );
            }
            
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TaskBloc>().add(const LoadTasksEvent());
                return;
              },
              child: ListView.builder(
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return Dismissible(
                    key: Key('task_${task.id}'),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16.0),
                      child: const Icon( // 'const' added here
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AlertDialog( // 'const' added here
                            title: Text('Delete Task'),
                            content: Text('Are you sure you want to delete this task?'),
                            actions: [
                              TextButton(
                                onPressed: null, // Update the onPressed logic as needed
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: null, // Update the onPressed logic as needed
                                child: Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (direction) {
                      context.read<TaskBloc>().add(DeleteTaskEvent(task.id!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Task deleted'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              context.read<TaskBloc>().add(CreateTaskEvent(task));
                            },
                          ),
                        ),
                      );
                    },
                    child: TaskListItem(
                      task: task,
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.taskDetail,
                          arguments: task.id,
                        );
                      },
                      onStatusChanged: (newStatus) {
                        // Handle status change logic here
                      },
                      onDelete: () {
                        // Handle delete logic here
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.taskForm);
        },
        child: const Icon(Icons.add), // 'const' added here
      ),
    );
  }
}

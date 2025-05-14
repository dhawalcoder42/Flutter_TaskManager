import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/task.dart';
import '../../../presentation/bloc/task/task_bloc.dart';
import '../../../presentation/bloc/task/task_event.dart';
import '../../../presentation/bloc/task/task_state.dart';
import '../../../presentation/widgets/loading_indicator.dart';

class TaskFormScreen extends StatefulWidget {
  final int? taskId;

  const TaskFormScreen({super.key, this.taskId});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  TaskPriority _selectedPriority = TaskPriority.medium;
  TaskStatus _selectedStatus = TaskStatus.todo;
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _isEditing = widget.taskId != null;

    if (_isEditing) {
      _loadTaskData();
    }
  }

  void _loadTaskData() {
    setState(() => _isLoading = true);
    context.read<TaskBloc>().add(LoadTaskEvent(widget.taskId!));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Task' : 'Create Task'),
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state.status == TaskStateStatus.loaded && _isEditing && _isLoading) {
            if (state.selectedTask != null) {
              setState(() {
                _titleController.text = state.selectedTask!.title;
                _descriptionController.text = state.selectedTask!.description;
                _selectedPriority = state.selectedTask!.priority;
                _selectedStatus = state.selectedTask!.status;
                _isLoading = false;
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error: Task not found')),
              );
              Navigator.pop(context);
            }
          } else if (state.status == TaskStateStatus.error && _isLoading) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.errorMessage}')),
            );
          }
        },
        builder: (context, state) {
          if (_isEditing && _isLoading) {
            return const LoadingIndicator(message: 'Loading task data...');
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'Please enter a title' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'Please enter a description' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<TaskPriority>(
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedPriority,
                    items: TaskPriority.values.map((priority) {
                      String label = priority.name;
                      Color color = switch (priority) {
                        TaskPriority.high => Colors.red,
                        TaskPriority.medium => Colors.orange,
                        TaskPriority.low => Colors.green,
                      };
                      return DropdownMenuItem<TaskPriority>(
                        value: priority,
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(label),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _selectedPriority = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  if (_isEditing)
                    DropdownButtonFormField<TaskStatus>(
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedStatus,
                      items: TaskStatus.values.map((status) {
                        String label = status.name;
                        Color color = switch (status) {
                          TaskStatus.todo => Colors.blue,
                          TaskStatus.inProgress => Colors.orange,
                          TaskStatus.done => Colors.green,
                        };
                        return DropdownMenuItem<TaskStatus>(
                          value: status,
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(label),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _selectedStatus = value);
                      },
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveTask();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        _isEditing ? 'Update Task' : 'Create Task',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _saveTask() {
    final task = Task(
      id: _isEditing ? widget.taskId : null,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      status: _selectedStatus,
      priority: _selectedPriority,
      createdDate: _isEditing
          ? (context.read<TaskBloc>().state.selectedTask?.createdDate ?? DateTime.now())
          : DateTime.now(),
    );

    if (_isEditing) {
      context.read<TaskBloc>().add(UpdateTaskEvent(task));
    } else {
      context.read<TaskBloc>().add(CreateTaskEvent(task));
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isEditing ? 'Task updated' : 'Task created')),
    );
  }
}

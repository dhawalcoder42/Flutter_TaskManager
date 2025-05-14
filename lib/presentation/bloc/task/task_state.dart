import 'package:equatable/equatable.dart';
import '../../../../data/models/task.dart';

enum TaskStateStatus { initial, loading, loaded, error }

class TaskState extends Equatable {
  final TaskStateStatus status;
  final List<Task> tasks;
  final Task? selectedTask;
  final String? errorMessage;
  final TaskStatus? filterStatus;
  final String? searchQuery;

  const TaskState({
    this.status = TaskStateStatus.initial,
    this.tasks = const [],
    this.selectedTask,
    this.errorMessage,
    this.filterStatus,
    this.searchQuery,
  });

  // Create a new instance with updated fields
  TaskState copyWith({
    TaskStateStatus? status,
    List<Task>? tasks,
    Task? selectedTask,
    String? errorMessage,
    TaskStatus? filterStatus,
    String? searchQuery,
    bool clearSelectedTask = false,
    bool clearErrorMessage = false,
    bool clearFilterStatus = false,
    bool clearSearchQuery = false,
  }) {
    return TaskState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      selectedTask: clearSelectedTask ? null : selectedTask ?? this.selectedTask,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      filterStatus: clearFilterStatus ? null : filterStatus ?? this.filterStatus,
      searchQuery: clearSearchQuery ? null : searchQuery ?? this.searchQuery,
    );
  }

  // Check if the state is in loading state
  bool get isLoading => status == TaskStateStatus.loading;

  // Filter tasks based on status if filter is applied
  List<Task> get filteredTasks {
    if (filterStatus != null) {
      return tasks.where((task) => task.status == filterStatus).toList();
    }
    return tasks;
  }

  // Search tasks based on query if search is applied
  List<Task> get searchedTasks {
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      return filteredTasks.where((task) => 
        task.title.toLowerCase().contains(searchQuery!.toLowerCase()) ||
        task.description.toLowerCase().contains(searchQuery!.toLowerCase())
      ).toList();
    }
    return filteredTasks;
  }

  // Get the final list of tasks after applying all filters
  List<Task> get displayTasks => searchedTasks;

  @override
  List<Object?> get props => [
    status, 
    tasks, 
    selectedTask, 
    errorMessage, 
    filterStatus, 
    searchQuery
  ];
}
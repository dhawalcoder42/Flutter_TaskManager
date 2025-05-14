import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/repositories/i_task_repository.dart';
import '../../../../data/models/task.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final ITaskRepository taskRepository;

  TaskBloc({required this.taskRepository}) : super(const TaskState()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<LoadTaskEvent>(_onLoadTask);
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<FilterTasksByStatusEvent>(_onFilterTasksByStatus);
    on<SearchTasksEvent>(_onSearchTasks);
  }

  Future<void> _onLoadTasks(LoadTasksEvent event, Emitter<TaskState> emit) async {
    try {
      emit(state.copyWith(status: TaskStateStatus.loading));
      final tasks = await taskRepository.getAllTasks();
      emit(state.copyWith(
        status: TaskStateStatus.loaded,
        tasks: tasks,
        clearErrorMessage: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TaskStateStatus.error,
        errorMessage: 'Failed to load tasks: $e',
      ));
    }
  }

  Future<void> _onLoadTask(LoadTaskEvent event, Emitter<TaskState> emit) async {
    try {
      emit(state.copyWith(status: TaskStateStatus.loading));
      final task = await taskRepository.getTaskById(event.taskId);
      if (task != null) {
        emit(state.copyWith(
          status: TaskStateStatus.loaded,
          selectedTask: task,
          clearErrorMessage: true,
        ));
      } else {
        emit(state.copyWith(
          status: TaskStateStatus.error,
          errorMessage: 'Task not found',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: TaskStateStatus.error,
        errorMessage: 'Failed to load task: $e',
      ));
    }
  }

  Future<void> _onCreateTask(CreateTaskEvent event, Emitter<TaskState> emit) async {
    try {
      emit(state.copyWith(status: TaskStateStatus.loading));
      final createdTask = await taskRepository.createTask(event.task);
      final updatedTasks = List<Task>.from(state.tasks)..add(createdTask);
      emit(state.copyWith(
        status: TaskStateStatus.loaded,
        tasks: updatedTasks,
        selectedTask: createdTask,
        clearErrorMessage: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TaskStateStatus.error,
        errorMessage: 'Failed to create task: $e',
      ));
    }
  }

  Future<void> _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    try {
      emit(state.copyWith(status: TaskStateStatus.loading));
      final updatedTask = await taskRepository.updateTask(event.task);
      final updatedTasks = state.tasks.map((task) =>
          task.id == updatedTask.id ? updatedTask : task).toList();
      emit(state.copyWith(
        status: TaskStateStatus.loaded,
        tasks: updatedTasks,
        selectedTask: updatedTask,
        clearErrorMessage: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TaskStateStatus.error,
        errorMessage: 'Failed to update task: $e',
      ));
    }
  }

  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    try {
      emit(state.copyWith(status: TaskStateStatus.loading));
      final success = await taskRepository.deleteTask(event.taskId);
      if (success) {
        final updatedTasks = state.tasks.where((task) => task.id != event.taskId).toList();
        emit(state.copyWith(
          status: TaskStateStatus.loaded,
          tasks: updatedTasks,
          clearSelectedTask: state.selectedTask?.id == event.taskId,
          clearErrorMessage: true,
        ));
      } else {
        emit(state.copyWith(
          status: TaskStateStatus.error,
          errorMessage: 'Failed to delete task',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: TaskStateStatus.error,
        errorMessage: 'Failed to delete task: $e',
      ));
    }
  }

  void _onFilterTasksByStatus(FilterTasksByStatusEvent event, Emitter<TaskState> emit) {
    emit(state.copyWith(
      filterStatus: event.status,
      clearErrorMessage: true,
    ));
  }

  void _onSearchTasks(SearchTasksEvent event, Emitter<TaskState> emit) {
    emit(state.copyWith(
      searchQuery: event.query,
      clearErrorMessage: true,
    ));
  }
}

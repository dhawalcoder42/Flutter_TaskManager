import 'package:equatable/equatable.dart';
import '../../../../data/models/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasksEvent extends TaskEvent {
  const LoadTasksEvent();
}

class LoadTaskEvent extends TaskEvent {
  final int taskId;

  const LoadTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class CreateTaskEvent extends TaskEvent {
  final Task task;

  const CreateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;

  const UpdateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  final int taskId;

  const DeleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class FilterTasksByStatusEvent extends TaskEvent {
  final TaskStatus status;

  const FilterTasksByStatusEvent(this.status);

  @override
  List<Object?> get props => [status];
}

class SearchTasksEvent extends TaskEvent {
  final String query;

  const SearchTasksEvent(this.query);

  @override
  List<Object?> get props => [query];
}

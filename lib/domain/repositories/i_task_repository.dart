import '../../data/models/task.dart';

abstract class ITaskRepository {
  Future<List<Task>> getAllTasks();
  Future<Task?> getTaskById(int id);
  Future<Task> createTask(Task task);
  Future<Task> updateTask(Task task);
  Future<bool> deleteTask(int id);
  Future<List<Task>> getTasksByStatus(TaskStatus status);
  Future<List<Task>> searchTasks(String query);
}
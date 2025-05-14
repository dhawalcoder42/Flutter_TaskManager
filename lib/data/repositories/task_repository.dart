import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../core/error/exceptions.dart';
import '../../../data/datasources/local/task_db.dart';
import '../../../data/datasources/remote/task_api.dart';
import '../../../data/models/task.dart';
import '../../../domain/repositories/i_task_repository.dart';

class TaskRepository implements ITaskRepository {
  final TaskApiService apiService;
  final TaskDatabase localDb;
  final Connectivity connectivity;

  TaskRepository({
    required this.apiService,
    required this.localDb,
    required this.connectivity,
  });

  // Check if the device is connected to the internet
  Future<bool> _isConnected() async {
    var connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Future<List<Task>> getAllTasks() async {
    try {
      // Try to get data from API if connected
      if (await _isConnected()) {
        final remoteTasks = await apiService.getTasks();
        
        // Update local database with new data
        await Future.forEach(remoteTasks, (Task task) async {
          final localTask = await localDb.read(task.id!);
          if (localTask == null) {
            await localDb.create(task);
          } else {
            await localDb.update(task);
          }
        });
      }
      
      // Return data from local database
      return await localDb.readAll();
    } on ApiException {
      // If API fails, fallback to local data
      return await localDb.readAll();
    } catch (e) {
      throw DatabaseException('Failed to get tasks: $e');
    }
  }

  @override
  Future<Task?> getTaskById(int id) async {
    try {
      // Try to get data from API if connected
      if (await _isConnected()) {
        try {
          final remoteTask = await apiService.getTask(id);
          // Update local database
          final localTask = await localDb.read(id);
          if (localTask == null) {
            await localDb.create(remoteTask);
          } else {
            await localDb.update(remoteTask);
          }
          return remoteTask;
        } on ApiException {
          // If API fails, fallback to local data
          return await localDb.read(id);
        }
      } else {
        // If not connected, use local data
        return await localDb.read(id);
      }
    } catch (e) {
      throw DatabaseException('Failed to get task: $e');
    }
  }

  @override
  Future<Task> createTask(Task task) async {
    try {
      // Try to create on API if connected
      if (await _isConnected()) {
        try {
          final remoteTask = await apiService.createTask(task);
          // Save to local database
          final id = await localDb.create(remoteTask);
          return remoteTask.copyWith(id: id);
        } on ApiException {
          // If API fails, save only locally
          final id = await localDb.create(task);
          return task.copyWith(id: id);
        }
      } else {
        // If not connected, save locally
        final id = await localDb.create(task);
        return task.copyWith(id: id);
      }
    } catch (e) {
      throw DatabaseException('Failed to create task: $e');
    }
  }

  @override
  Future<Task> updateTask(Task task) async {
    try {
      // Try to update on API if connected
      if (await _isConnected()) {
        try {
          final remoteTask = await apiService.updateTask(task);
          // Update local database
          await localDb.update(remoteTask);
          return remoteTask;
        } on ApiException {
          // If API fails, update only locally
          await localDb.update(task);
          return task;
        }
      } else {
        // If not connected, update locally
        await localDb.update(task);
        return task;
      }
    } catch (e) {
      throw DatabaseException('Failed to update task: $e');
    }
  }

  @override
  Future<bool> deleteTask(int id) async {
    try {
      // Try to delete on API if connected
      if (await _isConnected()) {
        try {
          await apiService.deleteTask(id);
        } on ApiException {
          // Continue with local deletion even if API fails
        }
      }
      
      // Delete from local database
      final result = await localDb.delete(id);
      return result > 0;
    } catch (e) {
      throw DatabaseException('Failed to delete task: $e');
    }
  }

  @override
  Future<List<Task>> getTasksByStatus(TaskStatus status) async {
    try {
      // Get tasks from local database filtered by status
      return await localDb.getTasksByStatus(status);
    } catch (e) {
      throw DatabaseException('Failed to get tasks by status: $e');
    }
  }

  @override
  Future<List<Task>> searchTasks(String query) async {
    try {
      // Search tasks in local database
      return await localDb.searchTasks(query);
    } catch (e) {
      throw DatabaseException('Failed to search tasks: $e');
    }
  }
}
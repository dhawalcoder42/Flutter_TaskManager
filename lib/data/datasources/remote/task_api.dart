import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/error/exceptions.dart';
import '../../../data/models/task.dart';

class TaskApiService {
  final String baseUrl;
  final http.Client client;

  TaskApiService({required this.baseUrl, required this.client});

  factory TaskApiService.mock() {
    return TaskApiService(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      client: http.Client(),
    );
  }

  Future<Task> createTask(Task task) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/todos'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(task.toJson()),
      );

      if (response.statusCode == 201) {
        return Task.fromJson(json.decode(response.body));
      } else {
        throw ApiException('Failed to create task: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  Future<List<Task>> getTasks() async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/todos'));

      if (response.statusCode == 200) {
        final List<dynamic> tasksJson = json.decode(response.body);
        return tasksJson.map((task) {
          return Task(
            id: task['id'],
            title: task['title'],
            description: task['title'],
            status: task['completed'] ? TaskStatus.done : TaskStatus.todo,
            createdDate: DateTime.now(),
            priority: TaskPriority.medium,
          );
        }).toList();
      } else {
        throw ApiException('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  Future<Task> getTask(int id) async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/todos/$id'));

      if (response.statusCode == 200) {
        final taskJson = json.decode(response.body);
        return Task(
          id: taskJson['id'],
          title: taskJson['title'],
          description: taskJson['title'],
          status: taskJson['completed'] ? TaskStatus.done : TaskStatus.todo,
          createdDate: DateTime.now(),
          priority: TaskPriority.medium,
        );
      } else {
        throw ApiException('Failed to load task: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  Future<Task> updateTask(Task task) async {
    try {
      final response = await client.put(
        Uri.parse('$baseUrl/todos/${task.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(task.toJson()),
      );

      if (response.statusCode == 200) {
        return Task.fromJson(json.decode(response.body));
      } else {
        throw ApiException('Failed to update task: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  Future<bool> deleteTask(int id) async {
    try {
      final response = await client.delete(Uri.parse('$baseUrl/todos/$id'));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw ApiException('Failed to delete task: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }
}

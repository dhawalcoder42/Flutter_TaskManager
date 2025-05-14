import 'package:equatable/equatable.dart';

enum TaskStatus { todo, inProgress, done }
enum TaskPriority { low, medium, high }

class Task extends Equatable {
  final int? id;
  final String title;
  final String description;
  final TaskStatus status;
  final DateTime createdDate;
  final TaskPriority priority;

  const Task({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdDate,
    required this.priority,
  });

  @override
  List<Object?> get props => [id, title, description, status, createdDate, priority];

  Task copyWith({
    int? id,
    String? title,
    String? description,
    TaskStatus? status,
    DateTime? createdDate,
    TaskPriority? priority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdDate: createdDate ?? this.createdDate,
      priority: priority ?? this.priority,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.index,
      'created_date': createdDate.toIso8601String(),
      'priority': priority.index,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'],
      description: map['description'],
      status: TaskStatus.values[map['status']],
      createdDate: DateTime.parse(map['created_date']),
      priority: TaskPriority.values[map['priority']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.index,
      'createdDate': createdDate.toIso8601String(),
      'priority': priority.index,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: TaskStatus.values[json['status']],
      createdDate: DateTime.parse(json['createdDate']),
      priority: TaskPriority.values[json['priority']],
    );
  }
}

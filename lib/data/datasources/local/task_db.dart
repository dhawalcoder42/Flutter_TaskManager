import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../../data/models/task.dart';

class TaskDatabase {
  static final TaskDatabase instance = TaskDatabase._init();
  static Database? _database;

  TaskDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        status INTEGER NOT NULL,
        created_date TEXT NOT NULL,
        priority INTEGER NOT NULL
      )
    ''');
  }

  Future<int> create(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> readAll() async {
    final db = await database;
    final result = await db.query('tasks');
    return result.map((map) => Task.fromMap(map)).toList();
  }

  Future<Task?> read(int id) async {
    final db = await database;
    final result = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) return Task.fromMap(result.first);
    return null;
  }

  Future<int> update(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Task>> getTasksByStatus(TaskStatus status) async {
    final db = await database;
    final result = await db.query(
      'tasks',
      where: 'status = ?',
      whereArgs: [status.index],
    );
    return result.map((map) => Task.fromMap(map)).toList();
  }

  Future<List<Task>> getTasksByPriority(TaskPriority priority) async {
    final db = await database;
    final result = await db.query(
      'tasks',
      where: 'priority = ?',
      whereArgs: [priority.index],
    );
    return result.map((map) => Task.fromMap(map)).toList();
  }

  Future<List<Task>> searchTasks(String query) async {
    final db = await database;
    final result = await db.query(
      'tasks',
      where: 'title LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return result.map((map) => Task.fromMap(map)).toList();
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}

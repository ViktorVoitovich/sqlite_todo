import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static DatabaseService instance = DatabaseService._();
  static Database? _db;

  static const String _todosTable = 'todos_table';
  static const String _colId = 'id';
  static const String _colName = 'name';
  static const String _colDate = 'date';
  static const String _colPriorityLevel = 'priority_level';
  static const String _colCompleted = 'completed';

  const DatabaseService._();

  Future<Database> get db async {
    _db ??= await _openDb();
    return _db!;
  }

  Future<Database> _openDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = dir.path + '/todo_list.db';
    final todoListDb = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $_todosTable (
            $_colId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_colName TEXT,
            $_colDate TEXT,
            $_colPriorityLevel TEXT,
            $_colCompleted INTEGER,
          )
        ''');
      },
    );

    return todoListDb;
  }
}

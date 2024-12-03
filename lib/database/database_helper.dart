import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'students.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Одногруппники(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fio TEXT,
        time_added TEXT
      );
    ''');

    // Заполнение базы 5 записями
    var students = [
      ['Рыжков А. С.', DateTime.now().toString()],
      ['Тамбовцева Н. Т.', DateTime.now().toString()],
      ['Петров П. П.', DateTime.now().toString()],
      ['Сидоров С. С.', DateTime.now().toString()],
      ['Михайлов М. М.', DateTime.now().toString()],
    ];

    for (var student in students) {
      await db.insert('Одногруппники', {
        'fio': student[0],
        'time_added': student[1],
      });
    }
  }

  Future<List<Map<String, dynamic>>> getAllRecords() async {
    final db = await database;
    return await db.query('Одногруппники');
  }

  Future<void> addRecord(String fio) async {
    final db = await database;
    await db.insert('Одногруппники', {
      'fio': fio,
      'time_added': DateTime.now().toString(),
    });
  }

  Future<void> updateLastRecord() async {
    final db = await database;
    var lastRecord = await db.rawQuery('SELECT * FROM Одногруппники ORDER BY id DESC LIMIT 1');
    if (lastRecord.isNotEmpty) {
      await db.update(
        'Одногруппники',
        {'fio': 'Иванов И. И.'},
        where: 'id = ?',
        whereArgs: [lastRecord[0]['id']],
      );
    }
  }

  Future<void> clearDatabase() async {
    final db = await database;

    // Удаление всех записей из таблицы
    await db.delete('Одногруппники');

    // Сброс автоинкрементного ID
    await db.rawDelete('DELETE FROM sqlite_sequence WHERE name = "Одногруппники"');
  }

}

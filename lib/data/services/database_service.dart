import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'book_finder.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTable,
    );
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        author_name TEXT NOT NULL,
        cover_i INTEGER NOT NULL,
        book_key TEXT NOT NULL UNIQUE,
        olid TEXT
      )
    ''');
  }

  Future<int> insertFavorite(BookDoc book) async {
    final db = await database;
    return await db.insert(
      'favorites',
      book.toDbMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> removeFavorite(String bookKey) async {
    final db = await database;
    return await db.delete(
      'favorites',
      where: 'book_key = ?',
      whereArgs: [bookKey],
    );
  }

  Future<List<BookDoc>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return List.generate(maps.length, (i) => BookDoc.fromDb(maps[i]));
  }

  Future<bool> isFavorite(String bookKey) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'book_key = ?',
      whereArgs: [bookKey],
    );
    return result.isNotEmpty;
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

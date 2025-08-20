import 'package:assignment4/data/models/post.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PostDatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'post.db');
    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
    CREATE TABLE posts(
      id INTEGER PRIMARY KEY,   -- matches "id" in JSON
      userId INTEGER NOT NULL,  -- userId
      title TEXT NOT NULL,      -- title
      body TEXT NOT NULL,        -- body
      isFavorite INTEGER DEFAULT 0 -- default to not favorite
    )
  ''');
  }

  Future<int> insertFavorite(PostDoc book) async {
    final db = await database;
    return await db.insert(
      'posts',
      book.toDbMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> removeFavorite(int? id) async {
    final db = await database;
    return await db.delete('posts', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<PostDoc>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('posts');
    return List.generate(maps.length, (i) => PostDoc.fromDbMap(maps[i]));
  }

  Future<bool> isFavorite(int bookKey) async {
    final db = await database;
    final result = await db.query(
      'posts',
      where: 'id = ?',
      whereArgs: [bookKey],
    );
    // print("Checking if post with id $bookKey is favorite: $result");
    return result.isNotEmpty;
  }
}

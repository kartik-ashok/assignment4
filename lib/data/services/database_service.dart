// import 'package:path/path.dart';
// import '../models/book.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseService {
//   static Database? _database;
//   static const String _tableName = 'books';

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), 'book_finder.db');
//     return await openDatabase(path, version: 1, onCreate: _createTable);
//   }

//   Future<void> _createTable(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE $_tableName(
//         key TEXT PRIMARY KEY,
//         title TEXT NOT NULL,
//         authors TEXT NOT NULL,
//         coverImage TEXT,
//         firstPublishedYear INTEGER,
//         description TEXT,
//         subjects TEXT,
//         isSaved INTEGER NOT NULL
//       )
//     ''');
//   }

//   Future<void> saveBook(Book book) async {
//     final db = await database;
//     await db.insert(_tableName, {
//       'key': book.key,
//       'title': book.title,
//       'authors': book.authors.join('|'),
//       'coverImage': book.coverImage,
//       'firstPublishedYear': book.firstPublishedYear,
//       'description': book.description,
//       'subjects': book.subjects.join('|'),
//       'isSaved': 1,
//     }, conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   Future<void> removeBook(String bookKey) async {
//     final db = await database;
//     await db.delete(_tableName, where: 'key = ?', whereArgs: [bookKey]);
//   }

//   Future<List<Book>> getSavedBooks() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query(_tableName);

//     return List.generate(maps.length, (i) {
//       return Book(
//         key: maps[i]['key'],
//         title: maps[i]['title'],
//         authors: maps[i]['authors'].split('|'),
//         coverImage: maps[i]['coverImage'],
//         firstPublishedYear: maps[i]['firstPublishedYear'],
//         description: maps[i]['description'],
//         subjects: maps[i]['subjects']?.split('|') ?? [],
//         isSaved: true,
//       );
//     });
//   }

//   Future<bool> isBookSaved(String bookKey) async {
//     final db = await database;
//     final result = await db.query(
//       _tableName,
//       where: 'key = ?',
//       whereArgs: [bookKey],
//     );
//     return result.isNotEmpty;
//   }

//   Future<void> close() async {
//     final db = await database;
//     await db.close();
//   }
// }

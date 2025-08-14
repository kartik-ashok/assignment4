import '../models/book.dart';
import '../services/book_api_service.dart';
import '../services/database_service.dart';

class BookRepository {
  final BookApiService _apiService;
  final DatabaseService _databaseService;

  BookRepository({
    BookApiService? apiService,
    DatabaseService? databaseService,
  }) : _apiService = apiService ?? BookApiService(),
       _databaseService = databaseService ?? DatabaseService();

  Future<Book> fetchBooks(String query, {int page = 1, int limit = 20}) async {
    try {
      return await _apiService.fetchBooks(query, page: page, limit: limit);
    } catch (e) {
      throw Exception('Failed to fetch books: $e');
    }
  }

  Future<List<BookDoc>> getFavorites() async {
    try {
      return await _databaseService.getFavorites();
    } catch (e) {
      throw Exception('Failed to get favorites: $e');
    }
  }

  Future<bool> isFavorite(String bookKey) async {
    try {
      return await _databaseService.isFavorite(bookKey);
    } catch (e) {
      throw Exception('Failed to check favorite status: $e');
    }
  }

  Future<void> toggleFavorite(BookDoc book) async {
    try {
      if (book.isFavorite) {
        await _databaseService.removeFavorite(book.key ?? '');
      } else {
        await _databaseService.insertFavorite(book);
      }
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }

  Future<void> addToFavorites(BookDoc book) async {
    try {
      await _databaseService.insertFavorite(book);
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  Future<void> removeFromFavorites(String bookKey) async {
    try {
      await _databaseService.removeFavorite(bookKey);
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }
}

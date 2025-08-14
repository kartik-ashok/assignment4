import '../models/book.dart';
import '../services/book_api_service.dart';

class BookRepository {
  final BookApiService _apiService;

  BookRepository({BookApiService? apiService})
    : _apiService = apiService ?? BookApiService();

  Future<Book> fetchBooks(String query, {int page = 0, int limit = 20}) async {
    try {
      return await _apiService.fetchBooks(query, page: page, limit: limit);
    } catch (e) {
      throw Exception('Failed to fetch books: $e');
    }
  }
}

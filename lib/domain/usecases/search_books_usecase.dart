import '../../data/models/book.dart';
import '../../data/repositories/book_repository.dart';

class FetchBooksUseCase {
  final BookRepository _repository;

  FetchBooksUseCase(this._repository);

  Future<Book> execute(String query, {int page = 0, int limit = 20}) async {
    if (query.trim().isEmpty) {
      return Book(docs: []);
    }
    return await _repository.fetchBooks(query, page: page, limit: limit);
  }
}

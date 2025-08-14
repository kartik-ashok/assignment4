import '../../data/models/book.dart';
import '../../data/models/book_details.dart';
import '../../data/repositories/book_repository.dart';

class FetchBooksUseCase {
  final BookRepository _repository;

  FetchBooksUseCase(this._repository);

  Future<Book> execute(String query, {int page = 1, int limit = 20}) async {
    if (query.trim().isEmpty) {
      return Book(docs: []);
    }
    return await _repository.fetchBooks(query, page: page, limit: limit);
  }
}

class GetBookDetailsUseCase {
  final BookRepository _repository;

  GetBookDetailsUseCase(this._repository);

  Future<BookDetails> execute(String workKey) async {
    return await _repository.fetchBookDetails(workKey);
  }
}

class GetFavoritesUseCase {
  final BookRepository _repository;

  GetFavoritesUseCase(this._repository);

  Future<List<BookDoc>> execute() async {
    return await _repository.getFavorites();
  }
}

class ToggleFavoriteUseCase {
  final BookRepository _repository;

  ToggleFavoriteUseCase(this._repository);

  Future<void> execute(BookDoc book) async {
    await _repository.toggleFavorite(book);
  }
}

class CheckFavoriteUseCase {
  final BookRepository _repository;

  CheckFavoriteUseCase(this._repository);

  Future<bool> execute(String bookKey) async {
    return await _repository.isFavorite(bookKey);
  }
}

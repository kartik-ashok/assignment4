import 'package:flutter/foundation.dart';
import '../../data/models/book.dart';
import '../../domain/usecases/search_books_usecase.dart';

class BookProvider extends ChangeNotifier {
  final FetchBooksUseCase _fetchBooksUseCase;
  final GetFavoritesUseCase _getFavoritesUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;
  final CheckFavoriteUseCase _checkFavoriteUseCase;

  BookProvider({
    required FetchBooksUseCase fetchBooksUseCase,
    required GetFavoritesUseCase getFavoritesUseCase,
    required ToggleFavoriteUseCase toggleFavoriteUseCase,
    required CheckFavoriteUseCase checkFavoriteUseCase,
  }) : _fetchBooksUseCase = fetchBooksUseCase,
       _getFavoritesUseCase = getFavoritesUseCase,
       _toggleFavoriteUseCase = toggleFavoriteUseCase,
       _checkFavoriteUseCase = checkFavoriteUseCase;

  // State variables
  List<BookDoc> _currentBooks = [];
  List<BookDoc> _favorites = [];
  bool _isLoading = false;
  String _error = '';
  int _currentPage = 1;
  int _totalPages = 1;
  String _currentQuery = '';
  int _totalBooks = 0;

  // Getters
  List<BookDoc> get currentBooks => _currentBooks;
  List<BookDoc> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String get error => _error;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalBooks => _totalBooks;
  bool get hasNextPage => _currentPage < _totalPages;
  bool get hasPrevPage => _currentPage > 1;

  // Fetch books for a specific page
  Future<void> fetchBooks(String query, {int page = 1}) async {
    if (query.trim().isEmpty) {
      _currentBooks.clear();
      _error = '';
      _currentPage = 1;
      _totalPages = 1;
      _totalBooks = 0;
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _error = '';
      _currentQuery = query;
      _currentPage = page;
      notifyListeners();

      final book = await _fetchBooksUseCase.execute(
        query,
        page: page,
        limit: 20,
      );
      _currentBooks = book.docs ?? [];
      _totalBooks = book.numFound ?? 0;
      _totalPages = (_totalBooks / 20).ceil();

      // Update favorite status for current books
      await _updateFavoriteStatus();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Go to next page
  Future<void> nextPage() async {
    if (hasNextPage) {
      await fetchBooks(_currentQuery, page: _currentPage + 1);
    }
  }

  // Go to previous page
  Future<void> prevPage() async {
    if (hasPrevPage) {
      await fetchBooks(_currentQuery, page: _currentPage - 1);
    }
  }

  // Go to specific page
  Future<void> goToPage(int page) async {
    if (page >= 1 && page <= _totalPages) {
      await fetchBooks(_currentQuery, page: page);
    }
  }

  // Load favorites
  Future<void> loadFavorites() async {
    try {
      _favorites = await _getFavoritesUseCase.execute();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Toggle favorite
  Future<void> toggleFavorite(BookDoc book) async {
    try {
      await _toggleFavoriteUseCase.execute(book);

      // Update the book's favorite status
      final updatedBook = book.copyWith(isFavorite: !book.isFavorite);

      // Update in current books list
      final bookIndex = _currentBooks.indexWhere((b) => b.key == book.key);
      if (bookIndex != -1) {
        _currentBooks[bookIndex] = updatedBook;
      }

      // Update in favorites list
      if (updatedBook.isFavorite) {
        _favorites.add(updatedBook);
      } else {
        _favorites.removeWhere((b) => b.key == book.key);
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Update favorite status for current books
  Future<void> _updateFavoriteStatus() async {
    for (int i = 0; i < _currentBooks.length; i++) {
      final book = _currentBooks[i];
      if (book.key != null) {
        final isFavorite = await _checkFavoriteUseCase.execute(book.key!);
        _currentBooks[i] = book.copyWith(isFavorite: isFavorite);
      }
    }
    notifyListeners();
  }

  // Clear books
  void clearBooks() {
    _currentBooks.clear();
    _error = '';
    _currentPage = 1;
    _totalPages = 1;
    _totalBooks = 0;
    _currentQuery = '';
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = '';
    notifyListeners();
  }
}

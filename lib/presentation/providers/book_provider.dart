import 'package:assignment4/domain/usecases/search_books_usecase.dart';
import 'package:flutter/foundation.dart';
import '../../data/models/book.dart';

class BookProvider extends ChangeNotifier {
  final FetchBooksUseCase _fetchBooksUseCase;

  BookProvider({required FetchBooksUseCase fetchBooksUseCase})
    : _fetchBooksUseCase = fetchBooksUseCase;

  // State variables
  List<Docs> _allBooks = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String _error = '';
  int _currentPage = 0;
  bool _hasMorePages = true;
  String _currentQuery = '';

  // Getters
  List<Docs> get allBooks => _allBooks;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String get error => _error;
  bool get hasMorePages => _hasMorePages;

  // Fetch books (first page)
  Future<void> fetchBooks(String query) async {
    if (query.trim().isEmpty) {
      _allBooks.clear();
      _error = '';
      _currentPage = 0;
      _hasMorePages = true;
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _error = '';
      _currentPage = 0;
      _hasMorePages = true;
      _currentQuery = query;
      notifyListeners();

      final book = await _fetchBooksUseCase.execute(query, page: 0, limit: 20);
      _allBooks = book.docs ?? [];
      _hasMorePages = (_allBooks.length == 20) && (book.numFound ?? 0) > 20;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load more books (next page)
  Future<void> loadMoreBooks() async {
    if (_isLoadingMore || !_hasMorePages || _currentQuery.isEmpty) return;

    try {
      _isLoadingMore = true;
      notifyListeners();

      final nextPage = _currentPage + 1;
      final book = await _fetchBooksUseCase.execute(
        _currentQuery,
        page: nextPage,
        limit: 20,
      );

      if (book.docs != null && book.docs!.isNotEmpty) {
        _allBooks.addAll(book.docs!);
        _currentPage = nextPage;
        _hasMorePages =
            (book.docs!.length == 20) &&
            (_allBooks.length < (book.numFound ?? 0));
      } else {
        _hasMorePages = false;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // Clear books
  void clearBooks() {
    _allBooks.clear();
    _error = '';
    _currentPage = 0;
    _hasMorePages = true;
    _currentQuery = '';
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = '';
    notifyListeners();
  }
}
